import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/cuenta_screen.dart';
import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';

class EntidadCuentas extends ConsumerStatefulWidget {
  final EntidadData entidad;
  const EntidadCuentas({super.key, required this.entidad});

  @override
  ConsumerState<EntidadCuentas> createState() => _EntidadCuentasState();
}

class _EntidadCuentasState extends ConsumerState<EntidadCuentas> {
  late AppDatabase database;
  List<CuentaData> cuentasEntidad = [];
  Map<CuentaData, SaldosCuentaData> mapCuentaSaldo = {};

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadCuentasEntidad();
    super.initState();
  }

  loadCuentasEntidad() async {
    final cuentas = await database.allCuentas;
    if (mounted) {
      setState(() {
        cuentasEntidad =
            cuentas.where((c) => c.entidad == widget.entidad.name).toList();
      });
    }

    //getCuentaSaldo();
    for (var cuenta in cuentasEntidad) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isNotEmpty) {
        if (mounted) {
          setState(() {
            mapCuentaSaldo[cuenta] = saldosCuenta.first;
          });
        }
      }
    }
  }

  /* Future<void> getCuentaSaldo() async {
    for (var cuenta in cuentasEntidad) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isNotEmpty) {
        //setState(() {
        mapCuentaSaldo[cuenta] = saldosCuenta.first;
        //});
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: cuentasEntidad.length,
      itemBuilder: (context, index) {
        final cuenta = cuentasEntidad[index];
        if (cuenta.entidad != widget.entidad.name) {
          return const SizedBox(height: 0);
        }
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CuentaScreen(cuenta: cuenta),
              ),
            );
          },
          //leading: CircleAvatar(child: Text(entidad[0])),
          leading: CircleAvatar(
            child: Text(
              cuenta.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          title: Text(cuenta.name),
          subtitle: Text(cuenta.iban),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberUtil.currency(mapCuentaSaldo[cuenta]?.saldo ?? 0),
                style: const TextStyle(fontSize: 14),
              ),
              if (mapCuentaSaldo[cuenta]?.fecha != null)
                Text(
                  FechaUtil.dateToString(
                    date: mapCuentaSaldo[cuenta]!.fecha,
                    formato: 'MMM yy',
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
