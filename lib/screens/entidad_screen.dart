import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/entidad_card.dart';
import '../widgets/entidad_cuentas.dart';
import '../widgets/entidad_depositos.dart';
import '../widgets/entidad_fondos.dart';
import 'alarma_add_screen.dart';
import 'cartera_screen.dart';
import 'entidad_add_screen.dart';

class EntidadScreen extends ConsumerStatefulWidget {
  final EntidadData entidad;
  const EntidadScreen({super.key, required this.entidad});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntidadScreenState();
}

class _EntidadScreenState extends ConsumerState<EntidadScreen> {
  late AppDatabase database;
  double entidadCuentas = 0;
  Map<String, double> entidadSaldo = {};
  Map<String, double> entidadImposicion = {};
  Map<String, double> entidadCapital = {};
  List<AlarmaData> alarmas = [];
  List<AlarmaData> alarmasEntidad = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getEntidadSaldo();
    getEntidadImposicion();
    getEntidadCapital();
    getAlarmas();
    super.initState();
  }

  Future<void> getAlarmas() async {
    //final allAlarmas = await database.allAlarmas;
    final alarmasFecha = await database.alarmasFecha;
    setState(() {
      alarmas =
          alarmasFecha.where((c) => c.entidad == widget.entidad.name).toList();
    });
  }

  /* Future<List<AlarmaData>> getAlarmasEntidad(String entidad) async {
    return await database.alarmasEntidad(entidad);
  } */

  Future<void> getEntidadSaldo() async {
    final cuentas = await database.allCuentas;
    var cuentasEntidad =
        cuentas.where((c) => c.entidad == widget.entidad.name).toList();
    double saldo = 0;
    for (var cuenta in cuentasEntidad) {
      if (cuenta.entidad == widget.entidad.name) {
        List<SaldosCuentaData> saldosCuenta =
            await database.getSaldos(cuenta.id);
        if (saldosCuenta.isNotEmpty) {
          saldo += saldosCuenta.first.saldo;
        }
      }
    }
    setState(() {
      entidadSaldo[widget.entidad.name] = saldo;
      entidadCuentas = saldo;
    });
  }

  void getEntidadImposicion() async {
    final depositos = await database.allDepositos;
    var depositosEntidad =
        depositos.where((c) => c.entidad == widget.entidad.name).toList();
    double imposicion = 0;
    for (var deposito in depositosEntidad) {
      if (deposito.entidad == widget.entidad.name) {
        imposicion += deposito.imposicion;
      }
    }
    setState(() => entidadImposicion[widget.entidad.name] = imposicion);
  }

  Future<void> getEntidadCapital() async {
    final fondos = await database.allFondos;
    var fondosEntidad =
        fondos.where((c) => c.entidad == widget.entidad.name).toList();
    double capital = 0;
    for (var fondo in fondosEntidad) {
      if (fondo.entidad == widget.entidad.name) {
        final valoresFondo = await database.getValores(fondo.id);
        //Stats stats = Stats(valoresFondo);
        //capital += stats.resultado() ?? 0;
        if (valoresFondo.isEmpty) {
          capital += 0;
        } else {
          Stats stats = Stats(valoresFondo);
          capital += stats.resultado() ?? 0;
        }
      }
    }
    setState(() => entidadCapital[widget.entidad.name] = capital);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entidad.name),
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EntidadAddScreen(editEntidad: widget.entidad),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EntidadCard(entidad: widget.entidad, entidadScreen: true),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet,
                          size: 48,
                        ),
                        const Row(
                          children: [
                            Text(
                              'CUENTAS',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          //NumberUtil.currency(entidadSaldo[entidad] ?? 0),
                          //NumberUtil.currency(entidadSaldo[widget.entidad.name] ?? 0),
                          NumberUtil.currency(entidadCuentas),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    EntidadCuentas(entidad: widget.entidad),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.savings,
                          size: 48,
                        ),
                        const Row(
                          children: [
                            Text(
                              'DEPÓSITOS',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          NumberUtil.currency(
                              entidadImposicion[widget.entidad.name] ?? 0),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    EntidadDepositos(entidad: widget.entidad),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.assessment,
                          size: 48,
                        ),
                        const Row(
                          children: [
                            Text(
                              'FONDOS',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          NumberUtil.currency(
                              entidadCapital[widget.entidad.name] ?? 0),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    EntidadFondos(entidad: widget.entidad),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.alarm,
                          size: 48,
                        ),
                        const Text(
                          'ALARMAS',
                          style: TextStyle(fontSize: 20),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AlarmaAddScreen(entidad: widget.entidad),
                              ),
                            );
                          },
                          icon: const Icon(Icons.alarm_add),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: alarmas.length,
                      itemBuilder: (context, index) {
                        final alarma = alarmas[index];
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlarmaAddScreen(
                                  entidad: widget.entidad,
                                  editAlarma: alarma,
                                ),
                              ),
                            );
                          },
                          isThreeLine: true,
                          title: Text(
                            FechaUtil.dateToString(
                              date: alarma.fecha,
                              formato: 'd/MM/yy',
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(alarma.aviso),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
