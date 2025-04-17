/*
https://drift.simonbinder.eu/
https://medium.com/@tagizada.nicat/migration-with-flutter-drift-c9e21e905eeb
https://r1n1os.medium.com/drift-local-database-for-flutter-part-1-intro-setup-and-migration-09a64d44f6df

dart run build_runner build

UPDATE DATABASE VERSION
dart run drift_dev schema dump lib/services/app_database.dart db_schemas
  update table y upgrade version
flutter packages pub run build_runner build — delete-conflicting-outputs
dart run drift_dev schema dump lib/services/app_database.dart db_schemas
dart run drift_dev schema steps db_schemas lib/db_migration.dart
*/

// Secure SQLite Database in Flutter using sqflite_sqlcipher
// https://medium.com/@sumaiah.mitu/secure-sqlite-database-in-flutter-using-sqflite-sqlcipher-ffccbb008743

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:riverpod/riverpod.dart';

import '../utils/entidades.dart';
import '../utils/local_storage.dart';
import 'tablas.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Cuenta,
  SaldosCuenta,
  Deposito,
  Fondo,
  ValoresFondo,
  Entidad,
  Historico,
  Alarma,
  IRPF
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        //from1To2: (Migrator m, Schema2 schema) async {},
        if (from < 2) {
          await m.create(alarma);
        }
        if (from < 3) {
          await m.create(irpf);
        }
        if (from < 4) {
          await m.addColumn(irpf, irpf.titular);
        }
      },
    );
  }

  // IRPF
  Future<List<IRPFData>> get allIRPF => select(irpf).get();

  Future<List<IRPFData>> titularEjercicioIRPF(Titular titular, int? ejercicio) {
    if (titular == Titular.ambos && ejercicio == null) {
      return (select(irpf)
            ..orderBy([
              (s) => OrderingTerm(
                  expression: s.ejercicio, mode: OrderingMode.desc),
              (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
            ]))
          .get();
    } else if (titular == Titular.ambos && ejercicio != null) {
      return (select(irpf)
            ..where((s) => s.ejercicio.equals(ejercicio))
            ..orderBy([
              (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
            ]))
          .get();
    } else if (titular != Titular.ambos && ejercicio == null) {
      return (select(irpf)
            ..where((s) => s.titular.equals(titular.name))
            ..orderBy([
              (s) => OrderingTerm(
                  expression: s.ejercicio, mode: OrderingMode.desc),
              (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
            ]))
          .get();
    } else if (titular != Titular.ambos && ejercicio != null) {
      return (select(irpf)
            ..where((s) => s.ejercicio.equals(ejercicio))
            ..where((s) => s.titular.equals(titular.name))
            ..orderBy([
              (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
            ]))
          .get();
    }
    return (select(irpf)
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.ejercicio, mode: OrderingMode.desc),
            (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<IRPFData>> titularIRPF(Titular titular) {
    if (titular == Titular.ambos) {
      //return allIRPF;
      return (select(irpf)
            ..orderBy([
              (s) => OrderingTerm(
                  expression: s.ejercicio, mode: OrderingMode.desc),
              (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
            ]))
          .get();
    }

    return (select(irpf)
          ..where((s) => s.titular.equals(titular.name))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.ejercicio, mode: OrderingMode.desc),
            (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<IRPFData>> ejercicioIRPF(int ejercicio) {
    return (select(irpf)
          ..where((s) => s.ejercicio.equals(ejercicio))
          ..orderBy([
            (s) => OrderingTerm(expression: s.entidad, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<List<IRPFData>> entidadIRPF(String entidadName) {
    return (select(irpf)
          ..where((s) => s.entidad.equals(entidadName))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.ejercicio, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<IRPFData>> ejercicioEntidadIRPF(
      int ejercicio, String entidadName) {
    return (select(irpf)
          ..where((s) => s.ejercicio.equals(ejercicio))
          ..where((s) => s.entidad.equals(entidadName))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.ejercicio, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<List<IRPFData>> ejercicioEntidadTitularIRPF(
      int ejercicio, String entidadName, Titular titular) {
    return (select(irpf)
          ..where((s) => s.ejercicio.equals(ejercicio))
          ..where((s) => s.entidad.equals(entidadName))
          ..where((s) => s.titular.equals(titular.name))
          ..orderBy([
            (s) =>
                OrderingTerm(expression: s.ejercicio, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<int> addIRPF(IRPFCompanion newIRPF) {
    return into(irpf).insert(newIRPF);
  }

  Future<int> updateIRPF(int id, IRPFCompanion companion) {
    return (update(irpf)..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteIRPF(int id) {
    return (delete(irpf)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteAllIRPF() async {
    return await delete(irpf).go();
  }

  // ALARMA
  Future<List<AlarmaData>> get allAlarmas => select(alarma).get();

  Future<List<AlarmaData>> get alarmasFecha {
    return (select(alarma)
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.asc)
          ]))
        .get();
  }

  Future<int> addAlarma(AlarmaCompanion newAlarma) {
    return into(alarma).insert(newAlarma);
  }

  Future<int> updateAlarma(int id, AlarmaCompanion companion) {
    return (update(alarma)..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteAlarma(int id) {
    return (delete(alarma)..where((tbl) => tbl.id.equals(id))).go();
  }

  /* Stream<List<AlarmaData>> getAlarmasEntidad(String entidadName) {
    return (select(alarma)
          ..where((s) => s.entidad.equals(entidadName))
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.desc)
          ]))
        .watch();
  } */

  Future<List<AlarmaData>> alarmasEntidad(String entidadName) {
    return (select(alarma)
          ..where((s) => s.entidad.equals(entidadName))
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  // ENTIDADES
  Future<List<EntidadData>> get allEntidades => select(entidad).get();

  Future<int> addEntidad(EntidadCompanion newEntidad) {
    return into(entidad).insert(newEntidad);
  }

  Future<void> addEntidades() async {
    await batch((batch) {
      batch.insertAll(entidad, entidadesList);
    });
  }

  Future<int> updateEntidad(int id, EntidadCompanion companion) {
    return (update(entidad)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<int> deleteEntidad(int id) {
    return (delete(entidad)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteEntidades() async {
    return await delete(entidad).go();
  }

  // CUENTAS
  Future<List<CuentaData>> get allCuentas => select(cuenta).get();

  Future<int> addCuenta(CuentaCompanion newCuenta) {
    return into(cuenta).insert(newCuenta);
  }

  Future<int> updateCuenta(int id, CuentaCompanion companion) {
    return (update(cuenta)..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteCuenta(int id) {
    return (delete(cuenta)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteCuentas() async {
    return await delete(cuenta).go();
  }

  // SALDOS CUENTA
  Future<List<SaldosCuentaData>> get allSaldos => select(saldosCuenta).get();

  Stream<List<SaldosCuentaData>> getSaldosCuenta(int cuentaid) {
    return (select(saldosCuenta)
          ..where((s) => s.cuenta.equals(cuentaid))
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<List<SaldosCuentaData>> getSaldos(int cuentaId) {
    return (select(saldosCuenta)
          ..where((s) => s.cuenta.equals(cuentaId))
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<SaldosCuentaData> getLastSaldo(int cuentaId) {
    return (select(saldosCuenta)
          ..where((s) => s.cuenta.equals(cuentaId))
          ..orderBy([
            (s) => OrderingTerm(expression: s.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingle();
  }

  Future<List<SaldosCuentaData>> getSaldosByFecha(
      int cuentaId, DateTime fecha) {
    return (select(saldosCuenta)
          ..where((s) => s.cuenta.equals(cuentaId) & s.fecha.equals(fecha)))
        .get();
  }

  Future<int> addSaldoCuenta(SaldosCuentaCompanion newSaldo) {
    return into(saldosCuenta).insert(newSaldo);
  }

  Future<int> updateSaldo(int id, SaldosCuentaCompanion companion) {
    return (update(saldosCuenta)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<int> deleteSaldo(int id) {
    return (delete(saldosCuenta)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteSaldosCuenta(int cuentaId) {
    return (delete(saldosCuenta)..where((s) => s.cuenta.equals(cuentaId))).go();
  }

  Future<int> deleteSaldos() async {
    return await delete(saldosCuenta).go();
  }

  // DEPOSITOS
  Future<List<DepositoData>> get allDepositos => select(deposito).get();

  Future<int> addDeposito(DepositoCompanion newDeposito) {
    return into(deposito).insert(newDeposito);
  }

  Future<int> updateDeposito(int id, DepositoCompanion companion) {
    return (update(deposito)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<int> deleteDeposito(int id) {
    return (delete(deposito)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteDepositos() async {
    return await delete(deposito).go();
  }

  // FONDOS
  Future<List<FondoData>> get allFondos => select(fondo).get();

  Future<int> addFondo(FondoCompanion newFondo) {
    return into(fondo).insert(newFondo);
  }

  Future<int> updateFondo(int id, FondoCompanion companion) {
    return (update(fondo)..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  Future<int> deleteFondo(int id) {
    return (delete(fondo)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteFondos() async {
    return await delete(fondo).go();
  }

  // VALORES FONDO
  Future<List<ValoresFondoData>> get allValores => select(valoresFondo).get();

  Stream<List<ValoresFondoData>> getValoresFondo(int fondoId) {
    return (select(valoresFondo)
          ..where((v) => v.fondo.equals(fondoId))
          ..orderBy([
            (v) => OrderingTerm(expression: v.fecha, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<List<ValoresFondoData>> getValores(int fondoId) {
    return (select(valoresFondo)
          ..where((v) => v.fondo.equals(fondoId))
          ..orderBy([
            (v) => OrderingTerm(expression: v.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Future<ValoresFondoData> getLastValor(int fondoId) {
    return (select(valoresFondo)
          ..where((v) => v.fondo.equals(fondoId))
          ..orderBy([
            (v) => OrderingTerm(expression: v.fecha, mode: OrderingMode.desc)
          ])
          ..limit(1))
        .getSingle();
  }

  Future<List<ValoresFondoData>> getValoresByFecha(
      int fondoId, DateTime fecha) {
    return (select(valoresFondo)
          ..where((v) => v.fondo.equals(fondoId) & v.fecha.equals(fecha)))
        .get();
  }

  Future<int> addValorFondo(ValoresFondoCompanion newValor, int fondoId) async {
    var valoresByFecha = await getValoresByFecha(fondoId, newValor.fecha.value);
    if (valoresByFecha.isEmpty) {
      return into(valoresFondo).insert(newValor);
    } else {
      return (update(valoresFondo)
            ..where((tbl) => tbl.id.equals(valoresByFecha.first.id)))
          .write(newValor);
    }

    //return into(valoresFondo).insert(newValor);
  }

  Future<void> addValores(
      List<ValoresFondoCompanion> valores, int fondoId) async {
    //await batch((batch) {
    //batch.insertAllOnConflictUpdate(valoresFondo, valores);
    //batch.insertAll(valoresFondo, valores);
    //});
    for (final valor in valores) {
      var valoresByFecha = await getValoresByFecha(fondoId, valor.fecha.value);
      //insert<T, D>(table, row, onConflict: DoUpdate((_) => row));
      if (valoresByFecha.isEmpty) {
        await addValorFondo(valor, fondoId);
      } else {
        await updateValor(valoresByFecha.first.id, valor);
      }
    }
  }

  Future<int> updateValor(int id, ValoresFondoCompanion companion) {
    return (update(valoresFondo)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<int> deleteValor(int id) {
    return (delete(valoresFondo)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteValoresFondo(int fondoId) {
    return (delete(valoresFondo)..where((v) => v.fondo.equals(fondoId))).go();
  }

  Future<int> deleteValores() async {
    return await delete(valoresFondo).go();
  }

  // HISTORICO
  Future<List<HistoricoData>> get allHistorico {
    return (select(historico)
          ..orderBy([
            (h) => OrderingTerm(expression: h.fecha, mode: OrderingMode.desc)
          ]))
        .get();
  }

  Stream<List<HistoricoData>> get historicoStream {
    return (select(historico)
          ..orderBy([
            (h) => OrderingTerm(expression: h.fecha, mode: OrderingMode.desc)
          ]))
        .watch();
  }

  Future<int> addHistorico(HistoricoCompanion newHistorico) {
    return into(historico).insert(newHistorico);
  }

  Future<void> addHistoricos(List<HistoricoCompanion> historicos) async {
    await batch((batch) {
      batch.insertAll(historico, historicos);
    });
  }

  Future<int> updateHistorico(int id, HistoricoCompanion companion) {
    return (update(historico)..where((tbl) => tbl.id.equals(id)))
        .write(companion);
  }

  Future<int> deleteHistorico(int id) {
    return (delete(historico)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteHistoricos() async {
    return await delete(historico).go();
  }

  /*static QueryExecutor _openConnection() {
    // `driftDatabase` from `package:drift_flutter` stores the database in
    // `getApplicationDocumentsDirectory()`.
    String dbPath = 'carteraDB/cartera_db';
    //String dbPath = 'carteraDB/backup/cartera_db030824';
    //dbPath = ref.watch(databasePathProvider);
    return driftDatabase(name: dbPath);
  }*/

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      //final dbFolder = await getApplicationDocumentsDirectory();
      //final file = File(p.join(dbFolder.path, 'db.sqlite'));

      /*Directory dir = await getApplicationDocumentsDirectory();
      Directory dirApp =
      await Directory('${dir.path}/carteraDB').create(recursive: true);
      String fileName = 'cartera_db.sqlite';
      final file = File(join(dirApp.path, fileName));*/

      // ORIGINAL
      /* String dbPathDb = await DbTransfer.getDbPath();
      var file = File(dbPathDb);

      final LocalStorage sharedPrefs = LocalStorage();
      await sharedPrefs.init();
      String dbPathImport = sharedPrefs.dbPath;

      if (dbPathDb != dbPathImport) {
        final blob = await rootBundle.load(dbPathImport);
        final buffer = blob.buffer;
        await file.writeAsBytes(
            buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes));
        sharedPrefs.dbPath = await DbTransfer.getDbPath();
      } */

      final LocalStorage sharedPrefs = LocalStorage();
      await sharedPrefs.init();
      String dbPath = sharedPrefs.dbPath;
      final file = File(dbPath);

      return NativeDatabase.createInBackground(file);
    });
  }

  Future<void> exportInto(File file) async {
    // Make sure the directory of the target file exists
    await file.parent.create(recursive: true);
    // Override an existing backup, sqlite expects the target file to be empty
    if (file.existsSync()) {
      file.deleteSync();
    }
    await customStatement('VACUUM INTO ?', [file.path]);
  }

  static final StateProvider<AppDatabase> provider = StateProvider((ref) {
    final database = AppDatabase();
    ref.onDispose(database.close);
    return database;
  });
}
