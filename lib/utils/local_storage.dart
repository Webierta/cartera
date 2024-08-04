import 'package:shared_preferences/shared_preferences.dart';

import '../services/db_transfer.dart';

class LocalStorage {
  static SharedPreferences? _sharedPrefs;
  String pathToFile = '';
  static const String _dbPath = 'keyDbPath';

  init() async {
    pathToFile = await DbTransfer.getDbPath();
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get dbPath => _sharedPrefs?.getString(_dbPath) ?? pathToFile;
  set dbPath(String value) => _sharedPrefs?.setString(_dbPath, value);
}
