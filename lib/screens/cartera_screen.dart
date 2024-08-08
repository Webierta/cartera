import 'dart:io';

import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/db_transfer.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/local_storage.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/dia_calendario.dart';
import '../widgets/menu.dart';
import 'cuentas_screen.dart';
import 'depositos_screen.dart';
import 'entidades_screen.dart';
import 'fondos_screen.dart';
import 'grafico_screen.dart';
import 'tabla_screen.dart';

class CarteraScreen extends ConsumerStatefulWidget {
  const CarteraScreen({super.key});
  @override
  ConsumerState<CarteraScreen> createState() => _CarteraScreenState();
}

class _CarteraScreenState extends ConsumerState<CarteraScreen> {
  late AppDatabase database;
  final LocalStorage sharedPrefs = LocalStorage();

  List<CuentaData> cuentas = [];
  List<DepositoData> depositos = [];
  List<FondoData> fondos = [];
  double totalCuentas = 0;
  double totalDepositos = 0;
  double totalFondos = 0;
  double total = 0;

  TextEditingController fechaController = TextEditingController();
  TextEditingController cuentasController = TextEditingController();
  TextEditingController depositosController = TextEditingController();
  TextEditingController fondosController = TextEditingController();
  List<HistoricoData> historico = [];
  int alertaDepositos = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    initLocalStorage();
    loadProducts();
    super.initState();
  }

  initLocalStorage() async {
    await sharedPrefs.init();
  }

  Future<void> loadEntidades() async {
    if ((await database.allEntidades).isEmpty) {
      database.addEntidades();
    }
  }

  Future<void> loadHistorico() async {
    final getHistorico = await database.allHistorico;
    setState(() {
      historico = getHistorico;
    });
  }

  Future<void> loadProducts() async {
    await loadEntidades();
    await loadCuentas();
    await loadDepositos();
    await loadFondos();
    setState(() {
      total = totalCuentas + totalDepositos + totalFondos;
    });
    fechaController.text = FechaUtil.dateToString(date: DateTime.now());
    cuentasController.text = totalCuentas.toString();
    depositosController.text = totalDepositos.toString();
    fondosController.text = totalFondos.toStringAsFixed(2);
    await loadHistorico();
  }

  Future<void> loadCuentas() async {
    final allCuentas = await database.allCuentas;
    setState(() {
      cuentas = allCuentas;
    });
    await getSaldoTotal();
  }

  Future<void> getSaldoTotal() async {
    List<double> lastSaldos = [];
    for (var cuenta in cuentas) {
      List<SaldosCuentaData> saldosCuenta = await database.getSaldos(cuenta.id);
      if (saldosCuenta.isEmpty) {
        continue;
      }
      lastSaldos.add(saldosCuenta.first.saldo);
    }
    if (lastSaldos.isEmpty) {
      setState(() {
        totalCuentas = 0;
      });
      return;
    }
    setState(() {
      totalCuentas = lastSaldos.reduce((value, element) => value + element);
    });
  }

  void checkAlertaDepositos() {
    int alertas = 0;
    for (var deposito in depositos) {
      if (deposito.vencimiento.difference(DateTime.now()).inDays < 30) {
        alertas++;
      }
    }
    setState(() {
      alertaDepositos = alertas;
    });
  }

  Future<void> loadDepositos() async {
    final allDepositos = await database.allDepositos;
    setState(() {
      depositos = allDepositos;
    });
    checkAlertaDepositos();
    getImposicionTotal();
  }

  void getImposicionTotal() {
    double imposicion = 0;
    for (var deposito in depositos) {
      imposicion += deposito.imposicion;
    }
    setState(() {
      totalDepositos = imposicion;
    });
  }

  Future<void> loadFondos() async {
    final allFondos = await database.allFondos;
    setState(() => fondos = allFondos);
    await getCapitalTotal();
  }

  Future<double> getCapital(FondoData fondo) async {
    /*final valoresFondo = await database.getValores(fondo.id);
    if (valoresFondo.isEmpty) {
      return 0;
    }
    return fondo.participaciones * valoresFondo.first.valor;*/
    final valoresFondo = await database.getValores(fondo.id);
    Stats stats = Stats(valoresFondo);
    return stats.resultado() ?? 0;
  }

  Future<void> getCapitalTotal() async {
    double capital = 0;
    for (var fondo in fondos) {
      capital += await getCapital(fondo);
    }
    setState(() => totalFondos = capital);
  }

  @override
  void dispose() {
    fechaController.dispose();
    cuentasController.dispose();
    depositosController.dispose();
    fondosController.dispose();
    super.dispose();
  }

  Future<void> addHistorico() async {
    if (fechaController.text.trim().isEmpty ||
        cuentasController.text.trim().isEmpty ||
        depositosController.text.trim().isEmpty ||
        fondosController.text.trim().isEmpty) {
      if (!mounted) return;
      const snackBar = SnackBar(
        content: Text('Faltan datos para guardar ese Histórico'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    HistoricoCompanion newHistorico = HistoricoCompanion(
      fecha: dr.Value(FechaUtil.stringToDateHms(fechaController.text.trim())),
      totalCuentas:
          dr.Value(double.tryParse(cuentasController.text.trim()) ?? 0),
      totalDepositos:
          dr.Value(double.tryParse(depositosController.text.trim()) ?? 0),
      totalFondos: dr.Value(double.tryParse(fondosController.text.trim()) ?? 0),
    );
    await database.addHistorico(newHistorico);
    loadProducts();
  }

  Future<void> deleteHistorico(int idHistorico) async {
    await database.deleteHistorico(idHistorico);
    //loadHistorico();
    loadProducts();
  }

  Future<void> dbExport() async {
    String content = 'Base de datos exportada';
    final DbTransfer dbTransfer = DbTransfer();
    await dbTransfer.init();
    final File? fileExport = await dbTransfer.export();
    if (fileExport != null) {
      await database.exportInto(fileExport);
    } else {
      content = 'Se ha producido un error';
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(content)),
    );
    return;
  }

  Future<void> dbImport() async {
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      'La nueva base de datos sobreescribirá los datos actuales, que se '
      'perderán y no podrán ser recuperados.\n\n'
      'Se recomienda exportar una copia de seguridad antes de importar.\n\n'
      'Después de completar el proceso, la aplicación se reiniciará para '
      'aplicar los cambios.\n\n'
      '¿Continuar con el proceso de importación?',
    );
    if (confirm == true) {
      final DbTransfer dbTransfer = DbTransfer();
      await dbTransfer.init();
      final File? fileImport = await dbTransfer.import();
      if (fileImport != null) {
        sharedPrefs.dbPath = fileImport.path;
        await database.close();
        //sharedPrefs.dbPath = await DbTransfer.getDbPath();
        if (!mounted) return;
        Iterum.revive(context);
        /*await database.close();
        sharedPrefs.dbPath = fileImport.path;
        if (!mounted) return;
        Iterum.revive(context);*/
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proceso de importación cancelado'),
          ),
        );
      }
    }
  }

  Future<void> dbDelete() async {
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      'Eliminará todo el historial pero el resto de productos '
      '(cuentas, depósitos y fondos) se conservarán.',
    );
    if (confirm == true) {
      await database.deleteHistoricos();
    }
    loadHistorico();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const Icon(Icons.business_center),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Balance Económico'),
        actions: [
          if (alertaDepositos > 0)
            Badge.count(
              count: alertaDepositos,
              isLabelVisible: true,
              child: const Icon(Icons.savings),
            ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntidadesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.account_balance),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TablaScreen(historico: historico),
                ),
              );
            },
            icon: const Icon(Icons.table_rows_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GraficoScreen(historico: historico),
                ),
              );
            },
            icon: const Icon(Icons.timeline),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            offset: Offset(0.0, AppBar().preferredSize.height),
            //shape: AppBox.roundBorder,
            itemBuilder: (ctx) => [
              MenuItem.buildMenuItem(Menu.exportar),
              MenuItem.buildMenuItem(Menu.importar, divider: true),
              MenuItem.buildMenuItem(Menu.eliminar),
              //MenuItem.buildMenuItem(Menu.info),
            ],
            onSelected: (item) async {
              if (item == Menu.exportar) {
                dbExport();
              } else if (item == Menu.importar) {
                dbImport();
              } else if (item == Menu.eliminar) {
                dbDelete();
              }
              /*else if (item == Menu.info) {
                showInfo();
              }*/
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              visualDensity: const VisualDensity(vertical: 4),
              leading: Tooltip(
                message: sharedPrefs.dbPath,
                //message: database.,
                child: const Icon(Icons.business_center, size: 40),
              ),
              title: const Text(
                'Cartera',
                style: TextStyle(fontSize: 22),
              ),
              trailing: Text(
                NumberUtil.currency(
                    totalCuentas + totalDepositos + totalFondos),
                style: const TextStyle(fontSize: 22),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CuentasScreen(),
                  ),
                );
              },
              //dense: true,
              visualDensity: const VisualDensity(vertical: 4),
              leading: const Icon(Icons.account_balance_wallet, size: 40),
              title: const Text(
                'Cuentas',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text('${cuentas.length}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberUtil.currency(totalCuentas),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      NumberUtil.porcentage(
                        (totalCuentas * 100) / total,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DepositosScreen(),
                  ),
                );
              },
              visualDensity: const VisualDensity(vertical: 4),
              leading: const Icon(Icons.savings, size: 40),
              title: const Text(
                'Depósitos',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text('${depositos.length}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberUtil.currency(totalDepositos),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      NumberUtil.porcentage(
                        (totalDepositos * 100) / total,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FondosScreen(),
                  ),
                );
              },
              visualDensity: const VisualDensity(vertical: 4),
              leading: const Icon(Icons.assessment, size: 40),
              title: const Text(
                'Fondos',
                style: TextStyle(fontSize: 20),
              ),
              subtitle: Text('${fondos.length}'),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    NumberUtil.currency(totalFondos),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      NumberUtil.porcentage(
                        (totalFondos * 100) / total,
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Theme.of(context).highlightColor,
              child: const Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        '#',
                        textAlign: TextAlign.center,
                      )),
                  Expanded(
                    flex: 3,
                    child: Text('Fecha', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Cuentas', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Depósitos', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Fondos', textAlign: TextAlign.center),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text('Total', textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            const Divider(),
            StreamBuilder<List<HistoricoData>>(
              stream: database.historicoStream,
              builder: (
                BuildContext context,
                AsyncSnapshot<List<HistoricoData>> snapshot,
              ) {
                return snapshot.hasData
                    ? HistoricoCartera(
                        historicos: snapshot.data!,
                        delete: deleteHistorico,
                      )
                    : const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: fechaController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.today),
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1970),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      var dateHms = FechaUtil.dateToDateHms(pickedDate);
                      fechaController.text =
                          FechaUtil.dateToString(date: dateHms);
                    });
                  }
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: cuentasController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_wallet),
                  labelText: 'Cuentas',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: depositosController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.savings),
                  labelText: 'Depósitos',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: fondosController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.assessment),
                  labelText: 'Fondos',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                addHistorico();
              },
              icon: const Icon(Icons.add_to_photos, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricoCartera extends StatelessWidget {
  final List<HistoricoData> historicos;
  final Function(int) delete;
  const HistoricoCartera({
    super.key,
    required this.historicos,
    required this.delete,
  });

  Text difProducto(HistoricoData historico, {TipoProducto? tipoProducto}) {
    bool condition = historicos.length > (historicos.indexOf(historico) + 1);
    if (!condition) {
      return const Text('');
    }
    double dif = 0;
    if (tipoProducto == TipoProducto.cuenta) {
      dif = historico.totalCuentas -
          historicos[historicos.indexOf(historico) + 1].totalCuentas;
    } else if (tipoProducto == TipoProducto.deposito) {
      dif = historico.totalDepositos -
          historicos[historicos.indexOf(historico) + 1].totalDepositos;
    } else if (tipoProducto == TipoProducto.fondo) {
      dif = historico.totalFondos -
          historicos[historicos.indexOf(historico) + 1].totalFondos;
    } else {
      try {
        double historicoTotal = historico.totalCuentas +
            historico.totalDepositos +
            historico.totalFondos;
        double historicoCuentasPrevio =
            historicos[historicos.indexOf(historico) + 1].totalCuentas;
        double historicoDepositosPrevio =
            historicos[historicos.indexOf(historico) + 1].totalDepositos;
        double historicoFondosPrevio =
            historicos[historicos.indexOf(historico) + 1].totalFondos;
        dif = historicoTotal -
            (historicoCuentasPrevio +
                historicoDepositosPrevio +
                historicoFondosPrevio);
      } catch (e) {
        dif = 0;
      }
    }
    return Text(
      NumberUtil.currency(dif),
      textAlign: TextAlign.right,
      style: TextStyle(color: dif < 0 ? Colors.red : Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (historicos.isEmpty) {
      return const Center(child: Text('Sin datos'));
    }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const Divider(),
      itemCount: historicos.length,
      itemBuilder: (context, index) {
        final historico = historicos[index];
        double historicoTotal = (historico.totalCuentas +
            historico.totalDepositos +
            historico.totalFondos);
        return Dismissible(
          key: ValueKey(historico.id),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: Theme.of(context).cardTheme.margin,
            alignment: AlignmentDirectional.centerEnd,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.5),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete),
            ),
          ),
          onDismissed: (direction) {
            delete(historico.id);
            //delete(historico);
          },
          child: SizedBox(
            height: 60, // 55
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  //child: Text('${index + 1}'),
                  child: CircleAvatar(
                    child: Text(
                      '${historicos.length - index}',
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 50,
                      child: DiaCalendario(
                          epoch: FechaUtil.dateToEpoch(historico.fecha)),
                    ),
                  ),
                  /*child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          FechaUtil.dateToString(
                              date: historico.fecha, formato: 'dd/MM'),
                          //textAlign: TextAlign.right,
                        ),
                        Text(
                          FechaUtil.dateToString(
                              date: historico.fecha, formato: 'yyyy'),
                          //textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),*/
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberUtil.currency(historico.totalCuentas),
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      difProducto(historico, tipoProducto: TipoProducto.cuenta),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberUtil.currency(historico.totalDepositos),
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      difProducto(
                        historico,
                        tipoProducto: TipoProducto.deposito,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberUtil.currency(historico.totalFondos),
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      difProducto(historico, tipoProducto: TipoProducto.fondo),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        NumberUtil.currency(historicoTotal),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      difProducto(historico),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
