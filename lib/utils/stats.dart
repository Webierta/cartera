import 'dart:math' show sqrt, pow;

import 'package:uuid/uuid.dart';

import '../services/tablas.dart';

import '../services/app_database.dart';
import 'fecha_util.dart';
import 'xirr_calculator.dart';

class Stats {
  final List<ValoresFondoData> valores;
  const Stats(this.valores);

  double difValores(ValoresFondoData valor, FondoData fondo,
      [bool total = false]) {
    bool isFirstValor = valores.length > (valores.indexOf(valor) + 1);
    if (isFirstValor && total != true) {
      return valor.valor - valores[valores.indexOf(valor) + 1].valor;
    }
    return valor.valor - fondo.valorInicial;
  }

  double difPer(ValoresFondoData valor, FondoData fondo) {
    double dif = difValores(valor, fondo);
    bool isFirstValor = valores.length > (valores.indexOf(valor) + 1);
    if (isFirstValor) {
      return dif / valores[valores.indexOf(valor) + 1].valor;
    }
    return dif / fondo.valorInicial;
  }

  double? precioMinimo() {
    if (valores.isNotEmpty) {
      final List<double> precios = valores.map((v) => v.valor).toList();
      return precios.reduce((curr, next) => curr < next ? curr : next);
    }
    return null;
  }

  double? precioMaximo() {
    if (valores.isNotEmpty) {
      final List<double> precios = valores.map((v) => v.valor).toList();
      return precios.reduce((curr, next) => curr > next ? curr : next);
    }
    return null;
  }

  int? datePrecioMinimo() {
    if (valores.isNotEmpty) {
      for (var valor in valores) {
        if (valor.valor == precioMinimo()) {
          return FechaUtil.dateToEpoch(valor.fecha);
        }
      }
      return null;
    }
    return null;
  }

  int? datePrecioMaximo() {
    if (valores.isNotEmpty) {
      for (var valor in valores) {
        if (valor.valor == precioMaximo()) {
          return FechaUtil.dateToEpoch(valor.fecha);
        }
      }
      return null;
    }
    return null;
  }

  double? precioMedio() {
    if (valores.isNotEmpty) {
      final List<double> precios = valores.map((v) => v.valor).toList();
      return precios.reduce((a, b) => a + b) / precios.length;
    }
    return null;
  }

  double? volatilidad() {
    if (valores.isNotEmpty) {
      final List<double> precios = valores.map((v) => v.valor).toList();
      var precioMedio = precios.reduce((a, b) => a + b) / precios.length;
      var diferencialesCuadrados = 0.0;
      for (var valor in valores) {
        diferencialesCuadrados +=
            (valor.valor - precioMedio) * (valor.valor - precioMedio);
      }
      var varianza = diferencialesCuadrados / valores.length;
      return sqrt(varianza);
    }
    return null;
  }

  double? totalParticipaciones() {
    double? participaciones;
    if (valores.isNotEmpty) {
      double part = 0.0;
      for (var valor in valores) {
        if (valor.tipo == TipoOp.suscripcion) {
          part += valor.participaciones ?? 0.0;
        } else if (valor.tipo == TipoOp.reembolso) {
          part -= valor.participaciones ?? 0.0;
        }
      }
      participaciones = part;
    }
    return participaciones;
  }

  List<double> operacionesCapital({required bool isAport}) {
    List<double> operacionesCapital = [];
    //int tipoOp = isAport ? 1 : 0;
    TipoOp tipoOp = isAport ? TipoOp.suscripcion : TipoOp.reembolso;
    if (valores.isNotEmpty && totalParticipaciones() != null) {
      for (var valor in valores) {
        if (valor.tipo == tipoOp) {
          operacionesCapital.add((valor.participaciones ?? 0.0) * valor.valor);
        }
      }
    }
    return operacionesCapital;
  }

  double? suscripcion() {
    double? suscripcion;
    var opAportaciones = operacionesCapital(isAport: true);
    if (opAportaciones.isNotEmpty) {
      suscripcion = opAportaciones.last;
    }
    return suscripcion;
  }

  /*double? _aportaciones() {
    double? aportaciones;
    var opAportaciones = operacionesCapital(isAport: true);
    if (opAportaciones.isNotEmpty && opAportaciones.length > 1) {
      opAportaciones.removeLast();
      aportaciones = opAportaciones.reduce((value, element) => value + element);
    }
    return aportaciones;
  }

  double? _reembolsos() {
    double? reembolsos;
    var opReembolsos = operacionesCapital(isAport: false);
    if (opReembolsos.isNotEmpty) {
      reembolsos = opReembolsos.reduce((value, element) => value + element);
    }
    return reembolsos;
  }*/

