import 'package:flutter/material.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import 'confirm_dialog.dart';

class HistoricoValores extends StatelessWidget {
  final Function(ValoresFondoData) delete;
  final List<ValoresFondoData> valores;
  final FondoData fondo;
  final bool isOperacion;

  const HistoricoValores({
    super.key,
    required this.valores,
    required this.delete,
    required this.fondo,
    this.isOperacion = false,
  });

  @override
  Widget build(BuildContext context) {
    if (valores.isEmpty) {
      return const Center(child: Text('Sin datos'));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: valores.length,
      itemBuilder: (context, index) {
        ValoresFondoData valor = valores[index];
        /*if (index == valores.length - 1) {
          return ItemListView(
            index: index,
            valor: valor,
            diferencia: diferenciaValores,
          );
        }*/
        if (isOperacion) {
          valor = valores.reversed.toList()[index];
        }
        final Stats stats = Stats(valores);
        return Dismissible(
          key: ValueKey(valor.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: Theme.of(context).cardTheme.margin,
            alignment: AlignmentDirectional.centerEnd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) => delete(valor),
          confirmDismiss: (direction) async {
            if (valor.tipo != null && !isOperacion) {
              return await ConfirmDialog.dialogBuilder(
                context,
                'Este valor tiene una operación asociada, '
                ' ¿eliminarlo de todas formas?',
              );
            }
            return true;
          },
          child: isOperacion
              ? ListOperaciones(
                  index: index,
                  valor: valor,
                )
              : ListHistorico(
                  index: index,
                  valoresLength: valores.length,
                  valor: valor,
                  difValores: stats.difValores(valor, fondo),
                  difPer: stats.difPer(valor, fondo),
                ),
        );
      },
    );
  }
}

class ListHistorico extends StatelessWidget {
  final int index;
  final int valoresLength;
  final ValoresFondoData valor;
  final double difValores;
  final double difPer;

  const ListHistorico({
    super.key,
    required this.index,
    required this.valoresLength,
    required this.valor,
    required this.difValores,
    required this.difPer,
  });

  Color getColor(BuildContext context, ValoresFondoData valor) {
    if (valor.tipo == TipoOp.suscripcion) {
      return const Color(0xFFA5D6A7);
    }
    if (valor.tipo == TipoOp.reembolso) {
      return const Color(0xFFEF9A9A);
    }
    return Theme.of(context).colorScheme.primaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              backgroundColor: getColor(context, valor),
              child: Text(
                //'${index + 1}',
                '${valoresLength - index}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              FechaUtil.dateToString(
                date: valor.fecha,
                formato: 'dd/MM/yy',
              ),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.currency(valor.valor),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          /*Expanded(
            flex: 2,
            child: diferencia(valor),
          ),*/
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.currency(difValores),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: difValores < 0 ? Colors.red : Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.percent(difPer),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                color: difPer < 0 ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListOperaciones extends StatelessWidget {
  final int index;
  final ValoresFondoData valor;

  const ListOperaciones({
    super.key,
    required this.index,
    required this.valor,
  });

  Widget getIcon(BuildContext context, ValoresFondoData valor) {
    if (valor.tipo == TipoOp.suscripcion) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFA5D6A7),
        child: Icon(Icons.add_shopping_cart),
      );
    }
    if (valor.tipo == TipoOp.reembolso) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFEF9A9A),
        child: Icon(Icons.currency_exchange),
      );
    }
    return const Icon(Icons.shopping_cart);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 1,
            /*child: Text(
              '${valor.tipo?.name.toUpperCase()}',
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
            ),*/
            child: getIcon(context, valor),
          ),
          Expanded(
            flex: 3,
            child: Text(
              FechaUtil.dateToString(
                date: valor.fecha,
                formato: 'dd/MM/yy',
              ),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              '${NumberUtil.decimal(valor.participaciones ?? 0)} part.',
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.currency(valor.valor),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              NumberUtil.currency((valor.participaciones ?? 0) * valor.valor),
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
