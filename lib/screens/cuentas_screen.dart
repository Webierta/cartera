import 'package:carteradb/widgets/entidad_cuentas.dart';
import 'package:carteradb/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/number_util.dart';
import '../widgets/background_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/sort_buttons.dart';
import 'cartera_screen.dart';
import 'cuenta_add_screen.dart';
import 'depositos_screen.dart';
import 'entidad_screen.dart';
import 'fondos_screen.dart';

class CuentasScreen extends ConsumerStatefulWidget {
  const CuentasScreen({super.key});
  @override
  ConsumerState<CuentasScreen> createState() => _CuentasScreenState();
}

class _CuentasScreenState extends ConsumerState<CuentasScreen> {
  late AppDatabase database;
  int numeroCuentas = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setNumeroCuentas();
    super.initState();
  }

  setNumeroCuentas() async {
    final cuentas = await database.allCuentas;
    setState(() {
      numeroCuentas = cuentas.length;
    });
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
        //title: Text('Cuentas ($numeroCuentas)'),
        title: Row(
          children: [
            //const Text('Cuentas'),
            Text(TipoProducto.cuenta.nombrePlural),
            const SizedBox(width: 20),
            CircleAvatar(child: Text('$numeroCuentas')),
          ],
        ),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositosScreen(),
                ),
              );
            },
            tooltip: 'Ir a Depósitos',
            icon: const Icon(Icons.savings),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FondosScreen(),
                ),
              );
            },
            tooltip: 'Ir a Fondos',
            icon: const Icon(Icons.assessment),
          ),
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
  //Map<CuentaData, SaldosCuentaData> mapCuentaSaldo = {};
  Map<String, double> entidadSaldo = {};
  List<EntidadData> entidades = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getSaldoTotal();
    getEntidadesSet();
    //getCuentaSaldo();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  /* Future<void> getCuentaSaldo() async {
    for (var cuenta in widget.cuentas) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isNotEmpty) {
        setState(() {
          mapCuentaSaldo[cuenta] = saldosCuenta.first;
        });
      }
    }
  } */

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
      setState(() => entidadSaldo[entidad] = saldo);
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

  void moveScroll() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  void sortBySaldo() {
    var sortedEntidadTotal = Map.fromEntries(entidadSaldo.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    setState(() {
      entidadesSet = sortedEntidadTotal.keys.toSet();
    });
    moveScroll();
  }

  void sortByName() {
    var listaEntidades = entidadesSet.toList();
    listaEntidades.sort();
    //listaEntidades.sort(((a, b) => a.compareTo(b)));
    setState(() {
      //entidadesSet.sort(((a, b) => a.name.compareTo(b.name)));
      entidadesSet = listaEntidades.toSet();
    });
    moveScroll();
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
                leading: CircleAvatar(
                  child: Icon(TipoProducto.cuenta.icon, size: 40),
                ),
                title: Text(
                  NumberUtil.currency(saldoTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: (entidadesSet.length > 1)
                    ? SortButtons(
                        sortByCapital: sortBySaldo,
                        sortByName: sortByName,
                      )
                    : null,
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
            //key: UniqueKey(),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            controller: _scrollController,
            itemCount: entidadesSet.length,
            itemBuilder: (context, indice) {
              final String entidad = entidadesSet.elementAt(indice);
              final entidadData = entidades
                  .where((e) => e.name == entidad)
                  .toList()
                  .firstOrNull;

              return Card(
                //color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: InkWell(
                              onTap: () {
                                entidadData != null
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EntidadScreen(
                                              entidad: entidadData),
                                        ))
                                    : null;
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    BackgroundImage.getImage(entidadData),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                entidad,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            NumberUtil.currency(entidadSaldo[entidad] ?? 0),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      if (entidadData != null)
                        EntidadCuentas(entidad: entidadData, key: UniqueKey()),
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
