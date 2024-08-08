import 'package:drift/drift.dart';

enum TipoProducto { cuenta, deposito, fondo }

enum Titular { jcv, rpp, ambos }

enum TipoOp { suscripcion, reembolso }

class Entidad extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get bic => text()();
  TextColumn get web => text()();
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get logo => text()();

//@override
//Set<Column> get primaryKey => {name};
}

class Cuenta extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get iban => text()();
  RealColumn get tae => real()();
  //DateTimeColumn get fecha => dateTime().nullable()();
  //RealColumn get saldo => real().nullable()();
  TextColumn get titular => textEnum<Titular>()();
  TextColumn get entidad => text().references(Entidad, #name)();
  //IntColumn get entidad => integer().nullable().references(Entidad, #id)();
  //IntColumn get saldo => integer().nullable().references(SaldosCuenta, #id)();
}

class SaldosCuenta extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cuenta => integer().nullable().references(Cuenta, #id)();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get saldo => real()();
}

class Deposito extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get codigo => text().nullable()();
  RealColumn get imposicion => real()();
  BoolColumn get renovacion => boolean()();
  DateTimeColumn get inicio => dateTime()();
  DateTimeColumn get vencimiento => dateTime()();
  RealColumn get tae => real()();
  TextColumn get titular => textEnum<Titular>()();
  TextColumn get entidad => text().references(Entidad, #name)();
//IntColumn get plazo => integer()(); vencimiento.difference(inicio).inDays ~/ 30;
//RealColumn get retribucion => real()(); plazo != null ? ((imposicion * tae) / 100) * (plazo! / 12) : 0;
}

class Fondo extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get isin => text().nullable()();
  RealColumn get participaciones => real()();
  //RealColumn get valorInicial => real()();
  //DateTimeColumn get fechaInicial => dateTime()();
  RealColumn get valorInicial => real()();
  DateTimeColumn get fechaInicial => dateTime()();
  TextColumn get titular => textEnum<Titular>()();
  TextColumn get entidad => text().references(Entidad, #name)();
// RealColumn get inversion => real()(); participaciones * valorInicial
// RealColumn get capital => real()();
/*valores!.isEmpty
  ? participaciones * valorInicial
      : participaciones * valores!.last.precio;*/
//RealColumn get rendimiento => real()();
//(capital != null && inversion != null) ? capital! - inversion! : 0;
//RealColumn get tae => real()(); rendimiento! / inversion!;
}

class ValoresFondo extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fondo => integer().nullable().references(Fondo, #id)();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get valor => real()();
  TextColumn get tipo => textEnum<TipoOp>().nullable()();
  RealColumn get participaciones => real().nullable()();
}

class Historico extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fecha => dateTime()();
  RealColumn get totalCuentas => real()();
  RealColumn get totalDepositos => real()();
  RealColumn get totalFondos => real()();
}
