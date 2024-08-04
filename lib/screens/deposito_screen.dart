import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'deposito_add_screen.dart';
import 'depositos_screen.dart';

class DepositoScreen extends ConsumerStatefulWidget {
  final DepositoData deposito;
  const DepositoScreen({super.key, required this.deposito});
  @override
  ConsumerState<DepositoScreen> createState() => _DepositoScreenState();
}

class _DepositoScreenState extends ConsumerState<DepositoScreen> {
  int get plazo =>
      widget.deposito.vencimiento.difference(widget.deposito.inicio).inDays ~/
      30;

  double get retribucion =>
      ((widget.deposito.imposicion * widget.deposito.tae) / 100) * (plazo / 12);

  Widget childAvatar(Titular titular) {
    return titular == Titular.ambos
        ? const Icon(Icons.group)
        : Text(titular.name.toUpperCase()[0]);
  }

  (int, String) getPendiente() {
    DateTime hoy = DateTime.now();
    var dias = widget.deposito.vencimiento.difference(hoy).inDays;
    return dias > 60 ? (dias ~/ 30, 'meses') : (dias, 'días');
  }

  Future<void> deleteDeposito() async {
    final confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar este depósito?',
    );
    if (confirm == true) {
      final database = ref.read(AppDatabase.provider);
      await database.deleteDeposito(widget.deposito.id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DepositosScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deposito.name),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DepositosScreen(),
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
                        DepositoAddScreen(editDeposito: widget.deposito),
                  ),
                );
              } else if (item == Menu.exportar) {
                // EXPORTAR
              } else if (item == Menu.eliminar) {
                deleteDeposito();
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
                child: childAvatar(widget.deposito.titular),
              ),
              title: Text(
                '${widget.deposito.name} (${widget.deposito.entidad})',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.deposito.codigo ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.primary,
                child: Text(
                  NumberUtil.porcentage(widget.deposito.tae),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Chip(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                avatar: Icon(
                  widget.deposito.renovacion
                      ? Icons.update
                      : Icons.update_disabled,
                ),
                label: Text('$plazo meses'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      FechaUtil.dateToString(date: widget.deposito.inicio),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      NumberUtil.currency(widget.deposito.imposicion),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Expanded(
                  child: Slider(
                    activeColor: widget.deposito.vencimiento
                                .difference(DateTime.now())
                                .inDays <
                            30
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                    divisions: (widget.deposito.vencimiento
                            .difference(widget.deposito.inicio)
                            .inDays) ~/
                        30,
                    max: (widget.deposito.vencimiento
                            .difference(widget.deposito.inicio)
                            .inDays) +
                        0.0,
                    value: (widget.deposito.vencimiento
                            .difference(widget.deposito.inicio)
                            .inDays) -
                        (widget.deposito.vencimiento
                            .difference(DateTime.now())
                            .inDays) +
                        0.0,
                    onChanged: (double value) {},
                    label: 'Quedan ${getPendiente().$1} ${getPendiente().$2}',
                  ),
                ),
                Column(
                  children: [
                    Text(
                      FechaUtil.dateToString(date: widget.deposito.vencimiento),
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      NumberUtil.currency(retribucion),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
