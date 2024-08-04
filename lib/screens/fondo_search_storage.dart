import 'dart:convert';

import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../services/app_database.dart';
import '../services/yahoo_finance.dart';

class FondoSearchStorage extends StatefulWidget {
  const FondoSearchStorage({super.key});
  @override
  State<FondoSearchStorage> createState() => _FondoSearchStorageState();
}

class _FondoSearchStorageState extends State<FondoSearchStorage> {
  final List<Map<String, dynamic>> _allFondos = [];
  List<Map<String, dynamic>> _filterFondos = [];
  bool _isLoading = true;

  @override
  void initState() {
    readJson().whenComplete(() => _filterFondos = _allFondos);
    super.initState();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/fondos.json');
    final data = await json.decode(response);
    for (var item in data) {
      _allFondos.add(item);
    }
    setState(() => _isLoading = false);
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = enteredKeyword.isEmpty
        ? _allFondos
        : _allFondos
            .where((fondo) =>
                fondo['name']
                    ?.toUpperCase()
                    .contains(enteredKeyword.toUpperCase()) ||
                fondo['isin']
                    ?.toUpperCase()
                    .contains(enteredKeyword.toUpperCase()))
            .toList();
    setState(() => _filterFondos = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Fondo'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Busca por ISIN o por nombre',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filterFondos.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filterFondos.length,
                          itemBuilder: (context, index) => Card(
                            key: ValueKey(_filterFondos[index]['isin']),
                            color: Colors.amber,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(
                                _filterFondos[index]['name'],
                                style: const TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                _filterFondos[index]['isin'].toString(),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              onTap: () async {
                                String name = _filterFondos[index]['name'];
                                String isin = _filterFondos[index]['isin'];
                                FondoCompanion? getFondoByIsin =
                                    await YahooFinance().getFondoByIsin(isin);
                                FondoCompanion fondo;
                                if (getFondoByIsin != null) {
                                  fondo = FondoCompanion(
                                    name: dr.Value(getFondoByIsin.name.value),
                                    isin: dr.Value(isin),
                                  );
                                } else {
                                  fondo = FondoCompanion(
                                    isin: dr.Value(isin),
                                    name: dr.Value(name),
                                  );
                                }
                                if (!context.mounted) return;
                                Navigator.pop(context, fondo);
                              },
                            ),
                          ),
                        )
                      : const Text(
                          'No se ha encontrado coincidencia con ningún fondo.',
                          style: TextStyle(fontSize: 24),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
