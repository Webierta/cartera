import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'cartera_screen.dart';
import 'fondo_add_screen.dart';
import 'fondo_screen.dart';

class FondosScreen extends ConsumerStatefulWidget {
  const FondosScreen({super.key});
  @override
  ConsumerState<FondosScreen> createState() => _FondosScreenState();
}

class _FondosScreenState extends ConsumerState<FondosScreen> {
  late AppDatabase database;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    super.initState();
  }

  Future<void> fondosDelete(BuildContext context) async {
    final fondos = await database.allFondos;
    if (fondos.isEmpty) {
      return;
    }
    if (!context.mounted) return;
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todos los fondos y sus valores asociados?',
    );
    if (confirm == true) {
      await database.deleteValores();
      await database.deleteFondos();
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fondos'),
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
                fondosDelete(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder<List<FondoData>>(
          future: database.allFondos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListadoFondos(fondos: snapshot.data!);
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
              builder: (context) => const FondoAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListadoFondos extends ConsumerStatefulWidget {
  final List<FondoData> fondos;
  const ListadoFondos({super.key, required this.fondos});

  @override
  ConsumerState<ListadoFondos> createState() => _ListadoFondosState();
}

class _ListadoFondosState extends ConsumerState<ListadoFondos> {
  late AppDatabase database;
  double capitalTotal = 0;
  Set<String> entidadesSet = {};
  Map<FondoData, ValoresFondoData> mapFondoValor = {};
  Map<FondoData, double> mapFondoCapital = {};
  Map<String, double> entidadCapital = {};
  List<EntidadData> entidades = [];

  double getInversion(FondoData fondo) {
    return fondo.participaciones * fondo.valorInicial;
  }

  double getRendimiento(FondoData fondo) {
    if (mapFondoCapital[fondo] == null) {
      return 0;
    }
    return mapFondoCapital[fondo]! - getInversion(fondo);
  }

  double get totalInversion {
    double inversion = 0;
    for (var fondo in widget.fondos) {
      inversion += getInversion(fondo);
    }
    return inversion;
  }

  double get totalRendimiento {
    double rendimiento = 0;
    for (var fondo in widget.fondos) {
      rendimiento += getRendimiento(fondo);
    }
    return rendimiento;
  }

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getCapitalTotal();
    getEntidadesSet();
    //getEntidadCapital();
    super.initState();
  }

  Future<double> getCapital(FondoData fondo) async {
    final valoresFondo = await database.getValores(fondo.id);
    if (valoresFondo.isEmpty) {
      setState(() {
        mapFondoCapital[fondo] = 0;
      });
      //mapFondoCapital[fondo] = fondo.participaciones * fondo.valorInicial;
      //mapFondoValor[fondo] = fondo.
      //return fondo.participaciones * fondo.valorInicial;
      return 0;
    } else {
      setState(() {
        mapFondoCapital[fondo] =
            fondo.participaciones * valoresFondo.first.valor;
        mapFondoValor[fondo] = valoresFondo.first;
      });

      return fondo.participaciones * valoresFondo.first.valor;
    }
  }

  Future<void> getCapitalTotal() async {
    double capital = 0;
    for (var fondo in widget.fondos) {
      capital += await getCapital(fondo);
    }
    setState(() {
      capitalTotal = capital;
    });

    /*List<double> lastValores = [];
    for (var fondo in widget.fondos) {
      final valoresFondo = await database.getValores(fondo.id);
      if (valoresFondo.isEmpty) {
        continue;
      }
      lastValores.add(valoresFondo.first.valor);
    }
    if (lastValores.isEmpty) {
      setState(() {
        capitalTotal = 0;
      });
      return;
    }
    setState(() {
      capitalTotal = lastValores.reduce((value, element) => value + element);
    });*/
  }

  Future<void> getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var fondo in widget.fondos) {
      entidadesNombres.add(fondo.entidad);
    }
    List<EntidadData> allEntidades = await database.allEntidades;
    setState(() {
      entidadesSet = entidadesNombres;
      entidades = allEntidades;
    });
    getEntidadCapital();
  }

  Future<void> getEntidadCapital() async {
    if (entidadesSet.isEmpty && widget.fondos.isNotEmpty) {
      await getEntidadesSet();
    }
    for (var entidad in entidadesSet) {
      double capital = 0;
      for (var fondo in widget.fondos) {
        if (fondo.entidad == entidad) {
          final valoresFondo = await database.getValores(fondo.id);
          if (valoresFondo.isEmpty) {
            capital += 0;
          } else {
            //capital += valoresFondo.first.valor;
            capital += fondo.participaciones * valoresFondo.first.valor;
          }
        }
      }
      setState(() {
        entidadCapital[entidad] = capital;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.assessment),
                ),
                isThreeLine: true,
                title: Text(
                  NumberUtil.currency(capitalTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_cart),
                        const SizedBox(width: 10),
                        Text(
                          NumberUtil.currency(totalInversion),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.exposure),
                        const SizedBox(width: 10),
                        Text(
                          NumberUtil.currency(totalRendimiento),
                          style: TextStyle(
                            //fontSize: 16,
                            color: totalRendimiento < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: CircleAvatar(
                  child: Text(
                    '${widget.fondos.length}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
                /*trailing: Chip(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  avatar: const Icon(
                    Icons.exposure,
                    size: 30,
                  ),
                  label: Text(
                    '$totalRendimiento €',
                    style: TextStyle(
                      fontSize: 16,
                      color: totalRendimiento < 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ),*/
              ),
            ),
          ],
        ),
        if (entidadesSet.isEmpty)
          const Expanded(
            child: Center(
              child: Text('Ningún fondo a la vista'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            itemCount: entidadesSet.length,
            itemBuilder: (context, indice) {
              final entidad = entidadesSet.elementAt(indice);
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
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              /*backgroundImage: AssetImage(entidadLogo?.logo ??
                                  'assets/account_balance.png'),*/
                              backgroundImage:
                                  File(entidadLogo!.logo).existsSync()
                                      ? FileImage(File(entidadLogo.logo))
                                      : const AssetImage(
                                          'assets/account_balance.png'),
                            ),
                          ),
                          Text(
                            entidad,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const Spacer(),
                          Text(
                            NumberUtil.currency(entidadCapital[entidad] ?? 0),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.fondos.length,
                        itemBuilder: (context, index) {
                          final fondo = widget.fondos[index];
                          if (fondo.entidad != entidad) {
                            return const SizedBox(height: 0);
                          }
                          /*List<ValorFondo> valores = [];
                          valores.addAll(fondo.valores);
                          if (valores.length > 1) {
                            valores.sort((a, b) => a.fecha.compareTo(b.fecha));
                          }*/
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FondoScreen(fondo: fondo),
                                ),
                              );
                            },
                            //leading: CircleAvatar(child: Text(entidad[0])),
                            leading: CircleAvatar(
                              child: Text(fondo.name[0].toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                            ),
                            title: Text(fondo.name),
                            subtitle: Text(fondo.isin ?? ''),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  /*fondo.valores.isEmpty
                                      ? '0.0 €'
                                      : NumberUtil.currency(
                                          valores.last.precio *
                                              fondo.participaciones),*/
                                  //NumberUtil.currency(mapFondoValor[fondo]?.valor ?? 0),
                                  NumberUtil.currency(
                                      mapFondoCapital[fondo] ?? 0),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                if (mapFondoValor[fondo]?.fecha != null)
                                  Text(
                                    FechaUtil.dateToString(
                                      date: mapFondoValor[fondo]!.fecha,
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
