import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import 'entidad_screen.dart';

class AlarmaAddScreen extends ConsumerStatefulWidget {
  final AlarmaData? editAlarma;
  final EntidadData entidad;
  const AlarmaAddScreen({super.key, required this.entidad, this.editAlarma});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmaAddScreenState();
}

class _AlarmaAddScreenState extends ConsumerState<AlarmaAddScreen> {
  late AppDatabase database;
  TextEditingController fechaController = TextEditingController();
  TextEditingController avisoController = TextEditingController();

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    if (widget.editAlarma != null) {
      setEditAlarma();
    }
    super.initState();
  }

  setEditAlarma() {
    setState(() {
      fechaController.text =
          FechaUtil.dateToString(date: widget.editAlarma!.fecha);
      avisoController.text = widget.editAlarma!.aviso;
    });
  }

  @override
  void dispose() {
    fechaController.dispose();
    avisoController.dispose();
    super.dispose();
  }

  Future<void> addAlarma() async {
    if (avisoController.text.trim().isEmpty || fechaController.text.isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(content: Text('Faltan datos de la Alarma'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var newAlarma = AlarmaCompanion(
      fecha: dr.Value(FechaUtil.stringToDateHms(fechaController.text)),
      aviso: dr.Value(avisoController.text),
      entidad: dr.Value(widget.entidad.name),
    );
    if (widget.editAlarma == null) {
      await database.addAlarma(newAlarma);
    } else {
      await database.updateAlarma(widget.editAlarma!.id, newAlarma);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntidadScreen(entidad: widget.entidad),
      ),
    );
  }

  Future<void> deleteAlarma() async {
    await database.deleteAlarma(widget.editAlarma!.id);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntidadScreen(entidad: widget.entidad),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editAlarma == null
              ? 'Nueva Alarma'
              : 'Edita Alarma ${widget.editAlarma!.entidad}',
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.today),
                labelText: 'Fecha',
                border: OutlineInputBorder(),
              ),
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
            ),
            const SizedBox(height: 20),
            TextField(
              controller: avisoController,
              maxLines: 10,
              decoration: const InputDecoration(
                labelText: 'Aviso',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.editAlarma != null)
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: deleteAlarma,
                  child: const Text('ELIMINAR'),
                ),
              ),
            if (widget.editAlarma != null) const Spacer(),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: addAlarma,
                child: const Text('GUARDAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
