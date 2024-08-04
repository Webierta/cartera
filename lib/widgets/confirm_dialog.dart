import 'package:flutter/material.dart';

class ConfirmDialog {
  static Future<bool?> dialogBuilder(BuildContext context, [String? message]) {
    String content = message ?? '¿Eliminar este producto y todos sus datos?';
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.warning_amber,
            size: 80,
            color: Colors.red,
          ),
          title: const Text('Confirmación requerida'),
          content: Text(content),
          actions: <Widget>[
            FilledButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
