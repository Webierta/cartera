import 'package:carteradb/services/yahoo_finance.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dia_calendario.dart';
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
  bool isLoading = false;
  late AppDatabase database;
  TextEditingController fechaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController participacionesController = TextEditingController();

  bool isOperacion = false;
  bool opSuscripcion = true;

  List<ValoresFondoData> valoresFondo = [];

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

  @override
  void dispose() {
    fechaController.dispose();
    precioController.dispose();
    participacionesController.dispose();
    super.dispose();
  }

  Future<void> setValores() async {
    final valores = await database.getValores(widget.fondo.id);
    setState(() {
      valoresFondo = valores;
      isLoading = false;
    });
    if (valoresFondo.isEmpty) {
      resetStats();
    } else {
      List<ValoresFondoData> operaciones =
          valoresFondo.where((data) => data.tipo != null).toList();
      if (operaciones.isNotEmpty) {
        calculateStats();
      } else {
        resetStats();
      }
    }
  }

  void resetStats() {
    setState(() {
      stats = const Stats([]);
      inversion = 0;
      resultado = 0;
      rendimiento = 0;
      rentabilidad = 0;
      rentAnual = 0;
      twr = 0;
      tae = 0;
      mwr = 0;
      mwrAcum = 0;
      isLoading = false;
    });
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

  Future<void> addValor() async {
    if (fechaController.text.trim().isEmpty ||
        precioController.text.trim().isEmpty) {
      return;
    }
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
    setValores();
  }

  Future<void> update() async {
    setState(() {
      isLoading = true;
    });
    final valores = await YahooFinance().getYahooFinanceResponse(widget.fondo);
    if (valores == null || valores.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    await database.addValorFondo(valores.first, widget.fondo.id);
    setValores();
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
    if (valores == null || valores.isEmpty) {
      setState(() => isLoading = false);
      return;
    }
    await database.addValores(valores, widget.fondo.id);
    setValores();
  }

  Future<void> deleteValor(ValoresFondoData valor) async {
    await database.deleteValor(valor.id);
    setValores();
  }

  Future<void> deleteOperacion(ValoresFondoData valor) async {
    // ELIMINA OPERACION MANTENIENDO VALOR (UPDATE VALOR)
    ValoresFondoCompanion updateValor = ValoresFondoCompanion(
      fondo: dr.Value(valor.fondo),
      fecha: dr.Value(valor.fecha),
      valor: dr.Value(valor.valor),
      participaciones: const dr.Value(null),
      tipo: const dr.Value(null),
    );
    await database.updateValor(valor.id, updateValor);
    setValores();
  }

  Future<void> limpiarValores() async {
    final confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todos los valores de este Fondo, incluyendo las operaciones?',
    );
    if (confirm == true) {
      await database.deleteValoresFondo(widget.fondo.id);
      setValores();
    }
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

  Text diferenciaValores(ValoresFondoData valor, [bool total = false]) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Participaciones:'),
                                  Text(NumberUtil.decimal(
                                      stats.totalParticipaciones() ?? 0)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Inversión:'),
                                  Text(NumberUtil.currency(inversion)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Rendimiento:'),
                                  Text(
                                    NumberUtil.currency(rendimiento),
                                    style: TextStyle(
                                      fontSize: 14,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Rentabilidad Simple:'),
                                  Text(NumberUtil.percentCompact(rentabilidad)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('TWR:'),
                                  Text(NumberUtil.percentCompact(twr)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('MWR Acum:'),
                                  Text(NumberUtil.percentCompact(mwrAcum)),
                                ],
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Simple anual:'),
                                  Text(NumberUtil.percentCompact(rentAnual)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('TWR TAE:'),
                                  Text(
                                    NumberUtil.percentCompact(tae),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          tae > 0 ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('MWR:'),
                                  Text(
                                    NumberUtil.percentCompact(mwr),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          tae > 0 ? Colors.green : Colors.red,
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
                                  //crossAxisAlignment: CrossAxisAlignment.end,
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
                                        diferenciaValores(valoresFondo.first),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Dif. desde inicio:'),
                                        diferenciaValores(
                                            valoresFondo.first, true),
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
            const SizedBox(height: 40),
            StreamBuilder<List<ValoresFondoData>>(
              stream: database.getValoresFondo(widget.fondo.id),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<ValoresFondoData>> snapshot,
              ) {
                return snapshot.hasData
                    ? Column(
                        children: [
                          const TitleSection(
                            title: 'OPERACIONES',
                            icon: Icons.shopping_cart,
                          ),
                          HistoricoValores(
                            valores: snapshot.data!
                                .where((data) => data.tipo != null)
                                .toList(),
                            delete: deleteOperacion,
                            fondo: widget.fondo,
                            isOperacion: true,
                          ),
                          /*const Divider(
                            height: 40,
                            color: Colors.black,
                          ),*/
                          const SizedBox(height: 40),
                          const TitleSection(
                            title: 'HISTÓRICO',
                            icon: Icons.calendar_month,
                          ),
                          HistoricoValores(
                            valores: snapshot.data!,
                            delete: deleteValor,
                            fondo: widget.fondo,
                          ),
                        ],
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
      ),
    );
  }
}

class HistoricoValores extends StatelessWidget {
  final Function(ValoresFondoData) delete;
  final List<ValoresFondoData> valores;
  final FondoData fondo;
  final bool isOperacion;

  const HistoricoValores({
    super.key,
    required this.valores,
    required this.delete,
    required this.fondo,
    this.isOperacion = false,
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
        ValoresFondoData valor = valores[index];
        /*if (index == valores.length - 1) {
          return ItemListView(
            index: index,
            valor: valor,
            diferencia: diferenciaValores,
          );
        }*/
        if (isOperacion) {
          valor = valores.reversed.toList()[index];
        }
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
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) => delete(valor),
          confirmDismiss: (direction) async {
            if (valor.tipo != null && !isOperacion) {
              return await ConfirmDialog.dialogBuilder(
                context,
                'Este valor tiene una operación asociada, '
                ' ¿eliminarlo de todas formas?',
              );
            }
            return true;
          },
          child: isOperacion
              ? ListOperaciones(
                  index: index,
                  valor: valor,
                )
              : ListHistorico(
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

class ListHistorico extends StatelessWidget {
  final int index;
  final int valoresLength;
  final ValoresFondoData valor;
  final Text Function(ValoresFondoData) diferencia;

  const ListHistorico({
    super.key,
    required this.index,
    required this.valoresLength,
    required this.valor,
    required this.diferencia,
  });

  Color getColor(BuildContext context, ValoresFondoData valor) {
    if (valor.tipo == TipoOp.suscripcion) {
      return const Color(0xFFA5D6A7);
    }
    if (valor.tipo == TipoOp.reembolso) {
      return const Color(0xFFEF9A9A);
    }
    return Theme.of(context).colorScheme.primaryContainer;
  }

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
              backgroundColor: getColor(context, valor),
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
              FechaUtil.dateToString(
                date: valor.fecha,
                formato: 'dd/MM/yy',
              ),
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

class ListOperaciones extends StatelessWidget {
  final int index;
  final ValoresFondoData valor;

  const ListOperaciones({
    super.key,
    required this.index,
    required this.valor,
  });

  Widget getIcon(BuildContext context, ValoresFondoData valor) {
    if (valor.tipo == TipoOp.suscripcion) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFA5D6A7),
        child: Icon(Icons.add_shopping_cart),
      );
    }
    if (valor.tipo == TipoOp.reembolso) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFEF9A9A),
        child: Icon(Icons.currency_exchange),
      );
    }
    return const Icon(Icons.shopping_cart);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            /*child: Text(
              '${valor.tipo?.name.toUpperCase()}',
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
            ),*/
            child: getIcon(context, valor),
          ),
          Expanded(
            flex: 3,
            child: Text(
              FechaUtil.dateToString(
                date: valor.fecha,
                formato: 'dd/MM/yy',
              ),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${NumberUtil.decimal(valor.participaciones ?? 0)} part.',
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
            flex: 3,
            child: Text(
              NumberUtil.currency((valor.participaciones ?? 0) * valor.valor),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  final String title;
  final IconData icon;
  const TitleSection({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(child: Icon(icon)),
            const SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
