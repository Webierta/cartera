import 'dart:io';

import 'package:flutter/material.dart';

import '../services/app_database.dart';

class BackgroundImage {
  static ImageProvider getImage(EntidadData? entidad) {
    if (entidad == null) {
      return const AssetImage('assets/account_balance.png');
    }
    bool existe = File(entidad.logo).existsSync();
    if (existe) {
      return FileImage(File(entidad.logo));
    }
    return const AssetImage('assets/account_balance.png');
  }
}
