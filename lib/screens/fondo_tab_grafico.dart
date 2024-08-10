import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';

const Map<String, int> filtroTemp = {
  'Total': 0,
  'Últimos 30 días': 30,
  'Últimos 6 meses': 30 * 6,
  'Último año': 365,
  'Últimos 3 años': 365 * 3
};

class FondoTabGrafico extends ConsumerStatefulWidget {
  final FondoData fondo;
  const FondoTabGrafico({super.key, required this.fondo});
  @override
  ConsumerState<FondoTabGrafico> createState() => _FondoGraficoScreenState();
}

class _FondoGraficoScreenState extends ConsumerState<FondoTabGrafico> {
  late AppDatabase database;
  List<ValoresFondoData> valores = [];
  List<ValoresFondoData> valoresFilter = [];
  int filtroTempSelect = filtroTemp.values.first;

  double precioMedio = 0;
  double precioMax = 0;
  double precioMin = 0;
  String fechaMax = '';
  String fechaMin = '';
  int timestamp = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getValores();
    super.initState();
  }

  Future<void> getValores() async {
    final valoresFondo = await database.getValores(widget.fondo.id);
    setState(() => valores = valoresFondo);
    setValores();
  }

  void setValores() {
    if (filtroTempSelect != 0) {
      DateTime now = DateTime.now();
      DateTime lastTime = now.subtract(Duration(days: filtroTempSelect));
      //var lastEpoch = FechaUtil.dateToEpoch(lastTime);
      setState(() {
        valoresFilter =
            valores.where((v) => v.fecha.isAfter(lastTime)).toList();
        /*valoresFilter = valores
            .where((v) => FechaUtil.dateToEpoch(v.fecha) > lastEpoch)
            .toList();*/
      });
    } else {
      setState(() => valoresFilter = valores);
    }
    final List<double> precios =
        valoresFilter.reversed.map((v) => v.valor).toList();
    final List<int> fechas = valoresFilter.reversed
        .map((v) => FechaUtil.dateToEpoch(v.fecha))
        .toList();
    Stats stats = Stats(valoresFilter);
    setState(() {
      if (precios.length > 1) {
        timestamp = FechaUtil.epochToDate(fechas.last)
            .difference(FechaUtil.epochToDate(fechas.first))
            .inDays;
      }
      precioMedio = stats.precioMedio() ?? 0;
      precioMax = stats.precioMaximo() ?? 0;
      precioMin = stats.precioMinimo() ?? 0;
      fechaMax = FechaUtil.epochToString(stats.datePrecioMaximo() ?? 0);
      fechaMin = FechaUtil.epochToString(stats.datePrecioMinimo() ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<int>(
          isDense: true,
          value: filtroTempSelect,
          dropdownColor: Colors.white,
          focusColor: Colors.transparent,
          onChanged: (int? value) {
            setState(() => filtroTempSelect = value ?? 0);
            setValores();
          },
          items: filtroTemp
              .map((String txt, int value) => MapEntry(
                  txt,
                  DropdownMenuItem<int>(
                    value: value,
                    child: Text(txt),
                  )))
              .values
              .toList(),
        ),
        if (valoresFilter.length < 3)
          const Center(child: Text('Sin suficientes datos'))
        else
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 30,
                left: 5,
                right: 5,
                bottom: 10,
              ),
              width: MediaQuery.of(context).size.width,
              child: LineChart(mainData()),
            ),
          ),
      ],
    );
  }

  TextStyle labelGrafico = TextStyle(
    fontWeight: FontWeight.bold,
    background: Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 17
      ..style = PaintingStyle.stroke,
  );

  List<VerticalLine> getVerticalLines() {
    List<VerticalLine> verticalLines = [];
    for (var valor in valoresFilter) {
      if (valor.tipo == TipoOp.reembolso || valor.tipo == TipoOp.suscripcion) {
        var color = valor.tipo == TipoOp.reembolso ? Colors.red : Colors.green;
        double date = FechaUtil.dateToEpoch(valor.fecha).toDouble();
        verticalLines.add(VerticalLine(
          x: date,
          color: color,
          strokeWidth: 2,
          dashArray: [2, 2],
        ));
      }
    }
    return verticalLines;
  }

  LineChartData mainData() {
    List<FlSpot> spots = [];
    for (var valor in valoresFilter) {
      spots.add(FlSpot(
        FechaUtil.dateToEpoch(valor.fecha).toDouble(),
        valor.valor,
      ));
    }

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (double value, _) {
                return FittedBox(
                  child: Text(
                    value.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 8),
                  ),
                );
              }),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            interval: 2629743 * 6,
            getTitlesWidget: (double value, TitleMeta meta) {
              final epoch = value.toInt();
              DateTime dateTime = FechaUtil.epochToDate(epoch);
              if (value == spots.last.x || value == spots.first.x) {
                return const Text('');
              }
              return Text(FechaUtil.dateToString(
                date: dateTime,
                formato: 'MM/yy',
              ));
            },
          ),
        ),
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
      minY: precioMin.floor().toDouble(),
      maxY: precioMax.ceil().toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: const Color(0xFF2196F3),
          barWidth: 2,
          isCurved: false,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0x802196F3),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              var epoch = touchedSpot.x.toInt();
              DateTime dateTime =
                  DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
              var fecha = FechaUtil.dateToString(date: dateTime);
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors[0] ??
                    touchedSpot.bar.color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                  '${touchedSpot.y.toStringAsFixed(2)}\n$fecha', textStyle);
            }).toList();
          },
        ),
        touchCallback: (_, __) {},
        handleBuiltInTouches: true,
      ),
      extraLinesData: ExtraLinesData(
        verticalLines: getVerticalLines(),
        horizontalLines: [
          HorizontalLine(
            y: precioMedio,
            color: const Color(0xFF2196F3),
            strokeWidth: 2,
            dashArray: [2, 2],
            label: HorizontalLineLabel(
              show: true,
              style: labelGrafico,
              alignment: Alignment.topRight,
              labelResolver: (line) =>
                  'Media: ${NumberUtil.decimalFixed(precioMedio)}',
            ),
          ),
          HorizontalLine(
            y: precioMax,
            color: const Color(0xFF4CAF50),
            strokeWidth: 2,
            dashArray: [2, 2],
            label: HorizontalLineLabel(
              show: true,
              style: labelGrafico,
              alignment: Alignment.topRight,
              labelResolver: (line) =>
                  'Máx: ${NumberUtil.decimalFixed(precioMax)} - $fechaMax',
            ),
          ),
          HorizontalLine(
            y: precioMin,
            color: Colors.red,
            strokeWidth: 2,
            dashArray: [2, 2],
            label: HorizontalLineLabel(
              show: true,
              style: labelGrafico,
              alignment: Alignment.topRight,
              labelResolver: (line) =>
                  'Mín: ${NumberUtil.decimalFixed(precioMin)} - $fechaMin',
            ),
          ),
        ],
      ),
    );
  }
}
