import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'cuenta_add_screen.dart';
import 'cuentas_screen.dart';

class CuentaScreen extends ConsumerStatefulWidget {
  final CuentaData cuenta;
  const CuentaScreen({super.key, required this.cuenta});
  @override
  ConsumerState<CuentaScreen> createState() => _CuentaScreenState();
}

class _CuentaScreenState extends ConsumerState<CuentaScreen> {
  late AppDatabase database;
  TextEditingController fechaController = TextEditingController();
  TextEditingController precioController = TextEditingController();

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    super.initState();
  }

  @override
  void dispose() {
    fechaController.dispose();
    precioController.dispose();
    super.dispose();
  }

  Widget childAvatar(Titular titular) {
    return titular == Titular.ambos
        ? const Icon(Icons.group)
        : Text(titular.name.toUpperCase()[0]);
  }

  Future<void> addSaldo() async {
    if (fechaController.text.isEmpty || precioController.text.isEmpty) {
      return;
    }
    var fecha = FechaUtil.stringToDateHms(fechaController.text);
    var newSaldo = SaldosCuentaCompanion(
      cuenta: dr.Value(widget.cuenta.id),
      fecha: dr.Value(fecha),
      saldo: dr.Value(double.tryParse(precioController.text) ?? 0),
    );

    final saldosByFecha =
        await database.getSaldosByFecha(widget.cuenta.id, fecha);
    if (saldosByFecha.isNotEmpty) {
      await database.updateSaldo(saldosByFecha.first.id, newSaldo);
    } else {
      await database.addSaldoCuenta(newSaldo);
    }
  }

  Future<void> deleteSaldo(int idSaldo) async {
    await database.deleteSaldo(idSaldo);
  }

  Future<void> deleteCuenta() async {
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar esta Cuenta y todos sus saldos asociados?',
    );
    if (confirm == true) {
      await database.deleteSaldosCuenta(widget.cuenta.id);
      await database.deleteCuenta(widget.cuenta.id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CuentasScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cuenta.name),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CuentasScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
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
                        CuentaAddScreen(editCuenta: widget.cuenta),
                  ),
                );
              } else if (item == Menu.exportar) {
                // EXPORTAR
              } else if (item == Menu.eliminar) {
                deleteCuenta();
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
                child: childAvatar(widget.cuenta.titular),
              ),
              title: Text(
                widget.cuenta.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.cuenta.iban,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  NumberUtil.porcentage(widget.cuenta.tae),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const Divider(height: 20),
            StreamBuilder<List<SaldosCuentaData>>(
              stream: database.getSaldosCuenta(widget.cuenta.id),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<SaldosCuentaData>> snapshot,
              ) {
                return snapshot.hasData
                    ? HistoricoSaldo(
                        saldos: snapshot.data!,
                        delete: deleteSaldo,
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
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1970),
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
                  labelText: 'Saldo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: addSaldo,
              icon: const Icon(Icons.add_to_photos, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricoSaldo extends StatelessWidget {
  final Function(int) delete;
  final List<SaldosCuentaData> saldos;
  const HistoricoSaldo({
    super.key,
    required this.saldos,
    required this.delete,
  });

  Text diferenciaSaldos(SaldosCuentaData saldo) {
    bool condition = saldos.length > (saldos.indexOf(saldo) + 1);
    if (condition) {
      var dif = saldo.saldo - saldos[saldos.indexOf(saldo) + 1].saldo;
      return Text(
        NumberUtil.currency(dif),
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          color: dif < 0 ? Colors.red : Colors.green,
        ),
      );
    }
    return const Text('');
  }

  @override
  Widget build(BuildContext context) {
    if (saldos.isEmpty) {
      return const Center(child: Text('Sin datos'));
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: saldos.length,
      itemBuilder: (context, index) {
        final saldo = saldos[index];
        return Dismissible(
          key: ValueKey(saldo.id),
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
          onDismissed: (direction) => delete(saldo.id),
          child: ItemListView(
            index: index,
            saldosLength: saldos.length,
            saldo: saldo,
            diferencia: diferenciaSaldos,
          ),
        );
      },
    );
  }
}

class ItemListView extends StatelessWidget {
  final int index;
  final int saldosLength;
  final SaldosCuentaData saldo;
  final Text Function(SaldosCuentaData) diferencia;
  const ItemListView(
      {super.key,
      required this.index,
      required this.saldosLength,
      required this.saldo,
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
                '${saldosLength - index}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              FechaUtil.dateToString(date: saldo.fecha),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              NumberUtil.currency(saldo.saldo),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 6,
            child: diferencia(saldo),
          ),
        ],
      ),
    );
  }
}
