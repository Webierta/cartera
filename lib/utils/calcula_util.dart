/*
import '../main.dart';
import '../services/app_database.dart';

class CalculaUtil {
  List<CuentaData> cuentas = [];
  List<DepositoData> depositos = [];
  List<FondoData> fondos = [];
  List<SaldosCuentaData> saldos = [];
  List<ValoresFondoData> valores = [];
  */
/*final EntidadData entidad;
  final List<CuentaData> cuentas;
  final List<DepositoData> depositos;
  final List<FondoData> fondos;

  CalculaUtil({
    required this.entidad,
    required this.cuentas,
    required this.depositos,
    required this.fondos,
  });*/ /*

  CalculaUtil() {
    loadProductos();
  }

  loadProductos() async {
    cuentas = await database.allCuentas;
    saldos = await database.allSaldos;
    depositos = await database.allDepositos;
    fondos = await database.allFondos;
    valores = await database.allValores;
  }

  bool productosEntidad(EntidadData entidad) {
    //loadProductos();
    final cuentasEntidad =
        cuentas.where((cuenta) => cuenta.entidad == entidad.name).toList();
    final depositosEntidad = depositos
        .where((deposito) => deposito.entidad == entidad.name)
        .toList();
    final fondosEntidad =
        fondos.where((fondo) => fondo.entidad == entidad.name).toList();

    if (cuentasEntidad.isNotEmpty ||
        depositosEntidad.isNotEmpty ||
        fondosEntidad.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<double> sumaTotal([EntidadData? entidad]) async {
    return (await sumaCuentas(entidad)) +
        (await sumaDepositos(entidad)) +
        (await sumaFondos(entidad));
  }

  Future<double> sumaCuentas([EntidadData? entidad]) async {
    if (entidad != null) {
      cuentas =
          cuentas.where((cuenta) => cuenta.entidad == entidad.name).toList();
    }
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
    */
/*List<SaldosCuentaData> lastValores = [];
    for (CuentaData cuenta in cuentas) {
      if (cuenta.valores.isEmpty) {
        continue;
      }
      if (cuenta.valores.length == 1) {
        lastValores.add(cuenta.valores.first);
        continue;
      }
      cuenta.valores.sort((a, b) => a.fecha.compareTo(b.fecha));
      lastValores.add(cuenta.valores.last);
    }
    if (lastValores.isEmpty) {
      return 0;
    }
    List<double> saldos = lastValores.map((e) => e.precio).toList();
    var sumaSaldos = saldos.reduce((value, element) => value + element);
    return sumaSaldos;*/ /*

  }

  double sumaDepositos([EntidadData? entidad]) {
    if (entidad != null) {
      depositos = depositos
          .where((deposito) => deposito.entidad == entidad.name)
          .toList();
    }
    if (depositos.isEmpty) {
      return 0;
    }
    double imposiciones = 0;
    for (DepositoData deposito in depositos) {
      imposiciones += deposito.imposicion;
    }
    return imposiciones;
  }

  */
/*static List<ValoresFondoData> getValores(FondoData fondo) {
    List<ValorFondoData> valoresFondo = [];
    for (var valor in valores) {
      if (valor.fondo.targetId == fondo.id) {
        valoresFondo.add(valor);
      }
    }
    return valoresFondo;
  }*/ /*


  Future<double> sumaFondos([EntidadData? entidad]) async {
    if (entidad != null) {
      fondos = fondos.where((fondo) => fondo.entidad == entidad.name).toList();
    }
    if (fondos.isEmpty) {
      return 0;
    }
    double capital = 0;
    for (var fondo in fondos) {
      final valoresFondo = await database.getValores(fondo.id);
      if (valoresFondo.isEmpty) {
        capital += fondo.participaciones * fondo.valorInicial;
      } else {
        capital += fondo.participaciones * valoresFondo.first.valor;
      }
    }
    return capital;
    */
/*for (FondoData fondo in fondos) {
      fondo.valores.addAll(getValores(fondo));
    }

    List<double> capitales = [];
    for (FondoData fondo in fondos) {
      if (fondo.valores.isEmpty) {
        continue;
      }
      if (fondo.valores.length == 1) {
        capitales.add(fondo.valores.first.precio * fondo.participaciones);
        continue;
      }
      fondo.valores.sort((a, b) => a.fecha.compareTo(b.fecha));
      capitales.add(fondo.valores.last.precio * fondo.participaciones);
    }
    if (capitales.isEmpty) {
      return 0;
    }
    var sumaCapitales = capitales.reduce((value, element) => value + element);
    return sumaCapitales;*/ /*

  }
}
*/
