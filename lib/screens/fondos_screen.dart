import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/background_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/entidad_fondos.dart';
import '../widgets/menu.dart';
import '../widgets/sort_buttons.dart';
import 'cartera_screen.dart';
import 'cuentas_screen.dart';
import 'depositos_screen.dart';
import 'entidad_screen.dart';
import 'fondo_add_screen.dart';

class FondosScreen extends ConsumerStatefulWidget {
  const FondosScreen({super.key});
  @override
  ConsumerState<FondosScreen> createState() => _FondosScreenState();
}

class _FondosScreenState extends ConsumerState<FondosScreen> {
  late AppDatabase database;
  int numeroFondos = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setNumeroFondos();
    super.initState();
  }

  setNumeroFondos() async {
    final fondos = await database.allFondos;
    setState(() => numeroFondos = fondos.length);
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
        //title: const Text('Fondos'),
        title: Row(
          children: [
            const Text('Fondos'),
            const SizedBox(width: 20),
            CircleAvatar(child: Text('$numeroFondos')),
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
                  builder: (context) => const CuentasScreen(),
                ),
              );
            },
            tooltip: 'Ir a Cuentas',
            icon: const Icon(Icons.account_balance_wallet),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositosScreen(),
                ),
              );
            },
            tooltip: 'Ir a Depositos',
            icon: const Icon(Icons.savings),
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
  double inversionTotal = 0;
  double balanceTotal = 0;
  Set<String> entidadesSet = {};
  Map<String, double> entidadCapital = {};
  List<EntidadData> entidades = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    //getEntidadesSet();
    getTotalStats();
    getEntidadesSet();
    super.initState();
  }

  Future<void> getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var fondo in widget.fondos) {
      entidadesNombres.add(fondo.entidad);
    }
    //final database = ref.read(AppDatabase.provider);
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
          //Stats stats = Stats(valoresFondo);
          //capital += stats.resultado() ?? 0;
          if (valoresFondo.isEmpty) {
            capital += 0;
          } else {
            Stats stats = Stats(valoresFondo);
            capital += stats.resultado() ?? 0;
          }
        }
      }
      setState(() {
        entidadCapital[entidad] = capital;
      });
    }
  }

  Future<void> getTotalStats() async {
    double capital = 0;
    double inversion = 0;
    double balance = 0;
    for (var fondo in widget.fondos) {
      final valoresFondo = await database.getValores(fondo.id);
      Stats stats = Stats(valoresFondo);
      capital += stats.resultado() ?? 0;
      inversion += stats.inversion() ?? 0;
      balance += stats.balance() ?? 0;
    }
    setState(() {
      capitalTotal = capital;
      inversionTotal = inversion;
      balanceTotal = balance;
    });
  }

  void moveScroll() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  void sortByCapital() {
    var sortedEntidadTotal = Map.fromEntries(entidadCapital.entries.toList()
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

  @override
  Widget build(BuildContext context) {
    return Column(
      //key: UniqueKey(),
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
                        Text(NumberUtil.currency(inversionTotal)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.exposure),
                        const SizedBox(width: 10),
                        Text(
                          NumberUtil.currency(balanceTotal),
                          style: TextStyle(
                            //fontSize: 16,
                            color: balanceTotal < 0 ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: (entidadesSet.length > 1)
                    ? SortButtons(
                        sortByCapital: sortByCapital,
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
              child: Text('Ningún fondo a la vista'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            //key: UniqueKey(),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            controller: _scrollController,
            itemCount: entidadesSet.length,
            itemBuilder: (context, indice) {
              final entidad = entidadesSet.elementAt(indice);
              /* final entidadLogo = entidades
                  .where((e) => e.name == entidad)
                  .toList()
                  .firstOrNull; */
              final entidadData = entidades
                  .where((e) => e.name == entidad)
                  .toList()
                  .firstOrNull;
              return Card(
                //key: UniqueKey(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  entidad: entidadData,
                                                )))
                                    : null;
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    BackgroundImage.getImage(entidadData),
                              ),
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
                      if (entidadData != null)
                        EntidadFondos(entidad: entidadData, key: UniqueKey()),
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
