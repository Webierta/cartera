import 'package:carteradb/services/yahoo_finance.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'fondo_add_screen.dart';
import 'fondo_tab_grafico.dart';
import 'fondo_tab_main.dart';
import 'fondo_tab_tabla.dart';
import 'fondos_screen.dart';

class FondoScreen extends ConsumerStatefulWidget {
  final FondoData fondo;
  const FondoScreen({super.key, required this.fondo});
  @override
  ConsumerState<FondoScreen> createState() => _FondoScreenState();
}

class _FondoScreenState extends ConsumerState<FondoScreen> {
  int selectedTab = 0;
  List<Widget> tabs = [];
  bool isLoading = false;

  late AppDatabase database;
  TextEditingController fechaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController participacionesController = TextEditingController();

  bool isOperacion = false;
  bool opSuscripcion = true;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setTabs();
    super.initState();
  }

  @override
  void dispose() {
    fechaController.dispose();
    precioController.dispose();
    participacionesController.dispose();
    super.dispose();
  }

  void setTabs() {
    setState(() => isLoading = true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        tabs = [
          FondoTabMain(fondo: widget.fondo),
          FondoTabTabla(
            fondo: widget.fondo,
            deleteValor: deleteValor,
            deleteOperacion: deleteOperacion,
          ),
          FondoTabGrafico(fondo: widget.fondo)
        ];
      });
    });
    setState(() => isLoading = false);
  }

  /*Future<void> setValores() async {
    setState(() => isLoading = true);
    final valores = await database.getValores(widget.fondo.id);
    setState(() {
      valoresFondo = valores;
      //isLoading = false;
    });
    setTabs();
  }*/

  Future<void> addValor() async {
    if (fechaController.text.trim().isEmpty ||
        precioController.text.trim().isEmpty) {
      return;
    }
    setState(() => isLoading = true);
    var fecha = FechaUtil.stringToDateHms(fechaController.text);
    ValoresFondoCompanion newValor;
    if (isOperacion) {
      newValor = ValoresFondoCompanion(
        fondo: dr.Value(widget.fondo.id),
        fecha: dr.Value(fecha),
        valor: dr.Value(double.tryParse(precioController.text) ?? 0),
        participaciones:
            dr.Value(double.tryParse(participacionesController.text)),
        tipo: dr.Value(
            opSuscripcion == true ? TipoOp.suscripcion : TipoOp.reembolso),
      );
    } else {
      newValor = ValoresFondoCompanion(
        fondo: dr.Value(widget.fondo.id),
        fecha: dr.Value(fecha),
        valor: dr.Value(double.tryParse(precioController.text) ?? 0),
      );
    }
    /*final valoresByFecha =
        await database.getValoresByFecha(widget.fondo.id, fecha);
    if (valoresByFecha.isNotEmpty) {
      await database.updateValor(valoresByFecha.first.id, newValor);
    } else {
      await database.addValorFondo(newValor);
    }*/
    await database.addValorFondo(newValor, widget.fondo.id);
    setState(() => isLoading = false);
    //setValores();
  }

  Future<void> deleteValor(ValoresFondoData valor) async {
    setState(() => isLoading = true);
    await database.deleteValor(valor.id);
    setState(() => isLoading = false);
    //setValores();
  }

  Future<void> deleteOperacion(ValoresFondoData valor) async {
    // ELIMINA OPERACION MANTENIENDO VALOR (UPDATE VALOR)
    setState(() => isLoading = true);
    ValoresFondoCompanion updateValor = ValoresFondoCompanion(
      fondo: dr.Value(valor.fondo),
      fecha: dr.Value(valor.fecha),
      valor: dr.Value(valor.valor),
      participaciones: const dr.Value(null),
      tipo: const dr.Value(null),
    );
    await database.updateValor(valor.id, updateValor);
    setState(() => isLoading = false);
    //setValores();
  }

  Future<void> update() async {
    setState(() => isLoading = true);
    final valores = await YahooFinance().getYahooFinanceResponse(widget.fondo);
    if (valores != null && valores.isNotEmpty) {
      await database.addValorFondo(valores.first, widget.fondo.id);
    }
    setState(() => isLoading = false);
    //setValores();
  }

  Future<void> updateHistorico() async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
          start: DateTime.now().subtract(const Duration(days: 5)),
          end: DateTime.now(),
        ),
        firstDate: DateTime(1997, 1, 1),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1),
            ),
            child: child!,
          );
        });
    if (picked == null) {
      return;
    }
    DateTime start = FechaUtil.dateToDateHms(picked.start);
    DateTime end = FechaUtil.dateToDateHms(picked.end);
    setState(() => isLoading = true);
    final valores =
        await YahooFinance().getYahooFinanceResponse(widget.fondo, end, start);
    if (valores != null && valores.isNotEmpty) {
      await database.addValores(valores, widget.fondo.id);
    }
    setState(() => isLoading = false);
    //setValores();
  }

  Future<void> limpiarValores() async {
    final confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todos los valores de este Fondo, incluyendo las operaciones?',
    );
    if (confirm == true) {
      setState(() => isLoading = true);
      await database.deleteValoresFondo(widget.fondo.id);
      setState(() => isLoading = false);
      //setValores();
    }
  }

  Future<void> deleteFondo() async {
    final confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar este Fondo y todos sus valores asociados?',
    );
    if (confirm == true) {
      //setState(() => isLoading = true);
      await database.deleteValoresFondo(widget.fondo.id);
      await database.deleteFondo(widget.fondo.id);
      //setState(() => isLoading = false);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FondosScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || tabs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fondo.name),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FondosScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          FilledButton.tonalIcon(
            onPressed: update,
            label: const Text('Actualizar'),
            icon: const Icon(Icons.update),
          ),
          IconButton(
            onPressed: updateHistorico,
            icon: const Icon(Icons.calendar_month),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            offset: Offset(0.0, AppBar().preferredSize.height),
            //shape: AppBox.roundBorder,
            itemBuilder: (ctx) => <PopupMenuItem<Enum>>[
              MenuItem.buildMenuItem(Menu.editar),
              MenuItem.buildMenuItem(Menu.exportar, divider: true),
              MenuItem.buildMenuItem(Menu.limpiar),
              MenuItem.buildMenuItem(Menu.eliminar),
            ],
            onSelected: (item) async {
              if (item == Menu.editar) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FondoAddScreen(editFondo: widget.fondo),
                  ),
                );
              } else if (item == Menu.exportar) {
                // EXPORTAR
              } else if (item == Menu.limpiar) {
                limpiarValores();
              } else if (item == Menu.eliminar) {
                deleteFondo();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedTab,
              onDestinationSelected: (int index) {
                setState(() => selectedTab = index);
              },
              labelType: NavigationRailLabelType.all,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              selectedIconTheme: const IconThemeData(color: Colors.black),
              unselectedIconTheme: const IconThemeData(color: Colors.black26),
              selectedLabelTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: Theme.of(context).colorScheme.surface,
              /*leading: FloatingActionButton(
                onPressed: update,
                backgroundColor: Colors.purpleAccent,
                child: const Icon(
                  Icons.update,
                  size: 40,
                  color: Colors.white,
                ),
              ),*/
              //groupAlignment: 0,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.assessment_outlined),
                  selectedIcon: Icon(Icons.assessment),
                  label: Text('Fondo'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.table_chart_outlined),
                  selectedIcon: Icon(Icons.table_chart),
                  label: Text('Tabla'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.timeline_outlined),
                  selectedIcon: Icon(Icons.timeline),
                  label: Text('Gráfico'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: tabs,
                /*children: [
                  FondoTabMain(fondo: widget.fondo),
                  FondoTabTabla(
                    fondo: widget.fondo,
                    deleteValor: deleteValor,
                    deleteOperacion: deleteOperacion,
                  ),
                  FondoTabGrafico(fondo: widget.fondo)
                ],*/
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: selectedTab == 1
          ? BottomAppBar(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: fechaController,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          /*initialDate: widget.fondo.fechaInicial.add(
                          const Duration(days: 1),
                           ),*/
                          initialDate: DateTime.now(),
                          //firstDate: DateTime(1970),
                          firstDate: widget.fondo.fechaInicial.add(
                            const Duration(days: 1),
                          ),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          //setState(() {
                          var dateHms = FechaUtil.dateToDateHms(pickedDate);
                          fechaController.text =
                              FechaUtil.dateToString(date: dateHms);
                          //});
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.today),
                        labelText: 'Fecha',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: precioController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.euro),
                        labelText: 'Valor',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (isOperacion) ...[
                    Expanded(
                      child: TextField(
                        controller: participacionesController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.add_shopping_cart),
                          labelText: 'Part.',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Switch(
                      value: opSuscripcion,
                      onChanged: (bool value) {
                        setState(() => opSuscripcion = value);
                      },
                      thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Icon(Icons.add_shopping_cart);
                          }
                          return const Icon(Icons.currency_exchange);
                        },
                      ),
                    ),
                  ],
                  IconButton(
                    onPressed: () {
                      setState(() => isOperacion = !isOperacion);
                    },
                    icon: const Icon(Icons.shopping_cart, size: 40),
                  ),
                  IconButton(
                    onPressed: addValor,
                    icon: const Icon(Icons.add_to_photos, size: 40),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
