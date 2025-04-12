import 'package:flutter/material.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';

class TablaScreen extends StatefulWidget {
  final List<HistoricoData> historico;
  const TablaScreen({super.key, required this.historico});
  @override
  State<TablaScreen> createState() => _TablaScreenState();
}

class _TablaScreenState extends State<TablaScreen> {
  List<String> filtros = ['Total', 'Interanual', 'Anual'];
  String filtroSelect = 'Total';
  Set<String> years = {};
  List<HistoricoData> historicoFiltro = [];

  String formato = 'MMM yy';

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

  double total(HistoricoData historico) {
    return historico.totalCuentas +
        historico.totalDepositos +
        historico.totalFondos;
  }

  Widget difProducto(HistoricoData balance, {TipoProducto? producto}) {
    bool condition =
        historicoFiltro.length > (historicoFiltro.indexOf(balance) + 1);
    if (!condition) {
      return const SizedBox(height: 0, width: 0);
    }
    double dif = 0;
    if (producto == TipoProducto.cuenta) {
      dif = balance.totalCuentas -
          historicoFiltro[historicoFiltro.indexOf(balance) + 1].totalCuentas;
    } else if (producto == TipoProducto.deposito) {
      dif = balance.totalDepositos -
          historicoFiltro[historicoFiltro.indexOf(balance) + 1].totalDepositos;
    } else if (producto == TipoProducto.fondo) {
      dif = balance.totalFondos -
          historicoFiltro[historicoFiltro.indexOf(balance) + 1].totalFondos;
    } else {
      try {
        dif = total(balance) -
            total(historicoFiltro[historicoFiltro.indexOf(balance) + 1]);
        //(historicoFiltro[historicoFiltro.indexOf(balance) + 1].total ?? 0);
      } catch (e) {
        dif = 0;
      }
    }
    return Text(
      NumberUtil.signo(dif) + NumberUtil.currency(dif),
      maxLines: 1,
      textAlign: TextAlign.right,
      style: TextStyle(color: dif < 0 ? Colors.red : Colors.green.shade700),
    );
  }

  Widget porcentageDif(HistoricoData balance) {
    bool condition =
        historicoFiltro.length > (historicoFiltro.indexOf(balance) + 1);
    if (!condition) {
      return const SizedBox(height: 0, width: 0);
    }
    /*double dif = balance.total! -
        (historicoFiltro[historicoFiltro.indexOf(balance) + 1].total ?? 0);*/
    double dif = total(balance) -
        total(historicoFiltro[historicoFiltro.indexOf(balance) + 1]);

    double por =
        dif / total(historicoFiltro[historicoFiltro.indexOf(balance) + 1]);
    //(historicoFiltro[historicoFiltro.indexOf(balance) + 1].total ?? 0);

    return Text(
      NumberUtil.signo(por) + NumberUtil.percent(por),
      style: TextStyle(color: dif < 0 ? Colors.red : Colors.green.shade700),
    );
  }

  void changeFiltroSelect() {
    if (filtroSelect == 'Total') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [...widget.historico];
        formato = 'MMM yy';
      });
    } else if (filtroSelect == 'Interanual') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [
          ...widget.historico.where((hist) => hist.fecha.month == 12)
        ];
        formato = 'yyyy';
      });
    } else if (filtroSelect == 'Anual') {
      setState(() {
        historicoFiltro.clear();
        historicoFiltro = [
          ...widget.historico
              .where((hist) => hist.fecha.year == DateTime.now().year)
        ];
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
        formato = 'MMM';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla Histórico'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(32.0),
          child: Container(
            //color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.all(8),
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      '#',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Fecha',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Cuentas',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Depósitos',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Fondos',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    'Total',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              //padding: const EdgeInsets.symmetric(vertical: 2),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                isDense: true,
                value: filtroSelect,
                alignment: Alignment.center,
                onChanged: (String? value) {
                  setState(() => filtroSelect = value ?? filtros.first);
                  changeFiltroSelect();
                },
                underline: SizedBox(),
                items: filtros
                    .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e.toUpperCase()),
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
          //padding: const EdgeInsets.all(20),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(),
            itemCount: historicoFiltro.length,
            itemBuilder: (context, index) {
              final balance = historicoFiltro[index];
              return SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text('${historicoFiltro.length - index}'),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        FechaUtil.dateToString(
                          date: balance.fecha,
                          formato: formato,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberUtil.currency(balance.totalCuentas),
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          difProducto(balance, producto: TipoProducto.cuenta),
                          Porcentage(
                              num: balance.totalCuentas / total(balance)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberUtil.currency(balance.totalDepositos),
                            maxLines: 1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          difProducto(balance, producto: TipoProducto.deposito),
                          Porcentage(
                              num: balance.totalDepositos / total(balance)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberUtil.currency(balance.totalFondos),
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          difProducto(balance, producto: TipoProducto.fondo),
                          Porcentage(num: balance.totalFondos / total(balance))
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberUtil.currency(total(balance)),
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          difProducto(balance),
                          porcentageDif(balance),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Porcentage extends StatelessWidget {
  final double num;
  const Porcentage({super.key, required this.num});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        NumberUtil.percent(num),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
