import 'dart:io';

import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter_iterum/flutter_iterum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import '../services/app_database.dart';
import '../services/db_transfer.dart';
import '../services/tablas.dart';
import '../utils/fecha_util.dart';
import '../utils/local_storage.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/grafico_pastel.dart';
import '../widgets/menu.dart';
import 'cuentas_screen.dart';
import 'depositos_screen.dart';
import 'entidades_screen.dart';
import 'fondos_screen.dart';
import 'grafico_screen.dart';
import 'settings_screen.dart';
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
  bool loadTotales = false;
  int touchedIndex = -1;

  TextEditingController fechaController = TextEditingController();
  TextEditingController cuentasController = TextEditingController();
  TextEditingController depositosController = TextEditingController();
  TextEditingController fondosController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  List<HistoricoData> historico = [];
  int alertaDepositos = 0;
  int alarmasProximas = 0;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    initLocalStorage();
    loadProducts();
    getAlarmas();
    super.initState();
  }

  Future<void> getAlarmas() async {
    final allAlarmas = await database.allAlarmas;
    if (allAlarmas.isEmpty) {
      setState(() => alarmasProximas = 0);
      return;
    }
    int alarmas = 0;
    for (var alarma in allAlarmas) {
      if (alarma.fecha.difference(DateTime.now()).inDays < 31) {
        alarmas++;
      }
    }
    setState(() => alarmasProximas = alarmas);
    /* final alarmasMes = alarmasFecha.where(
      (a) => DateTime.now().difference(a.fecha) < Duration(days: 31),
    ); */
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
    if (!mounted) return;
    setState(() {
      total = totalCuentas + totalDepositos + totalFondos;
      loadTotales = true;
    });
    fechaController.text = FechaUtil.dateToString(date: DateTime.now());
    cuentasController.text = totalCuentas.toStringAsFixed(2);
    depositosController.text = totalDepositos.toString();
    fondosController.text = totalFondos.toStringAsFixed(2);
    totalController.text = total.toStringAsFixed(2);
    await loadHistorico();
  }

  Future<void> loadCuentas() async {
    final allCuentas = await database.allCuentas;
    if (!mounted) return;
    setState(() => cuentas = allCuentas);
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
      setState(() => totalCuentas = 0);
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
    setState(() => alertaDepositos = alertas);
  }

  Future<void> loadDepositos() async {
    final allDepositos = await database.allDepositos;
    if (!mounted) return;
    setState(() => depositos = allDepositos);
    checkAlertaDepositos();
    getImposicionTotal();
  }

  void getImposicionTotal() {
    double imposicion = 0;
    for (var deposito in depositos) {
      imposicion += deposito.imposicion;
    }
    setState(() => totalDepositos = imposicion);
  }

  Future<void> loadFondos() async {
    final allFondos = await database.allFondos;
    if (!mounted) return;
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
    totalController.dispose();
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
    //await dbTransfer.init();
    String directorio = path.dirname(sharedPrefs.dbPath);
    final File? fileExport = await dbTransfer.export(directorio);
    //await database.exportInto(fileExport);
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
      'aplicar los cambios (si no se reinicia, cierra y ejecuta de nuevo).\n\n'
      '¿Continuar con el proceso de importación?',
    );
    if (confirm == true) {
      final DbTransfer dbTransfer = DbTransfer();
      //await dbTransfer.init();
      String directorio = path.dirname(sharedPrefs.dbPath);
      final File? fileImport = await dbTransfer.import(directorio);
      if (fileImport != null) {
        await database.close();
        sharedPrefs.dbPath = fileImport.path;
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
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Balance Económico'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EntidadesScreen(),
                ),
              );
            },
            icon: Badge.count(
              count: alarmasProximas,
              isLabelVisible: alarmasProximas > 0,
              child: alarmasProximas > 0
                  ? Tooltip(
                      message: 'Próximos eventos',
                      child: Icon(Icons.account_balance),
                    )
                  : Icon(Icons.account_balance),
            ),
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
              MenuItem.buildMenuItem(Menu.ajustes, divider: true),
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
              } else if (item == Menu.ajustes) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      MouseRegion(
                        onHover: (e) => setState(() => touchedIndex = 0),
                        onExit: (e) => setState(() => touchedIndex = -1),
                        child: ProductoCartera(
                          isHover: touchedIndex == 0,
                          producto: TipoProducto.cuenta,
                          total: total,
                          totalProducto: totalCuentas,
                          lengthProducto: cuentas.length,
                        ),
                      ),
                      MouseRegion(
                        onHover: (e) => setState(() => touchedIndex = 1),
                        onExit: (e) => setState(() => touchedIndex = -1),
                        child: ProductoCartera(
                          isHover: touchedIndex == 1,
                          producto: TipoProducto.deposito,
                          total: total,
                          totalProducto: totalDepositos,
                          lengthProducto: depositos.length,
                          alertaDepositos: alertaDepositos,
                        ),
                      ),
                      MouseRegion(
                        onHover: (e) => setState(() => touchedIndex = 2),
                        onExit: (e) => setState(() => touchedIndex = -1),
                        child: ProductoCartera(
                          isHover: touchedIndex == 2,
                          producto: TipoProducto.fondo,
                          total: total,
                          totalProducto: totalFondos,
                          lengthProducto: fondos.length,
                        ),
                      ),
                    ],
                  ),
                ),
                if (loadTotales && total > 0)
                  Expanded(
                    flex: 1,
                    child: GraficoPastel(
                      key: UniqueKey(),
                      porcentajeCuentas: (totalCuentas * 100) / total,
                      porcentajeDepositos: (totalDepositos * 100) / total,
                      porcentajeFondos: (totalFondos * 100) / total,
                      touchedIndex: touchedIndex,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              //color: Theme.of(context).highlightColor,
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '#',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Fecha',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Cuentas',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Depósitos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Fondos',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Total',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
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
        color: Theme.of(context).colorScheme.inversePrimary,
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
                //canRequestFocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(TipoProducto.cuenta.icon),
                  labelText: TipoProducto.cuenta.nombrePlural,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: depositosController,
                //canRequestFocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(TipoProducto.deposito.icon),
                  labelText: TipoProducto.deposito.nombrePlural,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: fondosController,
                //canRequestFocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(TipoProducto.fondo.icon),
                  labelText: TipoProducto.fondo.nombrePlural,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: totalController,
                //canRequestFocus: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.business_center),
                  labelText: 'Total',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              onPressed: () => addHistorico(),
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
      NumberUtil.signo(dif) + NumberUtil.currency(dif),
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
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
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
                  child: CircleAvatar(
                    child: Text('${historicos.length - index}'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    /*child: DiaCalendario(
                      epoch: FechaUtil.dateToEpoch(historico.fecha),
                    ),*/
                    child: Text(
                      FechaUtil.dateToString(
                          date: historico.fecha, formato: 'MMM yy'),
                      textAlign: TextAlign.center,
                    ),
                  ),
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

class ProductoCartera extends StatefulWidget {
  final bool isHover;
  final TipoProducto producto;
  final double total;
  final double totalProducto;
  final int lengthProducto;
  final int alertaDepositos;
  const ProductoCartera({
    super.key,
    required this.isHover,
    required this.producto,
    required this.total,
    required this.totalProducto,
    required this.lengthProducto,
    this.alertaDepositos = 0,
  });

  @override
  State<ProductoCartera> createState() => _ProductoCarteraState();
}

class _ProductoCarteraState extends State<ProductoCartera> {
  late Widget destino;

  @override
  void initState() {
    destino = switch (widget.producto) {
      TipoProducto.cuenta => const CuentasScreen(),
      TipoProducto.deposito => const DepositosScreen(),
      TipoProducto.fondo => const FondosScreen(),
    };
    super.initState();
  }

  Widget getIcono() {
    Color? color = IconThemeData().color;
    color = switch (widget.producto) {
      TipoProducto.cuenta =>
        widget.isHover ? Colors.blue : IconThemeData().color,
      TipoProducto.deposito =>
        widget.isHover ? Colors.green : IconThemeData().color,
      TipoProducto.fondo => widget.isHover ? Colors.red : IconThemeData().color,
    };
    if (widget.producto == TipoProducto.deposito &&
        widget.alertaDepositos > 0) {
      return Badge.count(
        count: widget.alertaDepositos,
        isLabelVisible: true,
        child: Tooltip(
          message: 'Depósitos con próximo vencimiento',
          child: Icon(widget.producto.icon, size: 40, color: color),
        ),
      );
    }
    return Icon(widget.producto.icon, size: 40, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destino),
        );
      },
      //dense: true,
      visualDensity: const VisualDensity(vertical: 4),
      leading: getIcono(),
      title: Row(
        children: [
          Text(
            widget.producto.nombrePlural,
            style: TextStyle(
              fontSize: 20,
              fontWeight: widget.isHover ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(100),
            child: Text(
              '${widget.lengthProducto}',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            NumberUtil.currency(widget.totalProducto),
            style: TextStyle(
              fontSize: 20,
              fontWeight: widget.isHover ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Theme.of(context).colorScheme.primary,
            child: Text(
              NumberUtil.porcentage(
                  (widget.totalProducto * 100) / widget.total),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
