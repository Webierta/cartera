import 'dart:io';

import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../services/app_database.dart';
import '../widgets/confirm_dialog.dart';
import 'entidades_screen.dart';

class EntidadAddScreen extends ConsumerStatefulWidget {
  final EntidadData? editEntidad;
  const EntidadAddScreen({super.key, this.editEntidad});
  @override
  ConsumerState<EntidadAddScreen> createState() => _EntidadAddScreenState();
}

class _EntidadAddScreenState extends ConsumerState<EntidadAddScreen> {
  late AppDatabase database;
  TextEditingController name = TextEditingController();
  TextEditingController bic = TextEditingController();
  TextEditingController web = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController logo = TextEditingController();

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    if (widget.editEntidad != null) {
      name.text = widget.editEntidad!.name;
      //bic.text = widget.editEntidad!.bic;
      //web.text = widget.editEntidad!.web;
      //phone.text = widget.editEntidad!.phone;
      //email.text = widget.editEntidad!.email;
      logo.text = widget.editEntidad!.logo;
    }
    if (widget.editEntidad?.bic != null) {
      bic.text = widget.editEntidad!.bic!;
    }
    if (widget.editEntidad?.web != null) {
      web.text = widget.editEntidad!.web!;
    }
    if (widget.editEntidad?.phone != null) {
      phone.text = widget.editEntidad!.phone!;
    }
    if (widget.editEntidad?.email != null) {
      email.text = widget.editEntidad!.email!;
    }

    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    bic.dispose();
    web.dispose();
    phone.dispose();
    email.dispose();
    logo.dispose();
    super.dispose();
  }

  Future pickImage() async {
    // || name.text.trim().length < 3
    if (name.text.trim().isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Dime al menos el nombre de la Entidad'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      logo.text = image.path;
      final File imageTemp = File(image.path);
      final bytes = await imageTemp.readAsBytes();
      final docsDir = await getApplicationDocumentsDirectory();
      String nombreEntidad = name.text.trim();
      String imagePath = '${docsDir.path}/carteraDB/$nombreEntidad.png';
      final file = File(imagePath);
      await file.writeAsBytes(bytes);

      // setState(() {
      //logo.text = file.path;
      //});
    } catch (e) {
      return;
    }
  }

  Future<void> addEntidad() async {
    if (name.text.trim().isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Faltan datos de la Entidad'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    var newEntidad = EntidadCompanion(
      name: dr.Value(name.text),
      bic: dr.Value(bic.text),
      web: dr.Value(web.text),
      phone: dr.Value(phone.text),
      email: dr.Value(email.text),
      logo: dr.Value(logo.text),
    );
    if (widget.editEntidad == null) {
      bool repetido = false;
      var entidades = await database.allEntidades;
      entidades.map((e) {
        if (e.name == name.text) {
          repetido = true;
        }
      }).toList();
      if (repetido) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ya existe una entidad con ese nombre.'),
          ),
        );
        return;
      } else {
        await database.addEntidad(newEntidad);
      }
    } else {
      await database.updateEntidad(widget.editEntidad!.id, newEntidad);
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EntidadesScreen()),
    );
  }

  Future<bool> tieneProducto(EntidadData entidad) async {
    var cuentas = await database.allCuentas;
    var cuentasEntidad =
        cuentas.where((cuenta) => cuenta.entidad == entidad.name);
    if (cuentasEntidad.isNotEmpty) {
      return true;
    }
    var depositos = await database.allDepositos;
    var depositosEntidad =
        depositos.where((deposito) => deposito.entidad == entidad.name);
    if (depositosEntidad.isNotEmpty) {
      return true;
    }
    var fondos = await database.allFondos;
    var fondosEntidad = fondos.where((fondo) => fondo.entidad == entidad.name);
    if (fondosEntidad.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> deleteEntidad() async {
    if (await tieneProducto(widget.editEntidad!)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Esta entidad no se puede eliminar porque '
            'tiene productos vinculados',
          ),
        ),
      );
      return;
    }
    if (!mounted) return;
    var confirm = await ConfirmDialog.dialogBuilder(context);
    if (confirm == true) {
      await database.deleteEntidad(widget.editEntidad!.id);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EntidadesScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.editEntidad == null ? 'Nueva Entidad' : 'Edita Entidad'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            TextField(
              controller: bic,
              decoration: const InputDecoration(
                labelText: 'BIC',
              ),
            ),
            TextField(
              controller: web,
              decoration: const InputDecoration(
                labelText: 'Web',
              ),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
              ),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: logo,
              onTap: pickImage,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.image),
                labelText: 'Logo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (widget.editEntidad != null)
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: deleteEntidad,
                  child: const Text('ELIMINAR'),
                ),
              ),
            if (widget.editEntidad != null) const Spacer(),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: addEntidad,
                child: const Text('GUARDAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
