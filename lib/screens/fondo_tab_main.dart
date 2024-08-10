import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/dia_calendario.dart';
import '../widgets/title_section.dart';

class FondoTabMain extends ConsumerStatefulWidget {
  final FondoData fondo;
  const FondoTabMain({super.key, required this.fondo});

  @override
  ConsumerState<FondoTabMain> createState() => _FondoTabMainState();
}

class _FondoTabMainState extends ConsumerState<FondoTabMain> {
  late AppDatabase database;
  List<ValoresFondoData> valoresFondo = [];
  bool isLoading = false;
  Stats stats = const Stats([]); //late Stats stats;
  double inversion = 0;
  double resultado = 0;
  double rendimiento = 0;
  double rentabilidad = 0;
  double rentAnual = 0;
  double twr = 0;
  double tae = 0;
  double mwr = 0;
  double mwrAcum = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setValores();
    super.initState();
  }

  Future<void> setValores() async {
    setState(() => isLoading = true);
    final valores = await database.getValores(widget.fondo.id);
    setState(() {
      valoresFondo = valores;
      isLoading = false;
    });
    initStats();
  }

  void initStats() {
    if (valoresFondo.isNotEmpty) {
      List<ValoresFondoData> operaciones =
          valoresFondo.where((data) => data.tipo != null).toList();
      if (operaciones.isNotEmpty) {
        calculateStats();
      }
    }
  }

  void calculateStats() {
    setState(() {
      stats = Stats(valoresFondo);
      inversion = stats.inversion() ?? 0;
      resultado = stats.resultado() ?? 0;
      rendimiento = stats.balance() ?? 0;
      rentabilidad = stats.rentabilidad() ?? 0;
      if (stats.rentabilidad() != null) {
        rentAnual = stats.anualizar(rentabilidad) ?? 0;
      }
      twr = stats.twr() ?? 0;
      if (stats.twr() != null) {
        tae = stats.anualizar(twr) ?? 0;
      }
      mwr = stats.mwr() ?? 0;
      if (stats.mwr() != null) {
        mwrAcum = stats.mwrAcum(mwr) ?? 0;
      }
    });
  }

  Widget childAvatar(Titular titular) {
    return titular == Titular.ambos
        ? const Icon(Icons.group)
        : Text(titular.name.toUpperCase()[0]);
  }

  /*Text diferenciaValores(ValoresFondoData valor, [bool total = false]) {
    bool isFirstValor = valoresFondo.length > (valoresFondo.indexOf(valor) + 1);
    double dif = valor.valor - widget.fondo.valorInicial;
    if (isFirstValor && total != true) {
      dif = valor.valor - valoresFondo[valoresFondo.indexOf(valor) + 1].valor;
    }
    return Text(
      NumberUtil.currency(dif),
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 14,
        color: dif < 0 ? Colors.red : Colors.green,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: childAvatar(widget.fondo.titular),
            ),
            title: Text(
              '${widget.fondo.name} (${widget.fondo.entidad})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              widget.fondo.isin ?? '',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 10),
          if (valoresFondo.isNotEmpty) ...[
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            const TitleSection(
                              title: 'BALANCE',
                              icon: Icons.balance,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Participaciones:'),
                                Text(NumberUtil.decimal(
                                    stats.totalParticipaciones() ?? 0)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Inversión:'),
                                Text(NumberUtil.currency(inversion)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Resultado:'),
                                Text(
                                  NumberUtil.currency(resultado),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rendimiento:'),
                                Text(
                                  NumberUtil.currency(rendimiento),
                                  style: TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.bold,
                                    color: rendimiento < 0
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            const TitleSection(
                              title: 'RENTABILIDAD',
                              icon: Icons.percent,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Rentabilidad Simple:'),
                                Text(NumberUtil.percentCompact(rentabilidad)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('TWR:'),
                                Text(NumberUtil.percentCompact(twr)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('MWR Acum:'),
                                Text(NumberUtil.percentCompact(mwrAcum)),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Simple anual:'),
                                Text(NumberUtil.percentCompact(rentAnual)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('TWR TAE:'),
                                Text(
                                  NumberUtil.percentCompact(tae),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: tae > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('MWR:'),
                                Text(
                                  NumberUtil.percentCompact(mwr),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: tae > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    const TitleSection(
                      title: 'EVOLUCIÓN',
                      icon: Icons.timeline,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Valor liquidativo:'),
                                      Text(
                                        NumberUtil.currency(
                                            valoresFondo.first.valor),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Dif. diaria:'),
                                      //diferenciaValores(valoresFondo.first),
                                      Text(
                                        NumberUtil.currency(stats.difValores(
                                            valoresFondo.first, widget.fondo)),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: stats.difValores(
                                                      valoresFondo.first,
                                                      widget.fondo) <
                                                  0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    NumberUtil.percent(
                                      stats.difPer(
                                          valoresFondo.first, widget.fondo),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: stats.difValores(
                                                  valoresFondo.first,
                                                  widget.fondo) <
                                              0
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Dif. desde inicio:'),
                                      //diferenciaValores(valoresFondo.first, true),
                                      Text(
                                        NumberUtil.currency(stats.difValores(
                                            valoresFondo.first,
                                            widget.fondo,
                                            true)),
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: stats.difValores(
                                                      valoresFondo.first,
                                                      widget.fondo,
                                                      true) <
                                                  0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        FechaUtil.dateToString(
                                            date: valoresFondo.last.fecha),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        NumberUtil.percent((stats.difValores(
                                                valoresFondo.first,
                                                widget.fondo,
                                                true) /
                                            valoresFondo.last.valor)),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: stats.difValores(
                                                      valoresFondo.first,
                                                      widget.fondo,
                                                      true) <
                                                  0
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //const Spacer(flex: 1),
                          Expanded(
                            flex: 1,
                            child: DiaCalendario(
                              epoch: FechaUtil.dateToEpoch(
                                  valoresFondo.first.fecha),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Valor mínimo (${FechaUtil.epochToString(
                                          stats.datePrecioMinimo() ?? 0,
                                          formato: 'dd/MM/yy',
                                        )}): ',
                                      ),
                                      Text(NumberUtil.currency(
                                          stats.precioMinimo() ?? 0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Valor máximo (${FechaUtil.epochToString(
                                        stats.datePrecioMaximo() ?? 0,
                                        formato: 'dd/MM/yy',
                                      )}): '),
                                      Text(NumberUtil.currency(
                                          stats.precioMaximo() ?? 0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Valor medio:'),
                                      Text(NumberUtil.currency(
                                          stats.precioMedio() ?? 0)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Volatilidad:'),
                                      Text(NumberUtil.decimal(
                                          stats.volatilidad() ?? 0)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