  double? inversion() {
    double? inversion;
    if (valores.isNotEmpty && totalParticipaciones() != null) {
      double inv = 0.0;
      for (var valor in valores) {
        if (valor.tipo == TipoOp.suscripcion) {
          inv += (valor.participaciones ?? 0.0) * valor.valor;
        } else if (valor.tipo == TipoOp.reembolso) {
          inv -= (valor.participaciones ?? 0.0) * valor.valor;
        }
      }
      inversion = inv;
    }
    return inversion;
  }

  double? resultado() {
    double? resultado;
    if (valores.isNotEmpty && totalParticipaciones() != null) {
      //sortValores(fondo);
      resultado = totalParticipaciones()! * valores.first.valor;
    }
    return resultado;
  }

  double? balance() {
    double? balance;
    if (resultado() != null && inversion() != null) {
      balance = resultado()! - inversion()!;
    }
    return balance;
  }

  double? rentabilidad() {
    double? rentabilidad;
    if (balance() != null && inversion() != null && inversion()! > 0) {
      rentabilidad = balance()! / inversion()!;
    }
    return rentabilidad;
  }

  /*double? tae() {
    double? tae;
    var rent = rentabilidad();
    if (rent != null) {
      tae = anualizar(rent);
    }
    return tae;
  }*/

  /*double? tae() {
    double? tae;
    if (resultado() != null && inversion() != null && inversion()! > 0) {
      //sortValores(fondo);
      int? dateFirstOp;
      for (var valor in valores.reversed) {
        if (valor.tipo != null) {
          dateFirstOp = valor.date;
          break;
        }
      }
      if (dateFirstOp != null) {
        var dias = (FechaUtil.epochToDate(valores.first.date)
            .difference(FechaUtil.epochToDate(dateFirstOp))
            .inDays);
        //tae = pow((resultado()! / inversion()!), (365 / dias)) - 1;
        //tae = (pow((resultado()! / inversion()!), (1 / (dias / 365)))) - 1;
        tae = (pow((1 + rentabilidad()!), (1 / (dias / 365)))) - 1;
      }
    }
    return tae;
  }*/

  /// TAE RENTABILIDAD = (1 + RENT) ^ ( 1 / (DIAS / 365) ) - 1
  /// TAE RENTABILIDAD = (1 + RENT) ^ ( 365 / DIAS ) - 1
  double? anualizar(double rentabilidad) {
    double? anualizada;
    if (resultado() != null && inversion() != null && inversion()! > 0) {
      //sortValores(fondo);
      int? dateFirstOp;
      for (var valor in valores.reversed) {
        if (valor.tipo != null) {
          dateFirstOp = FechaUtil.dateToEpoch(valor.fecha);
          break;
        }
      }
      if (dateFirstOp != null) {
        var dias = valores.first.fecha
            .difference(FechaUtil.epochToDate(dateFirstOp))
            .inDays;
        //tae = pow((resultado()! / inversion()!), (365 / dias)) - 1;
        //tae = (pow((resultado()! / inversion()!), (1 / (dias / 365)))) - 1;
        anualizada = (pow((1 + rentabilidad), (1 / (dias / 365)))) - 1;
      }
    }
    return anualizada;
  }

  /*double? twr() {
    double? twr;
    if (resultado() != null && suscripcion() != null) {
      // TWR = (Valor Final – Valor Inicial + Reembolsos – Aportaciones) / Valor Inicial
      //TWR = (CAPITALF - CAPITALI + REEMB - APORT) / CAPITALI
      double aportaciones = _aportaciones() ?? 0.0;
      double reembolsos = _reembolsos() ?? 0.0;
      print('SUSCRIPCION:  ${suscripcion()}');
      print('APORTACIONES: $aportaciones');
      print('REEMBOLSOS: $reembolsos');
      twr = (resultado()! - suscripcion()! + reembolsos - aportaciones) /
          suscripcion()!;
    }
    return twr;
  }*/

