// https://r1n1os.medium.com/drift-local-database-for-flutter-part-4-many-to-many-relationship-9775b81453d2

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../utils/fecha_util.dart';

class DbTransfer {
  static Directory? _dirBackup;

  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _dirBackup ??=
        await Directory('${dir.path}/carteraDB/').create(recursive: true);
  }

  ///carteraDB/backup

  static Future<String> getDbPath() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Directory dirApp =
        await Directory('${dir.path}/carteraDB').create(recursive: true);
    String fileName = 'cartera_db.sqlite';
    return join(dirApp.path, fileName);
  }

  Future<File?> export() async {
    final fecha =
        FechaUtil.dateToString(date: DateTime.now(), formato: 'ddMMyy');
    try {
      final directorio = await FilePicker.platform.getDirectoryPath(
        initialDirectory: _dirBackup?.path,
      );
      if (directorio != null) {
        //File file = File(result.files.single.path!);
        String fileName = 'cartera_db$fecha.sqlite';
        String pathToFile = join(directorio, fileName);
        File file = File(pathToFile);
        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<File?> import() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        initialDirectory: _dirBackup?.path,
      );
      if (result != null) {
        File file = File(result.files.single.path!);
        if (extension(file.path) != '.sqlite') {
          return null;
        }
        return file;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
