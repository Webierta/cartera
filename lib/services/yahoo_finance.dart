/*
1. BUSCAR POR ISIN
   symbolYahoo = https://query1.finance.yahoo.com/v1/finance/search
    ?q=ES0152743003
    &quotesCount=1
    &newsCount=0
    &listsCount=0
    &typeDisp=Fund
    &quotesQueryId=tss_match_phrase_query

2. BUSCAR POR SYMBOL
   dataYahoo = https://query1.finance.yahoo.com/v7/finance/options/0P0000A9EK.F

3. BUSCAR POR NOMBRE
   listaFondos = YahooFinance().getFondoByName(termino)
   https://query1.finance.yahoo.com/v1/finance/search?q=naranja

   fondosSugeridos = YahooFinance().searchIsin(listaFondos)
   YahooFinance().getIsinByName(nombreFondo)
   https://markets.ft.com/data/search?query=Naranja+Renta+Fija+Corto+Plazo

   https://markets.ft.com/data/search?query=ING+Direc&country=SP&assetClass=Fund
*/

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' as dr;
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart';
import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

import '../utils/fecha_util.dart';
import 'app_database.dart';
import 'data_yahoo.dart';

class YahooFinance {
  Future<FondoCompanion?> getFondoByIsin(String isin) async {
    const Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109 Safari/537.36',
      'HttpHeaders.contentTypeHeader': 'application/json',
    };
    final Map<String, String> queryParameters = {
      'q': isin,
      'quotesCount': '1',
      'newsCount': '0',
      'listsCount': '0',
      'typeDisp': 'Fund',
      'quotesQueryId': 'tss_match_phrase_query',
    };
    final uri = Uri.https(
      'query1.finance.yahoo.com',
      '/v1/finance/search',
      queryParameters,
    );
    var client = Client();
    try {
      final response = await client
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        SymbolYahoo symbolYahoo = SymbolYahoo.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        var symbol = symbolYahoo.symbol;
        /*final uri2 = Uri.https(
          'query1.finance.yahoo.com',
          '/v7/finance/options/$symbol',
        );*/
        final Map<String, String> queryParameters = {
          'q': symbol,
          'quotesCount': '1',
          'newsCount': '0',
          'listsCount': '0',
          'typeDisp': 'Fund',
          'quotesQueryId': 'tss_match_phrase_query',
        };
        final uri2 = Uri.https(
          'query1.finance.yahoo.com',
          '/v1/finance/search',
          queryParameters,
        );
        // query1.finance.yahoo.com/v1/finance/search?q=AAPL
        final response2 = await client.get(uri2, headers: headers);
        if (response2.statusCode == 200) {
          String? name = jsonDecode(response2.body)['quotes'][0]['longname'];
          /*DataYahoo dataYahoo = DataYahoo.fromJson(
              jsonDecode(response2.body) as Map<String, dynamic>);*/
          if (name == null) {
            return null;
          }
          var newFondo = FondoCompanion(
            name: dr.Value(name),
            isin: dr.Value(isin),
          );
          return newFondo;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } on Error {
      return null;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  Future<String?> getTickerYahoo(String isin) async {
    const Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109 Safari/537.36',
      'HttpHeaders.contentTypeHeader': 'application/json',
    };
    final Map<String, String> queryParameters = {
      'q': isin,
      'quotesCount': '1',
      'newsCount': '0',
      'listsCount': '0',
      'quotesQueryId': 'tss_match_phrase_query',
    };
    final uri = Uri.https(
      'query1.finance.yahoo.com',
      '/v1/finance/search',
      queryParameters,
    );
    try {
      final response = await get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        SymbolYahoo symbolYahoo = SymbolYahoo.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        return symbolYahoo.symbol;
      } else {
        return null;
      }
    } on TimeoutException {
      return null;
    } on SocketException {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<ValoresFondoCompanion>?> getYahooFinanceResponse(
    FondoData fondo, [
    DateTime? to,
    DateTime? from,
  ]) async {
    String? newTicker;
    DateTime? date1;
    DateTime? date2;
    if (to != null && from != null) {
      date1 = FechaUtil.dateToDateHms(from);
      date2 = FechaUtil.dateToDateHms(to);
    }
    newTicker = await getTickerYahoo(fondo.isin!);
    YahooFinanceResponse response;
    try {
      response = await const YahooFinanceDailyReader(
        timeout: Duration(seconds: 10),
      ).getDailyDTOs(newTicker!, startDate: date1);
    } catch (e) {
      return null;
    }
    if (response.candlesData.isEmpty) {
      return null;
    }
    List<YahooFinanceCandleData> candlesData = response.candlesData;
    List<ValoresFondoCompanion> valores = [];
    if (to == null && from == null) {
      var candle = response.candlesData.last;
      var data = FechaUtil.dateToDateHms(candle.date);
      valores.add(
        ValoresFondoCompanion(
          fondo: dr.Value(fondo.id),
          fecha: dr.Value(data),
          valor: dr.Value(candle.close),
        ),
      );
      return valores;
    }

    List<YahooFinanceCandleData> candlesPeriodo = [];
    for (var candle in candlesData) {
      var data = FechaUtil.dateToDateHms(candle.date);
      if (data.compareTo(date2!) <= 0) {
        candlesPeriodo.add(candle);
      }
    }
    for (var candle in candlesPeriodo) {
      var data = FechaUtil.dateToDateHms(candle.date);
      valores.add(
        ValoresFondoCompanion(
          fondo: dr.Value(fondo.id),
          fecha: dr.Value(data),
          valor: dr.Value(candle.close),
        ),
      );
    }
    return valores;
  }

  Future<List<FondoCompanion>> getFondosByName(String termino) async {
    List<FondoCompanion> fondos = [];
    const Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109 Safari/537.36',
      'HttpHeaders.contentTypeHeader': 'application/json',
    };
    final Map<String, String> queryParameters = {
      'q': termino,
      'newsCount': '0',
      'listsCount': '0',
      'quotesQueryId': 'tss_match_phrase_query',
    };
    final uri = Uri.https(
      'query1.finance.yahoo.com',
      '/v1/finance/search',
      queryParameters,
    );

    try {
      final response = await get(uri, headers: headers);
      if (response.statusCode == 200) {
        SearchNameSymbol searchNameSymbol = SearchNameSymbol.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
        Map<String, String> mapSymbolName = searchNameSymbol.mapSymbolName;
        if (mapSymbolName.isEmpty) {
          return [];
        }
        var client = Client();
        for (var item in mapSymbolName.entries) {
          try {
            String getIsin = await getIsinByName(client, item.value);
            int indice = getIsin.indexOf(':');
            String isin = '';
            if (indice != -1) {
              isin = getIsin.substring(0, indice);
            }
            fondos.add(FondoCompanion(
              isin: dr.Value(isin),
              name: dr.Value(item.value),
            ));
          } catch (e) {
            return [];
          }
        }
        client.close();
        return fondos;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> getIsinByName(Client client, String nameFondo) async {
    const Map<String, String> headers = {
      'User-Agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109 Safari/537.36',
      //'HttpHeaders.contentTypeHeader': 'application/json',
    };

    final Map<String, String> queryParameters = {
      'query': nameFondo.replaceAll(' ', '+'),
      'country': '',
      'assetClass': 'Fund',
    };
    final uri = Uri.https(
      'markets.ft.com',
      '/data/search',
      queryParameters,
    );
    final response = await client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var document = parser.parse(response.body);
      var filas = document.getElementsByClassName('mod-ui-table__cell--text');
      if (filas.isNotEmpty) {
        return filas.last.innerHtml;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }
}
