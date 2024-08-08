import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../widgets/input_entidad.dart';
import '../widgets/input_titular.dart';
import 'depositos_screen.dart';

class DepositoAddScreen extends ConsumerStatefulWidget {
  final DepositoData? editDeposito;
  const DepositoAddScreen({super.key, this.editDeposito});
  @override
  ConsumerState<DepositoAddScreen> createState() => _DepositoAddScreenState();
}

class _DepositoAddScreenState extends ConsumerState<DepositoAddScreen> {
  late AppDatabase database;
  String titular = Titular.ambos.name;
  TextEditingController nombre = TextEditingController();
  TextEditingController codigo = TextEditingController();
  TextEditingController imposicion = TextEditingController();
  TextEditingController fechaInicio = TextEditingController();
  TextEditingController fechaVencimiento = TextEditingController();
  TextEditingController tae = TextEditingController();
  TextEditingController entidad = TextEditingController();
  bool renovacion = false;
  DateTime? dateInicio;
  DateTime? dateVencimiento;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    if (widget.editDeposito != null) {
      nombre.text = widget.editDeposito!.name;
      codigo.text = widget.editDeposito!.codigo ?? '';
      imposicion.text = (widget.editDeposito!.imposicion).toString();
      fechaInicio.text =
          FechaUtil.dateToString(date: widget.editDeposito!.inicio);
      fechaVencimiento.text =
          FechaUtil.dateToString(date: widget.editDeposito!.vencimiento);
      tae.text = (widget.editDeposito!.tae).toString();
      entidad.text = widget.editDeposito!.entidad;
      titular = widget.editDeposito!.titular.name;
      renovacion = widget.editDeposito!.renovacion;
      dateInicio = FechaUtil.dateToDateHms(widget.editDeposito!.inicio);
      dateVencimiento =
          FechaUtil.dateToDateHms(widget.editDeposito!.vencimiento);
    }
    super.initState();
  }

  @override
  void dispose() {
    nombre.dispose();
    codigo.dispose();
    imposicion.dispose();
    fechaInicio.dispose();
    fechaVencimiento.dispose();
    tae.dispose();
    entidad.dispose();
    super.dispose();
  }

  void setTitular(String newTitular) {
    setState(() => titular = newTitular);
  }

  int get plazo {
    if (dateInicio != null && dateVencimiento != null) {
      return dateVencimiento!.difference(dateInicio!).inDays ~/ 30;
    }
    return 0;
  }

  Future<void> addDeposito() async {
    if (nombre.text.trim().isEmpty ||
        codigo.text.trim().isEmpty ||
        imposicion.text.trim().isEmpty ||
        tae.text.trim().isEmpty ||
        fechaInicio.text.trim().isEmpty ||
        fechaVencimiento.text.trim().isEmpty ||
        entidad.text.trim().isEmpty ||
        FechaUtil.stringToDate(fechaVencimiento.text.trim())
            .isBefore(FechaUtil.stringToDate(fechaInicio.text.trim())) ||
        FechaUtil.stringToDate(fechaVencimiento.text.trim())
                .difference(FechaUtil.stringToDate(fechaInicio.text.trim()))
                .inDays <
            29) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Faltan datos para crear el Depósito'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    var entidadesList = await database.allEntidades;
    EntidadData entidadSelect =
        entidadesList.firstWhere((e) => e.name == entidad.text);
    var newDeposito = DepositoCompanion(
      name: dr.Value(nombre.text),
      codigo: dr.Value(codigo.text),
      tae: dr.Value(double.tryParse(tae.text.trim()) ?? 0),
      imposicion: dr.Value(double.tryParse(imposicion.text.trim()) ?? 0),
      inicio: dr.Value(FechaUtil.stringToDateHms(fechaInicio.text.trim())),
      vencimiento:
          dr.Value(FechaUtil.stringToDateHms(fechaVencimiento.text.trim())),
      renovacion: dr.Value(renovacion),
      titular:
          dr.Value(Titular.values.firstWhere((tit) => tit.name == titular)),
      entidad: dr.Value(entidadSelect.name),
    );
    if (widget.editDeposito == null) {
      await database.addDeposito(newDeposito);
    } else {
      await database.updateDeposito(widget.editDeposito!.id, newDeposito);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DepositosScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editDeposito == null ? 'Nuevo Depósito' : 'Editar Depósito',
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
              controller: codigo,
              decoration: const InputDecoration(
                labelText: 'Código',
              ),
            ),
            TextField(
              controller: imposicion,
              decoration: const InputDecoration(
                labelText: 'Imposición',
              ),
            ),
            TextField(
              controller: tae,
              decoration: const InputDecoration(
                labelText: 'TAE',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fechaInicio,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateInicio = FechaUtil.dateToDateHms(pickedDate);
                          fechaInicio.text =
                              FechaUtil.dateToString(date: dateInicio!);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.today),
                      labelText: 'Inicio',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Chip(
                  backgroundColor: Theme.of(context).focusColor,
                  avatar: Text('$plazo'),
                  label: const Text('meses'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: fechaVencimiento,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().add(const Duration(days: 1)),
                        //firstDate: DateTime(1970),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateVencimiento = FechaUtil.dateToDateHms(pickedDate);
                          fechaVencimiento.text =
                              FechaUtil.dateToString(date: dateVencimiento!);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.today),
                      labelText: 'Vencimiento',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ActionChip(
                  avatar:
                      Icon(renovacion ? Icons.update : Icons.update_disabled),
                  label: const Text('Renovación'),
                  onPressed: () {
                    setState(() {
                      renovacion = !renovacion;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
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
          onPressed: addDeposito,
          child: const Text('GUARDAR'),
        ),
      ),
    );
  }
}
