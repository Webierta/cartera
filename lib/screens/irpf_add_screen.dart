import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../widgets/background_image.dart';
import '../widgets/input_titular.dart';
import 'irpf_screen.dart';

class IRPFAddScreen extends ConsumerStatefulWidget {
  final IRPFData? editIRPF;
  final String entidad;
  final TipoProducto tipoProducto;
  final String codigo;
  const IRPFAddScreen({
    super.key,
    required this.entidad,
    required this.tipoProducto,
    required this.codigo,
    this.editIRPF,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IRPFAddAcreenState();
}

class _IRPFAddAcreenState extends ConsumerState<IRPFAddScreen> {
  late AppDatabase database;
  String titular = Titular.ambos.name;
  TextEditingController ejercicioController = TextEditingController();
  TextEditingController rendimientoController = TextEditingController();
  TextEditingController retencionController = TextEditingController();
  List<EntidadData> entidades = [];
  EntidadData? entidad;

  /* String entidad = '';
  String codigo = '';
  int ejercicio = 0; */

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadEntidades();
    if (widget.editIRPF != null) {
      setEditIRPF();
    }
    super.initState();
  }

  Future<void> loadEntidades() async {
    List<EntidadData> allEntidades = await database.allEntidades;
    var entidadSelect =
        allEntidades.where((e) => e.name == widget.entidad).toList();
    setState(() {
      entidades = allEntidades;
      entidad = entidadSelect.first;
    });
  }

  void setEditIRPF() {
    setState(() {
      /* entidad = widget.editIRPF!.entidad;
      codigo = widget.editIRPF!.codigo;
      ejercicio = widget.editIRPF!.ejercicio; */
      ejercicioController.text = widget.editIRPF!.ejercicio.toString();
      rendimientoController.text =
          widget.editIRPF!.rendimiento.toStringAsFixed(2);
      retencionController.text = widget.editIRPF!.rentencion.toStringAsFixed(2);
      titular = widget.editIRPF!.titular?.name ?? Titular.ambos.name;
    });
  }

  @override
  void dispose() {
    ejercicioController.dispose();
    rendimientoController.dispose();
    retencionController.dispose();
    super.dispose();
  }

  void setTitular(String newTitular) {
    setState(() => titular = newTitular);
  }

  Future<void> addIRPF() async {
    if (ejercicioController.text.trim().isEmpty ||
        rendimientoController.text.trim().isEmpty ||
        retencionController.text.trim().isEmpty ||
        int.tryParse(ejercicioController.text) == null ||
        double.tryParse(rendimientoController.text) == null ||
        double.tryParse(retencionController.text) == null) {
      if (!mounted) return;
      const snackBar =
          SnackBar(content: Text('Registro incompleto o incorrecto'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final newIRPF = IRPFCompanion(
      entidad: dr.Value(widget.entidad),
      tipoProducto: dr.Value(widget.tipoProducto),
      codigo: dr.Value(widget.codigo),
      ejercicio: dr.Value(int.parse(ejercicioController.text)),
      rendimiento: dr.Value(double.parse(rendimientoController.text)),
      rentencion: dr.Value(double.parse(retencionController.text)),
      titular:
          dr.Value(Titular.values.firstWhere((tit) => tit.name == titular)),
    );
    if (widget.editIRPF == null) {
      await database.addIRPF(newIRPF);
    } else {
      await database.updateIRPF(widget.editIRPF!.id, newIRPF);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IRPFScreen(),
      ),
    );
  }

  Future<void> deleteIRPF() async {
    await database.deleteIRPF(widget.editIRPF!.id);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IRPFScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editIRPF == null
              ? 'Nuevo registro IRPF'
              : 'Edita registro IRPF',
        ),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ListTile(
              leading: entidad != null
                  ? CircleAvatar(
                      backgroundImage: BackgroundImage.getImage(entidad!),
                    )
                  : null,
              title: Text(
                widget.entidad,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: [
                  Icon(widget.tipoProducto.icon),
                  const SizedBox(width: 10),
                  Text(widget.codigo),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: ejercicioController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.today),
                        labelText: 'Ejercicio',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: rendimientoController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.euro),
                        labelText: 'Rendimiento',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: retencionController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.euro),
                        labelText: 'Retención',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: InputTitular(
                titular: Titular.values.byName(titular),
                changeTitular: setTitular,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.editIRPF != null) ...[
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: deleteIRPF,
                  child: const Text('ELIMINAR'),
                ),
              ),
              const Spacer(),
            ],
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: addIRPF,
                child: const Text('GUARDAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
