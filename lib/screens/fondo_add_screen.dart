import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as dr;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../widgets/input_entidad.dart';
import '../widgets/input_titular.dart';
import 'fondo_search_screen.dart';
import 'fondo_search_storage.dart';
import 'fondos_screen.dart';

class FondoAddScreen extends ConsumerStatefulWidget {
  final FondoData? editFondo;
  const FondoAddScreen({super.key, this.editFondo});

  @override
  ConsumerState<FondoAddScreen> createState() => _FondoAddScreenState();
}

class _FondoAddScreenState extends ConsumerState<FondoAddScreen> {
  String titular = Titular.ambos.name;
  TextEditingController nombre = TextEditingController();
  TextEditingController isin = TextEditingController();
  TextEditingController participaciones = TextEditingController();
  TextEditingController valorInicial = TextEditingController();
  TextEditingController fechaInicial = TextEditingController();
  TextEditingController entidad = TextEditingController();
  //double? inversion;
  //double? capital;
  //double? tae;
  //double? rendimiento;
  double? unidades;
  double? precio;

  @override
  void initState() {
    if (widget.editFondo != null) {
      nombre.text = widget.editFondo!.name;
      isin.text = widget.editFondo!.isin ?? '';
      participaciones.text = (widget.editFondo!.participaciones).toString();
      valorInicial.text = (widget.editFondo!.valorInicial).toString();
      fechaInicial.text =
          FechaUtil.dateToString(date: widget.editFondo!.fechaInicial);
      entidad.text = widget.editFondo!.entidad;
      titular = widget.editFondo!.titular.name;
    }
    super.initState();
  }

  @override
  void dispose() {
    nombre.dispose();
    isin.dispose();
    participaciones.dispose();
    valorInicial.dispose();
    fechaInicial.dispose();
    entidad.dispose();
    super.dispose();
  }

  double get inversion {
    if (unidades != null && precio != null) {
      return unidades! * precio!;
    }
    return 0;
  }

  void setTitular(String newTitular) {
    setState(() => titular = newTitular);
  }

  Future<void> addFondo() async {
    if (nombre.text.trim().isEmpty ||
        isin.text.trim().isEmpty ||
        participaciones.text.trim().isEmpty ||
        valorInicial.text.trim().isEmpty ||
        fechaInicial.text.trim().isEmpty ||
        entidad.text.trim().isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Faltan datos para crear el Fondo'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    final database = ref.read(AppDatabase.provider);
    var entidadesList = await database.allEntidades;
    EntidadData entidadSelect =
        entidadesList.firstWhere((e) => e.name == entidad.text);
    var newFondo = FondoCompanion(
      name: dr.Value(nombre.text),
      isin: dr.Value(isin.text),
      participaciones:
          dr.Value(double.tryParse(participaciones.text.trim()) ?? 0),
      fechaInicial: dr.Value(FechaUtil.stringToDate(fechaInicial.text.trim())),
      valorInicial: dr.Value(double.tryParse(valorInicial.text.trim()) ?? 0),
      titular:
          dr.Value(Titular.values.firstWhere((tit) => tit.name == titular)),
      entidad: dr.Value(entidadSelect.name),
    );
    if (widget.editFondo == null) {
      await database.addFondo(newFondo);
    } else {
      await database.updateFondo(widget.editFondo!.id, newFondo);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FondosScreen(),
      ),
    );
  }

  Future<void> searchFondoStorage() async {
    FondoCompanion? findFondo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FondoSearchStorage(),
      ),
    );
    if (findFondo != null) {
      nombre.text = findFondo.name.value;
      isin.text = findFondo.isin.value!;
    }
  }

  Future<void> searchFondo() async {
    FondoCompanion? findFondo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FondoSearchScreen(),
      ),
    );
    if (findFondo != null) {
      nombre.text = findFondo.name.value;
      isin.text = findFondo.isin.value!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editFondo == null ? 'Nuevo Fondo' : 'Editar Fondo',
        ),
        actions: [
          IconButton(
            onPressed: () {
              searchFondoStorage();
            },
            icon: const Icon(Icons.storage),
          ),
          IconButton(
            onPressed: () {
              searchFondo();
            },
            icon: const Icon(Icons.search),
          ),
        ],
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
              controller: isin,
              decoration: const InputDecoration(
                labelText: 'ISIN',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fechaInicial,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1970),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          var dateInicio = FechaUtil.dateToDateHms(pickedDate);
                          fechaInicial.text =
                              FechaUtil.dateToString(date: dateInicio);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.today),
                      labelText: 'Fecha Inicio',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: participaciones,
                    onChanged: (String value) {
                      setState(() {
                        unidades =
                            double.tryParse(participaciones.text.trim()) ?? 0;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.add_shopping_cart),
                      labelText: 'Participaciones',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: valorInicial,
                    onChanged: (String value) {
                      setState(() {
                        precio = double.tryParse(valorInicial.text.trim()) ?? 0;
                      });
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.euro),
                      labelText: 'Valor Inicial',
                      labelStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Chip(
                  backgroundColor: Theme.of(context).focusColor,
                  avatar: const Icon(Icons.euro),
                  label: Text(
                    NumberUtil.currency(inversion),
                  ),
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
          onPressed: addFondo,
          child: const Text('GUARDAR'),
        ),
      ),
    );
  }
}
