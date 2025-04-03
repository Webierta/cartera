import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';

import '../services/app_database.dart';
import '../utils/local_storage.dart';
import 'cartera_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late AppDatabase database;
  final LocalStorage sharedPrefs = LocalStorage();
  //bool loginRequerido = false;
  //bool deleteUserActivo = true;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    initLocalStorage();
    super.initState();
  }

  initLocalStorage() async {
    await sharedPrefs.init();
  }

  deleteUser() async {
    //borra usuario y contraseña
    final storage = FlutterSecureStorage();
    String userActivo = sharedPrefs.userActivo;
    await storage.delete(key: userActivo);
    // activa acceso publico
    setState(() {
      sharedPrefs.loginRequerido = false;
      sharedPrefs.userActivo = '';
    });
  }

  copyDb(File file) async {
    await database.exportInto(file);
  }

  cambiarRutaDb(BuildContext context) async {
    // 1. seleccionar directorio
    try {
      final directorio = await FilePicker.platform.getDirectoryPath(
          //initialDirectory: _dirBackup?.path,
          );
      if (directorio != null) {
        String fileName = 'cartera_db.sqlite';
        String pathToFile = join(directorio, fileName);
        File file = File(pathToFile);
        // 2. copiar archivo db a nuevo directorio
        await copyDb(file);
        // 4. cambiar nueva ruta en db_transfer
        //DbTransfer().setPathDb(pathToFile);

        // 3. Guardar nueva ruta en local_storage
        sharedPrefs.dbPath = pathToFile;
        // 5. reinicar app
        await database.close();
        //sharedPrefs.dbPath = await DbTransfer.getDbPath();
        if (context.mounted) {
          Iterum.revive(context);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CarteraScreen(),
              ),
            );
          },
          icon: const Icon(Icons.home),
        ),
        title: const Text('Ajustes'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.storage, size: 40),
              title: Text('Ruta de la base de datos'),
              subtitle: Text(sharedPrefs.dbPath),
              trailing: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: InkWell(
                  onTap: () {
                    cambiarRutaDb(context);
                  },
                  child: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.security,
                size: 40,
              ),
              title: const Text('Acceso restringido con contraseña'),
              subtitle: Text(
                sharedPrefs.loginRequerido && sharedPrefs.userActivo.isNotEmpty
                    ? 'Usuario activo: ${sharedPrefs.userActivo}'
                    : 'Registra un usuario autorizado',
              ),
              trailing: Switch(
                value: sharedPrefs.loginRequerido,
                onChanged: (value) {
                  if (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(registro: true),
                      ),
                    );
                  } else {
                    setState(() => sharedPrefs.loginRequerido = false);
                    deleteUser();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
