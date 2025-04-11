import 'package:shared_preferences/shared_preferences.dart';

import '../services/db_transfer.dart';

class LocalStorage {
  static SharedPreferences? _sharedPrefs;
  String pathToFile = '';
  static const String _dbPath = 'keyDbPath';
  static const String _loginRequerido = 'loginRequerido';
  static const String _userActivo = 'userActivo';
  //static const String _notas = 'notas';

  init() async {
    pathToFile = await DbTransfer.getDbPath();
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  /* initLogin() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  } */

  String get dbPath => _sharedPrefs?.getString(_dbPath) ?? pathToFile;
  set dbPath(String value) => _sharedPrefs?.setString(_dbPath, value);

  bool get loginRequerido => _sharedPrefs?.getBool(_loginRequerido) ?? false;
  set loginRequerido(bool value) =>
      _sharedPrefs?.setBool(_loginRequerido, value);

  String get userActivo => _sharedPrefs?.getString(_userActivo) ?? '';
  set userActivo(String value) => _sharedPrefs?.setString(_userActivo, value);

  //List<String> get notas => _sharedPrefs?.getStringList(_notas) ?? [];
  //set notas(List<String> value) => _sharedPrefs?.setStringList(_notas, value);
}