  /// TWR: para cada operación:
  ///   1. calcular rpn
  ///       Valor Final = Valor Actual + Valor Operación
  ///       rpn = (Valor Final - Valor Inicial - Valor Operación) / Valor Inicial
  ///   2. calcular TWR
  ///       twr = (1 + rpn) * (1 * rpn) * ... - 1
  double? twr() {
    double? twr;
    List<double> rpnList = [];
    List<ValoresFondoData> allValoresSort = List.from(valores.reversed);
    //List<ValoresFondoData> allValoresSort = List.from(valores);
    List<ValoresFondoData> allOpSort =
        allValoresSort.where((v) => v.tipo != null).toList();
    /*if (allValoresSort.first.tipo != TipoOp.suscripcion &&
        allValoresSort.first.tipo != TipoOp.reembolso) {*/
    if (allValoresSort.last.tipo == null) {
      allOpSort.add(allValoresSort.last);
    }

    if (allOpSort.isNotEmpty) {
      for (int i = 0; i < allOpSort.length; i++) {
        var op = allOpSort[i];
        if (i == 0) {
          var rpn = 0.0;
          rpnList.add(rpn + 1);
        } else {
          double valorFinal = (allOpSort[i - 1].participaciones! * op.valor) +
              (op.participaciones ?? 0 * op.valor);
          double valorInicial =
              (allOpSort[i - 1].participaciones! * allOpSort[i - 1].valor);
          double valorOp = op.participaciones ?? 0 * op.valor;
          var rpn = (valorFinal - valorInicial - valorOp) / valorInicial;
          rpnList.add(rpn + 1);
        }
      }
      var rpnProducto = 1.0;
      for (var rpn in rpnList) {
        rpnProducto *= rpn;
      }
      twr = rpnProducto - 1;
    }
    return twr;
  }

  List<CashFlow> _getCashFlows() {
    List<ValoresFondoData> copyValores = List.generate(
        valores.length,
        (i) => ValoresFondoData(
            /*fecha: valores[i].date,
              valor: valores[i].precio,
              tipo: valores[i].tipo,
              participaciones: valores[i].participaciones,*/
            id: const Uuid().v1().hashCode,
            fecha: valores[i].fecha,
            valor: valores[i].valor,
            tipo: valores[i].tipo,
            participaciones: valores[i].participaciones));
    var statsAllValores = Stats(copyValores);
    List<ValoresFondoData> allOpSort = copyValores.reversed
        .where(
            (v) => v.tipo == TipoOp.suscripcion || v.tipo == TipoOp.reembolso)
        .toList();
    var lastValor = copyValores.reversed.last;
    if (lastValor.tipo == TipoOp.suscripcion ||
        lastValor.tipo == TipoOp.reembolso) {
      allOpSort.clear();
    } else {
      allOpSort.add(ValoresFondoData(
        id: lastValor.id,
        fecha: lastValor.fecha,
        valor: lastValor.valor,
        participaciones: statsAllValores.totalParticipaciones(),
        tipo: TipoOp.reembolso,
      ));
    }

    /*if (allValores.isNotEmpty) {
      var part = 0.0;
      for (int i = allValores.length - 1; i > -1; i--) {
        var valor = allValores[i];
        if (valor.tipo == 1 || valor.tipo == 0) {
          part += valor.participaciones!;
          opCashFlows.add(valor);
        }
        if (i == 0) {
          if (valor.tipo != 1 && valor.tipo != 0) {
            Valor lastValor = Valor(
              date: valor.date,
              precio: valor.precio,
              //participaciones: allValores[1].participaciones,
              participaciones: part,
              //tipo: 0,
            );
            opCashFlows.add(lastValor);
          }
        }
      }
    }*/
    //opCashFlows.last.tipo = 0;
    List<CashFlow> cashFlows = [];
    if (allOpSort.isNotEmpty) {
      for (var op in allOpSort) {
        var fecha = op.fecha;
        var date = DateTime(fecha.year, fecha.month, fecha.day);
        int signo = op.tipo == TipoOp.suscripcion ? -1 : 1;
        var importe = op.valor * op.participaciones! * signo;
        cashFlows.add(CashFlow(importe: importe, date: date));
      }
    }
    return cashFlows;
  }

  double? mwr() {
    double? mwr;
    List<CashFlow> cashFlows = _getCashFlows();
    if (cashFlows.isNotEmpty && cashFlows.length > 1) {
      try {
        mwr = CalculationWrapper.xirr(cashFlows);
      } catch (e) {
        mwr = null;
      }
    }
    return mwr;
  }

  // MWRA = ((1 + MWR) ^ (días / 365)) - 1
  double? mwrAcum(double mwr) {
    double? mwrAcum;
    List<CashFlow> cashFlows = _getCashFlows();
    double dias;
    if (cashFlows.isNotEmpty && cashFlows.length > 1) {
      dias = cashFlows.last.date.difference(cashFlows.first.date).inDays / 365;
      mwrAcum = pow((1 + mwr), dias) - 1;
    }
    return mwrAcum;
  }
}
