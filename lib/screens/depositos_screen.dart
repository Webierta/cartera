import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/number_util.dart';
import '../widgets/background_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/entidad_depositos.dart';
import '../widgets/menu.dart';
import '../widgets/sort_buttons.dart';
import 'cartera_screen.dart';
import 'cuentas_screen.dart';
import 'deposito_add_screen.dart';
import 'entidad_screen.dart';
import 'fondos_screen.dart';

class DepositosScreen extends ConsumerStatefulWidget {
  //final EntidadData? entidadSelect;
  const DepositosScreen({super.key});

  @override
  ConsumerState<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends ConsumerState<DepositosScreen> {
  late AppDatabase database;
  int numeroDepositos = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setNumeroDepositos();
    super.initState();
  }

  Future<void> setNumeroDepositos() async {
    final depositos = await database.allDepositos;
    setState(() {
      numeroDepositos = depositos.length;
    });
  }

  Future<void> depositosDelete(BuildContext context) async {
    final depositos = await database.allDepositos;
    if (depositos.isEmpty) {
      return;
    }
    if (!context.mounted) return;
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todos los depositos?',
    );
    if (confirm == true) {
      await database.deleteDepositos();
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
        title: Row(
          children: [
            //const Text('Depósitos'),
            Text(TipoProducto.deposito.nombrePlural),
            const SizedBox(width: 20),
            CircleAvatar(child: Text('$numeroDepositos')),
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
                depositosDelete(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder<List<DepositoData>>(
          future: database.allDepositos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListadoDepositos(depositos: snapshot.data!);
            } else {
              return const Center(child: Text('No hay depósitos todavía'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DepositoAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ListadoDepositos extends ConsumerStatefulWidget {
  final List<DepositoData> depositos;
  const ListadoDepositos({super.key, required this.depositos});

  @override
  ConsumerState<ListadoDepositos> createState() => _ListadoDepositosState();
}

class _ListadoDepositosState extends ConsumerState<ListadoDepositos> {
  double imposicionTotal = 0;
  Set<String> entidadesSet = {};
  //Map<DepositoData, ImposicionData> mapDepositoImposicion = {};
  Map<String, double> entidadImposicion = {};
  List<EntidadData> entidades = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    getImposicionTotal();
    getEntidadesSet();
    //getEntidadImposicion();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getImposicionTotal() {
    double imposicion = 0;
    for (var deposito in widget.depositos) {
      imposicion += deposito.imposicion;
    }
    setState(() {
      imposicionTotal = imposicion;
    });
  }

  Future<void> getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var deposito in widget.depositos) {
      entidadesNombres.add(deposito.entidad);
    }
    final database = ref.read(AppDatabase.provider);
    List<EntidadData> allEntidades = await database.allEntidades;
    if (!mounted) return;
    setState(() {
      entidadesSet = entidadesNombres;
      entidades = allEntidades;
    });
    getEntidadImposicion();
  }

  void getEntidadImposicion() {
    if (entidadesSet.isEmpty) {
      getEntidadesSet();
    }
    for (var entidad in entidadesSet) {
      double imposicion = 0;
      for (var deposito in widget.depositos) {
        if (deposito.entidad == entidad) {
          imposicion += deposito.imposicion;
        }
      }
      setState(() => entidadImposicion[entidad] = imposicion);
    }
  }

  void moveScroll() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  void sortByCapital() {
    var sortedEntidadTotal = Map.fromEntries(entidadImposicion.entries.toList()
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
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(TipoProducto.deposito.icon, size: 40),
                ),
                title: Text(
                  NumberUtil.currency(imposicionTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                /* trailing: CircleAvatar(
                  child: Text(
                    '${widget.depositos.length}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ), */
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
            child: Center(child: Text('Ningún depósito a la vista')),
          ),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
              controller: _scrollController,
              itemCount: entidadesSet.length,
              itemBuilder: (context, index) {
                final entidad = entidadesSet.elementAt(index);
                final entidadData = entidades
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
                              child: InkWell(
                                onTap: () {
                                  entidadData != null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntidadScreen(
                                                      entidad: entidadData)))
                                      : null;
                                },
                                child: CircleAvatar(
                                  /* backgroundImage: AssetImage(entidadLogo?.logo ??
                                      'assets/account_balance.png'),*/
                                  //backgroundImage: backgroundImage(entidadLogo),
                                  backgroundImage:
                                      BackgroundImage.getImage(entidadData),
                                  /*backgroundImage:
                                      File(entidadLogo!.logo).existsSync()
                                          ? FileImage(File(entidadLogo.logo))
                                          : const AssetImage(
                                              'assets/account_balance.png'),*/
                                ),
                              ),
                            ),
                            Text(
                              entidad,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Text(
                              NumberUtil.currency(
                                  entidadImposicion[entidad] ?? 0),
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        if (entidadData != null)
                          EntidadDepositos(
                              entidad: entidadData, key: UniqueKey()),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
