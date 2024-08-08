import 'package:flutter/material.dart';

enum Menu {
  exportar(Icons.save),
  importar(Icons.file_download),
  eliminar(Icons.delete_forever),
  editar(Icons.edit),
  limpiar(Icons.cleaning_services);
  //info(Icons.info);

  final IconData icon;
  const Menu(this.icon);
}

class MenuItem {
  static PopupMenuItem<Enum> buildMenuItem(Menu menu,
      {bool divider = false, bool isOrder = false}) {
    return PopupMenuItem(
      value: menu,
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 2),
            dense: true,
            leading: Icon(menu.icon),
            title: Text(
              '${menu.name[0].toUpperCase()}${menu.name.substring(1)}',
              maxLines: 1,
            ),
          ),
          if (divider == true) const Divider(), // PopMenuDivider
        ],
      ),
    );
  }
}
