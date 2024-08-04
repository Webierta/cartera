import 'package:carteradb/services/yahoo_finance.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'fondo_add_screen.dart';
import 'fondos_screen.dart';

class FondoScreen extends ConsumerStatefulWidget {
  final FondoData fondo;
  const FondoScreen({super.key, required this.fondo});
  @override
  ConsumerState<FondoScreen> createState() => _FondoScreenState();
}

class _FondoScreenState extends ConsumerState<FondoScreen> {
  late AppDatabase database;
  TextEditingController fechaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  double capital = 0;
  double rendimiento = 0;
  double tae = 0;
  (int, String) tiempo = (0, '');
  List<ValoresFondoData> valoresFondo = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getIndices();
    super.initState();
  }

  @override
  void dispose() {
    fechaController.dispose();
    precioController.dispose();
    super.dispose();
  }

  Future<void> getIndices() async {
    final valores = await database.getValores(widget.fondo.id);
    setState(() {
      valoresFondo = valores;
    });
    if (valoresFondo.isEmpty) {
      setState(() {
        capital = 0;
        //capital = widget.fondo.participaciones * widget.fondo.valorInicial;
        rendimiento = 0;
        tae = 0;
        tiempo = (0, '');
      });
    } else {
      String tiempoString = 'días';
      int tiempoInt =
          valoresFondo.first.fecha.difference(widget.fondo.fechaInicial).inDays;
      if (tiempoInt > 60) {
        tiempoInt = tiempoInt ~/ 30;
        tiempoString = 'meses';
        if (tiempoInt > 25) {
          tiempoInt = tiempoInt ~/ 12;
          tiempoString = 'años';
        }
      }
      setState(() {
        tiempo = (tiempoInt, tiempoString);
        capital = widget.fondo.participaciones * valoresFondo.first.valor;
        rendimiento = capital -
            (widget.fondo.participaciones * widget.fondo.valorInicial);
        tae = rendimiento /
            (widget.fondo.participaciones * widget.fondo.valorInicial);
      });
    }
  }

  Widget childAvatar(Titular titular) {
    return titular == Titular.ambos
        ? const Icon(Icons.group)
        : Text(titular.name.toUpperCase()[0]);
  }

  Future<void> addValor() async {
    if (fechaController.text.trim().isEmpty ||
        precioController.text.trim().isEmpty) {
      return;
    }
    var newValor = ValoresFondoCompanion(
      fondo: dr.Value(widget.fondo.id),
      fecha: dr.Value(FechaUtil.stringToDate(fechaController.text)),
      valor: dr.Value(double.tryParse(precioController.text) ?? 0),
    );
    await database.addValorFondo(newValor);
    getIndices();
  }

  Future<void> update() async {
    final valores = await YahooFinance().getYahooFinanceResponse(widget.fondo);
    if (valores == null || valores.isEmpty) {
      return;
    }
    //await database.addValores(valores);
    await database.addValorFondo(valores.first);
    getIndices();
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
    final valores =
        await YahooFinance().getYahooFinanceResponse(widget.fondo, end, start);
    if (valores == null || valores.isEmpty) {
      return;
    }
    await database.addValores(valores);
    getIndices();
  }

  Future<void> deleteValor(int idValor) async {
    await database.deleteValor(idValor);
    getIndices();
  }

  Future<void> deleteFondo() async {
    final confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar este Fondo y todos sus valores asociados?',
    );
    if (confirm == true) {
      await database.deleteValoresFondo(widget.fondo.id);
      await database.deleteFondo(widget.fondo.id);
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
          IconButton(
            onPressed: () {
              update();
            },
            icon: const Icon(Icons.update),
          ),
          IconButton(
            onPressed: () {
              updateHistorico();
            },
            icon: const Icon(Icons.calendar_month),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            offset: Offset(0.0, AppBar().preferredSize.height),
            //shape: AppBox.roundBorder,
            itemBuilder: (ctx) => <PopupMenuItem<Enum>>[
              MenuItem.buildMenuItem(Menu.editar),
              MenuItem.buildMenuItem(Menu.exportar),
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
              } else if (item == Menu.eliminar) {
                deleteFondo();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Chip(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            label: Column(
                              children: [
                                const Text('SUSCRIPCIÓN'),
                                Text(
                                  'Part.: ${widget.fondo.participaciones}',
                                ),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            FechaUtil.dateToString(
                                date: widget.fondo.fechaInicial),
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'V.L.: ${NumberUtil.decimal(widget.fondo.valorInicial)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Inversión: ${NumberUtil.currency(widget.fondo.participaciones * widget.fondo.valorInicial)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (valoresFondo.isNotEmpty) ...[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${tiempo.$1} ${tiempo.$2}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Divider(
                            indent: 60,
                            endIndent: 60,
                          ),
                          Text(
                            'TAE: ${NumberUtil.porcentage(tae * 100)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Resultado:\n${NumberUtil.currency(rendimiento)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Chip(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Text('EVOLUCIÓN'),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              FechaUtil.dateToString(
                                  date: valoresFondo.first.fecha),
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'V.L.: ${NumberUtil.decimal(valoresFondo.first.valor)}',
                              // valoresFondo.first.valor
                              style: const TextStyle(fontSize: 14),
                            ),
                            Text(
                              'Capital: ${NumberUtil.currency(capital)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ],
              ),
            ),
            const Divider(height: 20),
            StreamBuilder<List<ValoresFondoData>>(
              stream: database.getValoresFondo(widget.fondo.id),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<ValoresFondoData>> snapshot,
              ) {
                return snapshot.hasData
                    ? HistoricoValores(
                        valores: snapshot.data!,
                        delete: deleteValor,
                        fondo: widget.fondo,
                      )
                    : const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
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
                    setState(() {
                      var dateHms = FechaUtil.dateToDateHms(pickedDate);
                      fechaController.text =
                          FechaUtil.dateToString(date: dateHms);
                    });
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
            IconButton(
              onPressed: addValor,
              icon: const Icon(Icons.add_to_photos, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricoValores extends StatelessWidget {
  final Function(int) delete;
  final List<ValoresFondoData> valores;
  final FondoData fondo;
  const HistoricoValores({
    super.key,
    required this.valores,
    required this.delete,
    required this.fondo,
  });

  Text diferenciaValores(ValoresFondoData valor) {
    bool isFirstValor = valores.length > (valores.indexOf(valor) + 1);
    double dif = valor.valor - fondo.valorInicial;
    if (isFirstValor) {
      dif = valor.valor - valores[valores.indexOf(valor) + 1].valor;
    }
    return Text(
      NumberUtil.currency(dif),
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 16,
        color: dif < 0 ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (valores.isEmpty) {
      return const Center(child: Text('Sin datos'));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: valores.length,
      itemBuilder: (context, index) {
        final valor = valores[index];
        /*if (index == valores.length - 1) {
          return ItemListView(
            index: index,
            valor: valor,
            diferencia: diferenciaValores,
          );
        }*/
        return Dismissible(
          key: ValueKey(valor.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: Theme.of(context).cardTheme.margin,
            alignment: AlignmentDirectional.centerEnd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          onDismissed: (direction) => delete(valor.id),
          child: ItemListView(
            index: index,
            valoresLength: valores.length,
            valor: valor,
            diferencia: diferenciaValores,
          ),
        );
      },
    );
  }
}

class ItemListView extends StatelessWidget {
  final int index;
  final int valoresLength;
  final ValoresFondoData valor;
  final Text Function(ValoresFondoData) diferencia;
  const ItemListView(
      {super.key,
      required this.index,
      required this.valoresLength,
      required this.valor,
      required this.diferencia});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              child: Text(
                //'${index + 1}',
                '${valoresLength - index}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              FechaUtil.dateToString(date: valor.fecha),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.currency(valor.valor),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: diferencia(valor),
          ),
        ],
      ),
    );
  }
}
