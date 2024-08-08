import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/background_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'cartera_screen.dart';
import 'deposito_add_screen.dart';
import 'deposito_screen.dart';

class DepositosScreen extends ConsumerStatefulWidget {
  const DepositosScreen({super.key});

  @override
  ConsumerState<DepositosScreen> createState() => _DepositosScreenState();
}

class _DepositosScreenState extends ConsumerState<DepositosScreen> {
  late AppDatabase database;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    super.initState();
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
        title: const Text('Depósitos'),
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

  @override
  void initState() {
    getImposicionTotal();
    getEntidadesSet();
    //getEntidadImposicion();
    super.initState();
  }

  getImposicionTotal() {
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
      setState(() {
        entidadImposicion[entidad] = imposicion;
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
                  child: Icon(Icons.savings),
                ),
                title: Text(
                  NumberUtil.currency(imposicionTotal),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: CircleAvatar(
                  child: Text(
                    '${widget.depositos.length}',
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
              itemCount: entidadesSet.length,
              itemBuilder: (context, index) {
                final entidad = entidadesSet.elementAt(index);
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
                                /* backgroundImage: AssetImage(entidadLogo?.logo ??
                                    'assets/account_balance.png'),*/
                                //backgroundImage: backgroundImage(entidadLogo),
                                backgroundImage:
                                    BackgroundImage.getImage(entidadLogo),
                                /*backgroundImage:
                                    File(entidadLogo!.logo).existsSync()
                                        ? FileImage(File(entidadLogo.logo))
                                        : const AssetImage(
                                            'assets/account_balance.png'),*/
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.depositos.length,
                          itemBuilder: (context, index) {
                            final deposito = widget.depositos[index];
                            if (deposito.entidad != entidad) {
                              return const SizedBox(height: 0);
                            }
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DepositoScreen(deposito: deposito),
                                  ),
                                );
                              },
                              //leading: CircleAvatar(child: Text(entidad[0])),
                              leading: CircleAvatar(
                                child: Text(deposito.name[0].toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
                              ),
                              title: Text(deposito.name),
                              subtitle: Text(deposito.codigo ?? ''),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    NumberUtil.currency(deposito.imposicion),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    FechaUtil.dateToString(
                                      date: deposito.vencimiento,
                                      formato: 'd/MM/yy',
                                    ),
                                    style: TextStyle(
                                      color: deposito.vencimiento
                                                  .difference(DateTime.now())
                                                  .inDays <
                                              30
                                          ? Colors.red
                                          : Colors.black,
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
              }),
        ),
      ],
    );
  }
}
