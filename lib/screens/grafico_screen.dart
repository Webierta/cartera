import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';

class GraficoScreen extends StatefulWidget {
  final List<HistoricoData> historico;
  const GraficoScreen({super.key, required this.historico});
  @override
  State<GraficoScreen> createState() => _GraficoScreenState();
}

class _GraficoScreenState extends State<GraficoScreen> {
  List<String> filtros = ['Total', 'Interanual', 'Anual'];
  String filtroSelect = 'Total';
  Set<String> years = {};
  List<HistoricoData> historicoFiltro = [];

  double intervalo = 2829743 * 6;
  String formato = 'MMMyy';

  @override
  void initState() {
    historicoFiltro = [...widget.historico];
    filtroSelect = filtros.first;
    for (var hist in widget.historico) {
      years.add(hist.fecha.year.toString());
    }
    filtros.addAll(years);
    super.initState();
  }

  LineChartBarData getLineChart(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      color: color,
      barWidth: 2,
      isCurved: false,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.5),
            color.withOpacity(0),
          ],
          stops: const [0.5, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  HorizontalLine getHorizontalLine({required double y}) {
    return HorizontalLine(
      y: y,
      color: Colors.grey,
      strokeWidth: 2,
      dashArray: [2, 2],
      label: HorizontalLineLabel(
        show: true,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          background: Paint()
            //..color = const Color(0xFFFFFFFF)
            ..strokeWidth = 17
            ..style = PaintingStyle.stroke,
        ),
        alignment: Alignment.topLeft,
        labelResolver: (line) => 'Media: ${NumberUtil.decimalFixed(y)} €',
        //labelResolver: (line) => 'Máx: ${fecha ?? ''}: ${NumberUtil.decimalFixed(y)} €',
      ),
    );
  }

  void changeFiltroSelect() {
    if (filtroSelect == 'Total') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [...widget.historico];
        intervalo = 2829743 * 6;
        formato = 'MMMyy';
      });
    } else if (filtroSelect == 'Interanual') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [
          ...widget.historico.where((hist) => hist.fecha.month == 12)
        ];
        intervalo = 30556926;
        formato = 'yyyy';
      });
    } else if (filtroSelect == 'Anual') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [
          ...widget.historico
              .where((hist) => hist.fecha.year == DateTime.now().year)
        ];
        intervalo = 2529743; //2629743;
        formato = 'MMM';
      });
    } else if (years.contains(filtroSelect)) {
      setState(() {
        historicoFiltro.clear();
        for (String year in years) {
          if (filtroSelect == year) {
            historicoFiltro = [
              ...widget.historico
                  .where((hist) => hist.fecha.year == (int.tryParse(year) ?? 0))
            ];
          }
        }
        intervalo = 2529743; //2629743;
        formato = 'MMM';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<double> totales = historicoFiltro.map((h) {
      return h.totalCuentas + h.totalDepositos + h.totalFondos;
    }).toList();
    //final List<int> fechas = historicoFiltro.map((h) => FechaUtil.dateToEpoch(h.fecha)).toList();

    double totalMedio = 0;
    double totalMax = 0;
    //double totalMin = 0;
    //String? fechaMax;
    //String? fechaMin;

    if (totales.length > 1) {
      totalMedio = totales.reduce((a, b) => a + b) / totales.length;
      totalMax = totales.reduce((curr, next) => curr > next ? curr : next);
      //totalMin = totales.reduce((curr, next) => curr < next ? curr : next);
      //fechaMax = FechaUtil.epochToString(fechas[totales.indexOf(totalMax)]);
      //fechaMin = FechaUtil.epochToString(fechas[totales.indexOf(totalMin)]);
    }

    Map<int, double> mapDataCuentas = {};
    Map<int, double> mapDataDepositos = {};
    Map<int, double> mapDataFondos = {};
    Map<int, double> mapDataTotal = {};
    for (var h in historicoFiltro) {
      double hTotal = h.totalCuentas + h.totalDepositos + h.totalFondos;
      mapDataCuentas[FechaUtil.dateToEpoch(h.fecha)] = h.totalCuentas;
      mapDataDepositos[FechaUtil.dateToEpoch(h.fecha)] = h.totalDepositos;
      mapDataFondos[FechaUtil.dateToEpoch(h.fecha)] = h.totalFondos;
      mapDataTotal[FechaUtil.dateToEpoch(h.fecha)] = hTotal;
    }
    List<FlSpot> spotsCuentas = <FlSpot>[
      for (final entry in mapDataCuentas.entries)
        FlSpot(entry.key.toDouble(), entry.value)
    ];

    List<FlSpot> spotsDepositos = <FlSpot>[
      for (final entry in mapDataDepositos.entries)
        FlSpot(entry.key.toDouble(), entry.value)
    ];

    List<FlSpot> spotsFondos = <FlSpot>[
      for (final entry in mapDataFondos.entries)
        FlSpot(entry.key.toDouble(), entry.value)
    ];

    List<FlSpot> spotsTotal = <FlSpot>[
      for (final entry in mapDataTotal.entries)
        FlSpot(entry.key.toDouble(), entry.value)
    ];

    final lineChartData = LineChartData(
      lineBarsData: [
        getLineChart(spotsTotal, Colors.amber),
        getLineChart(spotsCuentas, Colors.blue),
        getLineChart(spotsDepositos, Colors.green),
        getLineChart(spotsFondos, Colors.red),
      ],
      maxY: (totalMax.ceil().toDouble() + 1000),
      minY: 0,
      //minX: (fechas.last).toDouble() - (2629743 * 6),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          //tooltipBgColor: const Color(0xFF000000),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              var epoch = touchedSpot.x.toInt();
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
              var fecha = FechaUtil.dateToString(
                date: dateTime,
                formato: formato,
              );
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors[0] ??
                    touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              if (touchedSpot.barIndex == 0) {
                return LineTooltipItem(
                    fecha, const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                    children: [
                      TextSpan(
                        text: '\n${NumberUtil.currency(touchedSpot.y)}',
                        style: textStyle,
                      ),
                    ]);
              } else {
                return LineTooltipItem(
                  NumberUtil.currency(touchedSpot.y),
                  textStyle,
                  textAlign: TextAlign.right,
                );
              }
              //'${touchedSpot.y.toStringAsFixed(2)} €', textStyle);
            }).toList();
          },
        ),
        touchCallback: (_, __) {},
        handleBuiltInTouches: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (double value, TitleMeta meta) {
              return const Text('');
            },
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //reservedSize: 80,
            getTitlesWidget: (double value, TitleMeta meta) {
              return const Text('');
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            //interval: 2000,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //reservedSize: 20,
            //interval: 2629743 * 6,
            interval: intervalo,
            getTitlesWidget: (double value, TitleMeta meta) {
              final epoch = value.toInt();
              DateTime dateTime = FechaUtil.epochToDate(epoch);
              if (value == spotsTotal.last.x || value == spotsTotal.first.x) {
                //return const Text('');
                return const SizedBox(width: 0, height: 0);
              }
              return Text(
                FechaUtil.dateToString(
                  date: dateTime,
                  formato: formato,
                ),
              );
            },
          ),
        ),
      ),
      extraLinesData: ExtraLinesData(
        horizontalLines: [
          getHorizontalLine(y: totalMedio),
          //getHorizontalLine(y: totalMax, txt: 'Máx', fecha: fechaMax),
          //getHorizontalLine(y: totalMin, txt: 'Min', fecha: fechaMin),
        ],
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Color(0xff37434d), width: 1),
          left: BorderSide(color: Color(0xff37434d), width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      ),
      gridData: const FlGridData(show: true),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico Histórico'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Wrap(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Leyenda(texto: 'Total', color: Colors.amber),
                const Leyenda(texto: 'Cuentas', color: Colors.blue),
                const Leyenda(texto: 'Depósitos', color: Colors.green),
                const Leyenda(texto: 'Fondos', color: Colors.red),
                const SizedBox(width: 60),
                DropdownButton<String>(
                  isDense: true,
                  value: filtroSelect,
                  alignment: Alignment.center,
                  onChanged: (String? value) {
                    setState(() => filtroSelect = value ?? filtros.first);
                    changeFiltroSelect();
                  },
                  items: filtros
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e.toUpperCase()),
                          ))
                      .toList(),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width,
                  child: spotsTotal.length > 1
                      ? LineChart(lineChartData)
                      : const Center(
                          child: Text('No hay suficientes datos'),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Leyenda extends StatelessWidget {
  final String texto;
  final Color color;
  const Leyenda({super.key, required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Chip(
          avatar: CircleAvatar(
            backgroundColor: color,
          ),
          label: Text(texto)),
    );
  }
}
