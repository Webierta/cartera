import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../widgets/input_entidad.dart';
import '../widgets/input_titular.dart';
import 'cuentas_screen.dart';

class CuentaAddScreen extends ConsumerStatefulWidget {
  final CuentaData? editCuenta;
  const CuentaAddScreen({super.key, this.editCuenta});

  @override
  ConsumerState<CuentaAddScreen> createState() => _CuentaAddScreenState();
}

class _CuentaAddScreenState extends ConsumerState<CuentaAddScreen> {
  String titular = Titular.ambos.name;
  TextEditingController nombre = TextEditingController();
  TextEditingController iban = TextEditingController();
  TextEditingController tae = TextEditingController();
  TextEditingController entidad = TextEditingController();

  @override
  void initState() {
    if (widget.editCuenta != null) {
      nombre.text = widget.editCuenta!.name;
      iban.text = widget.editCuenta!.iban;
      tae.text = (widget.editCuenta!.tae).toString();
      entidad.text = widget.editCuenta!.entidad;
      titular = widget.editCuenta!.titular.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    nombre.dispose();
    iban.dispose();
    tae.dispose();
    entidad.dispose();
    super.dispose();
  }

  void setTitular(String newTitular) {
    setState(() => titular = newTitular);
  }

  addCuenta() async {
    if (nombre.text.trim().isEmpty ||
        iban.text.trim().isEmpty ||
        tae.text.trim().isEmpty ||
        entidad.text.trim().isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Faltan datos para crear la Cuenta'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final database = ref.read(AppDatabase.provider);
    var entidadesList = await database.allEntidades;
    EntidadData entidadSelect =
        entidadesList.firstWhere((e) => e.name == entidad.text);
    var newCuenta = CuentaCompanion(
      name: dr.Value(nombre.text),
      iban: dr.Value(iban.text),
      tae: dr.Value(double.tryParse(tae.text.trim()) ?? 0),
      titular:
          dr.Value(Titular.values.firstWhere((tit) => tit.name == titular)),
      entidad: dr.Value(entidadSelect.name),
    );
    if (widget.editCuenta == null) {
      await database.addCuenta(newCuenta);
    } else {
      await database.updateCuenta(widget.editCuenta!.id, newCuenta);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CuentasScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editCuenta == null ? 'Nueva Cuenta' : 'Editar Cuenta',
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: iban,
              decoration: const InputDecoration(
                labelText: 'IBAN',
              ),
            ),
            TextField(
              controller: tae,
              decoration: const InputDecoration(
                labelText: 'TAE',
              ),
            ),
            InputEntidad(entidadController: entidad),
            const SizedBox(height: 20),
            InputTitular(
              titular: Titular.values.byName(titular),
              changeTitular: setTitular,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FilledButton(
          onPressed: addCuenta,
          child: const Text('GUARDAR'),
        ),
      ),
    );
  }
}
