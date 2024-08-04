import 'package:carteradb/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/confirm_dialog.dart';
import 'cartera_screen.dart';
import 'cuenta_add_screen.dart';
import 'cuenta_screen.dart';

class CuentasScreen extends ConsumerStatefulWidget {
  const CuentasScreen({super.key});
  @override
  ConsumerState<CuentasScreen> createState() => _CuentasScreenState();
}

class _CuentasScreenState extends ConsumerState<CuentasScreen> {
  late AppDatabase database;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    super.initState();
  }

  Future<void> cuentasDelete(BuildContext context) async {
    final cuentas = await database.allCuentas;
    if (cuentas.isEmpty) {
      return;
    }
    if (!context.mounted) return;
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todas las cuentas y sus saldos asociados?',
    );
    if (confirm == true) {
      await database.deleteSaldos();
      await database.deleteCuentas();
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CarteraScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //final database = ref.read(AppDatabase.provider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cuentas'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CarteraScreen(),
              ),
            );
          },
          icon: const Icon(Icons.home),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            offset: Offset(0.0, AppBar().preferredSize.height),
            //shape: AppBox.roundBorder,
            itemBuilder: (ctx) => <PopupMenuItem<Enum>>[
              MenuItem.buildMenuItem(Menu.importar),
              MenuItem.buildMenuItem(Menu.eliminar),
            ],
            onSelected: (item) async {
              if (item == Menu.eliminar) {
                cuentasDelete(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder<List<CuentaData>>(
          future: database.allCuentas,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListadoCuentas(cuentas: snapshot.data!);
            } else {
              return const Center(child: Text('No hay cuentas todavía'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CuentaAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListadoCuentas extends ConsumerStatefulWidget {
  final List<CuentaData> cuentas;
  const ListadoCuentas({super.key, required this.cuentas});

  @override
  ConsumerState<ListadoCuentas> createState() => _ListadoCuentasState();
}

class _ListadoCuentasState extends ConsumerState<ListadoCuentas> {
  late AppDatabase database;
  double saldoTotal = 0;
  Set<String> entidadesSet = {};
  //double saldoEntidad = 0;
  //Map<CuentaData, double> cuentaSaldo = {};
  Map<CuentaData, SaldosCuentaData> mapCuentaSaldo = {};
  Map<String, double> entidadSaldo = {};
  List<EntidadData> entidades = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getSaldoTotal();
    getEntidadesSet();
    getCuentaSaldo();
    super.initState();
  }

  Future<void> getSaldoTotal() async {
    List<double> lastSaldos = [];
    for (var cuenta in widget.cuentas) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isEmpty) {
        continue;
      }
      lastSaldos.add(saldosCuenta.first.saldo);
    }
    if (lastSaldos.isEmpty) {
      setState(() => saldoTotal = 0);
      return;
    }
    setState(() {
      saldoTotal = lastSaldos.reduce((value, element) => value + element);
    });
  }

  Future<void> getCuentaSaldo() async {
    for (var cuenta in widget.cuentas) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isNotEmpty) {
        setState(() {
          mapCuentaSaldo[cuenta] = saldosCuenta.first;
        });
      }
    }
  }

  Future<void> getEntidadSaldo() async {
    //getEntidadesSet();
    for (var entidad in entidadesSet) {
      double saldo = 0;
      for (var cuenta in widget.cuentas) {
        if (cuenta.entidad == entidad) {
          List<SaldosCuentaData> saldosCuenta =
              await database.getSaldos(cuenta.id);
          if (saldosCuenta.isNotEmpty) {
            saldo += saldosCuenta.first.saldo;
          }
        }
      }
      setState(() {
        entidadSaldo[entidad] = saldo;
      });
    }
  }

  void getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var cuenta in widget.cuentas) {
      entidadesNombres.add(cuenta.entidad);
    }
    List<EntidadData> allEntidades = await database.allEntidades;
    setState(() {
      entidadesSet = entidadesNombres;
      entidades = allEntidades;
    });
    getEntidadSaldo();
  }

  /*getSaldoEntidad(String entidad) async {
    double saldo = 0;
    for (var cuenta in widget.cuentas) {
      if (cuenta.entidad == entidad) {
        List<SaldosCuentaData> saldosCuenta =
            await database.getSaldos(cuenta.id);
        if (saldosCuenta.isEmpty) {
          continue;
        }
        saldo += saldosCuenta.first.saldo;
      }
    }
    setState(() {
      saldoEntidad = saldo;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.account_balance_wallet),
                ),
                title: Text(
                  NumberUtil.currency(saldoTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: CircleAvatar(
                  child: Text(
                    '${widget.cuentas.length}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (entidadesSet.isEmpty)
          const Expanded(
            child: Center(
              child: Text('Ninguna cuenta a la vista'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            itemCount: entidadesSet.length,
            itemBuilder: (context, indice) {
              final String entidad = entidadesSet.elementAt(indice);
              final entidadLogo = entidades
                  .where((e) => e.name == entidad)
                  .toList()
                  .firstOrNull;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(entidadLogo?.logo ??
                                  'assets/account_balance.png'),
                            ),
                          ),
                          Text(
                            entidad,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Spacer(),
                          Text(
                            NumberUtil.currency(entidadSaldo[entidad] ?? 0),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.cuentas.length,
                        itemBuilder: (context, index) {
                          final cuenta = widget.cuentas[index];
                          if (cuenta.entidad != entidad) {
                            return const SizedBox(height: 0);
                          }
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CuentaScreen(cuenta: cuenta),
                                ),
                              );
                            },
                            //leading: CircleAvatar(child: Text(entidad[0])),
                            leading: CircleAvatar(
                              child: Text(cuenta.name[0].toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                            title: Text(cuenta.name),
                            subtitle: Text(cuenta.iban),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  NumberUtil.currency(
                                      mapCuentaSaldo[cuenta]?.saldo ?? 0),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (mapCuentaSaldo[cuenta]?.fecha != null)
                                  Text(
                                    FechaUtil.dateToString(
                                      date: mapCuentaSaldo[cuenta]!.fecha,
                                      formato: 'MMM yy',
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
