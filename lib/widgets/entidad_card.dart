import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/entidad_screen.dart';
import '../services/app_database.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';

class EntidadCard extends ConsumerStatefulWidget {
  final EntidadData entidad;
  final bool? entidadScreen;
  const EntidadCard({
    super.key,
    required this.entidad,
    this.entidadScreen = false,
  });

  @override
  ConsumerState<EntidadCard> createState() => _EntidadCardState();
}

class _EntidadCardState extends ConsumerState<EntidadCard> {
  late AppDatabase database;
  double sumaCuentasEntidad = 0;
  double sumaDepositosEntidad = 0;
  double sumasFondosEntidad = 0;
  double totalEntidad = 0;
  double totalEntidades = 0;

  /* Map<EntidadData, double> mapEntidadTotal = {};
  Map<EntidadData, double> mapEntidadCuentas = {};
  Map<EntidadData, double> mapEntidadDepositos = {};
  Map<EntidadData, double> mapEntidadFondos = {};
  double sumaTotal = 0; */

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadSumas();
    //loadTotales();
    sumarTotalesEntidades();
    super.initState();
  }

  Future<void> sumarTotalesEntidades() async {
    final getHistorico = await database.allHistorico;
    if (getHistorico.isEmpty) {
      if (mounted) setState(() => totalEntidades = 0);
    } else {
      final historico = getHistorico.first;
      final total = historico.totalCuentas +
          historico.totalDepositos +
          historico.totalFondos;
      if (mounted) {
        setState(() => totalEntidades = total);
      }
    }
  }

  Future<void> loadSumas() async {
    var cuentas = await sumaCuentas;
    var depositos = await sumaDepositos;
    var fondos = await sumaFondos;
    if (mounted) {
      setState(() {
        sumaCuentasEntidad = cuentas;
        sumaDepositosEntidad = depositos;
        sumasFondosEntidad = fondos;
        totalEntidad = cuentas + depositos + fondos;
      });
    }
  }

  /* Future<void> loadTotales() async {
    Map<EntidadData, double> entidadTotal = {};
    Map<EntidadData, double> entidadCuentas = {};
    Map<EntidadData, double> entidadDepositos = {};
    Map<EntidadData, double> entidadFondos = {};
    //for (var entidad in entidades) {
    entidadCuentas[widget.entidad] = await sumaCuentas;
    entidadDepositos[widget.entidad] = await sumaDepositos;
    entidadFondos[widget.entidad] = await sumaFondos;
    entidadTotal[widget.entidad] = (entidadCuentas[widget.entidad] ?? 0) +
        (entidadDepositos[widget.entidad] ?? 0) +
        (entidadFondos[widget.entidad] ?? 0);
    //total += entidadTotal[entidad];
    //}
    setState(() {
      mapEntidadCuentas = entidadCuentas;
      mapEntidadDepositos = entidadDepositos;
      mapEntidadFondos = entidadFondos;
      mapEntidadTotal = entidadTotal;
      sumaTotal =
          mapEntidadTotal.values.reduce((value, element) => value + element);
    });
  } */

  Future<double> get sumaCuentas async {
    var cuentas = await database.allCuentas;
    cuentas = cuentas
        .where((cuenta) => cuenta.entidad == widget.entidad.name)
        .toList();
    if (cuentas.isEmpty) {
      return 0;
    }
    double saldo = 0;
    for (var cuenta in cuentas) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isNotEmpty) {
        saldo += saldosCuenta.first.saldo;
      }
    }
    return saldo;
  }

  Future<double> get sumaDepositos async {
    var depositos = await database.allDepositos;
    depositos = depositos
        .where((deposito) => deposito.entidad == widget.entidad.name)
        .toList();
    if (depositos.isEmpty) {
      return 0;
    }
    double imposiciones = 0;
    for (DepositoData deposito in depositos) {
      imposiciones += deposito.imposicion;
    }
    return imposiciones;
  }

  Future<double> get sumaFondos async {
    var fondos = await database.allFondos;
    fondos =
        fondos.where((fondo) => fondo.entidad == widget.entidad.name).toList();
    if (fondos.isEmpty) {
      return 0;
    }
    double capital = 0;
    for (var fondo in fondos) {
      final valoresFondo = await database.getValores(fondo.id);
      Stats stats = Stats(valoresFondo);
      capital += stats.resultado() ?? 0;
      /* if (valoresFondo.isEmpty) {
        capital += fondo.participaciones * fondo.valorInicial;
      } else {
        capital += fondo.participaciones * valoresFondo.first.valor;
      } */
    }
    return capital;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: InkWell(
                onTap: () {
                  widget.entidadScreen == false
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EntidadScreen(entidad: widget.entidad)))
                      : null;
                },
                child: File(widget.entidad.logo).existsSync()
                    ? Image.file(File(widget.entidad.logo))
                    : Image.asset('assets/account_balance.png'),
              ),
            ),
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Container(
                      height: 180,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  widget.entidadScreen == false
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EntidadScreen(
                                                entidad: widget.entidad),
                                          ),
                                        )
                                      : null;
                                },
                                child: Text(
                                  widget.entidad.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            widget.entidad.bic ?? '',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SelectableText(widget.entidad.web ?? ''),
                              SelectableText(widget.entidad.phone ?? ''),
                              SelectableText(widget.entidad.email ?? ''),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProductoEntidad(
                    icon: Icons.account_balance,
                    //suma: mapEntidadTotal[widget.entidad] ?? 0,
                    suma: totalEntidad,
                  ),
                  //Text(totalEntidades.toStringAsFixed(2)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      NumberUtil.porcentage(
                          totalEntidad * 100 / totalEntidades),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  ProductoEntidad(
                    icon: Icons.account_balance_wallet,
                    //suma: mapEntidadCuentas[widget.entidad] ?? 0,
                    suma: sumaCuentasEntidad,
                    //suma: getTotalCuenta().then((onValue) => onValue);
                  ),
                  const SizedBox(height: 6),
                  ProductoEntidad(
                    icon: Icons.savings,
                    //suma: mapEntidadDepositos[widget.entidad] ?? 0,
                    suma: sumaDepositosEntidad,
                  ),
                  const SizedBox(height: 6),
                  ProductoEntidad(
                    icon: Icons.assessment,
                    //suma: mapEntidadFondos[widget.entidad] ?? 0,
                    suma: sumasFondosEntidad,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductoEntidad extends StatelessWidget {
  final IconData icon;
  final double suma;
  const ProductoEntidad({
    super.key,
    required this.icon,
    required this.suma,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = icon == Icons.account_balance
        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 16);

    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          NumberUtil.currency(suma),
          style: textStyle,
        ),
        if (icon != Icons.account_balance) const SizedBox(width: 6),
        if (icon != Icons.account_balance) Icon(icon),
      ],
    );
  }
}
