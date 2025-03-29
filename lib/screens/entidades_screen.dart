import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/entidad_card.dart';
import 'cartera_screen.dart';
import 'entidad_add_screen.dart';

class EntidadesScreen extends ConsumerStatefulWidget {
  const EntidadesScreen({super.key});
  @override
  ConsumerState<EntidadesScreen> createState() => _EntidadesScreenState();
}

class _EntidadesScreenState extends ConsumerState<EntidadesScreen> {
  final ScrollController _scrollController = ScrollController();
  late AppDatabase database;
  List<EntidadData> entidades = [];
  Map<EntidadData, double> mapEntidadTotal = {};
  Map<EntidadData, double> mapEntidadCuentas = {};
  Map<EntidadData, double> mapEntidadDepositos = {};
  Map<EntidadData, double> mapEntidadFondos = {};
  double sumaTotal = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadEntidades();
    super.initState();
  }

  Future<void> loadEntidades() async {
    var entidadesList = await database.allEntidades;
    if (entidadesList.isEmpty) {
      database.addEntidades();
      entidadesList = await database.allEntidades;
    }
    setState(() => entidades = entidadesList);
    loadTotales();
  }

  Future<double> sumaCuentas(EntidadData entidad) async {
    var cuentas = await database.allCuentas;
    cuentas =
        cuentas.where((cuenta) => cuenta.entidad == entidad.name).toList();
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

  Future<double> sumaDepositos(EntidadData entidad) async {
    var depositos = await database.allDepositos;
    depositos = depositos
        .where((deposito) => deposito.entidad == entidad.name)
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

  Future<double> sumaFondos(EntidadData entidad) async {
    var fondos = await database.allFondos;
    fondos = fondos.where((fondo) => fondo.entidad == entidad.name).toList();
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

  Future<void> loadTotales() async {
    Map<EntidadData, double> entidadTotal = {};
    Map<EntidadData, double> entidadCuentas = {};
    Map<EntidadData, double> entidadDepositos = {};
    Map<EntidadData, double> entidadFondos = {};
    for (var entidad in entidades) {
      entidadCuentas[entidad] = await sumaCuentas(entidad);
      entidadDepositos[entidad] = await sumaDepositos(entidad);
      entidadFondos[entidad] = await sumaFondos(entidad);
      entidadTotal[entidad] = (entidadCuentas[entidad] ?? 0) +
          (entidadDepositos[entidad] ?? 0) +
          (entidadFondos[entidad] ?? 0);
      //total += entidadTotal[entidad];
    }
    setState(() {
      mapEntidadCuentas = entidadCuentas;
      mapEntidadDepositos = entidadDepositos;
      mapEntidadFondos = entidadFondos;
      mapEntidadTotal = entidadTotal;
      sumaTotal =
          mapEntidadTotal.values.reduce((value, element) => value + element);
    });
  }

  void moveScroll() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(_scrollController.position.minScrollExtent,
          duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    });
  }

  void sortByTotal() async {
    var sortedMapEntidadTotal = Map.fromEntries(mapEntidadTotal.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)));
    setState(() {
      entidades = sortedMapEntidadTotal.keys.toList();
    });
    moveScroll();
  }

  void sortByName() {
    setState(() {
      entidades.sort(((a, b) => a.name.compareTo(b.name)));
    });
    moveScroll();
  }

  /* Future<bool> tieneProducto(EntidadData entidad) async {
    var cuentas = await database.allCuentas;
    var cuentasEntidad =
        cuentas.where((cuenta) => cuenta.entidad == entidad.name);
    if (cuentasEntidad.isNotEmpty) {
      return true;
    }
    var depositos = await database.allDepositos;
    var depositosEntidad =
        depositos.where((deposito) => deposito.entidad == entidad.name);
    if (depositosEntidad.isNotEmpty) {
      return true;
    }
    var fondos = await database.allFondos;
    var fondosEntidad = fondos.where((fondo) => fondo.entidad == entidad.name);
    if (fondosEntidad.isNotEmpty) {
      return true;
    }
    return false;
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: const Text('Entidades'),
        actions: [
          IconButton(
            onPressed: sortByTotal,
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            onPressed: sortByName,
            icon: const Icon(Icons.sort_by_alpha),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.account_balance),
                  ),
                  title: Text(
                    NumberUtil.currency(sumaTotal),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: CircleAvatar(
                    child: Text('${entidades.length}'),
                  ),
                ),
              )
            ],
          ),
          if (entidades.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                controller: _scrollController,
                itemCount: entidades.length,
                itemBuilder: (context, index) {
                  final entidad = entidades[index];
                  return EntidadCard(entidad: entidad);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EntidadAddScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
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
