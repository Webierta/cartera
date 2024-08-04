import 'package:drift/drift.dart' as dr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/app_database.dart';
import '../services/yahoo_finance.dart';

enum Options { isin, nombre }

class FondoSearchScreen extends StatefulWidget {
  const FondoSearchScreen({super.key});
  @override
  State<FondoSearchScreen> createState() => _FondoSearchScreenState();
}

class _FondoSearchScreenState extends State<FondoSearchScreen> {
  late TextEditingController _controller;
  bool? _validIsin;
  FondoCompanion? locatedFond;
  bool _buscando = false;
  bool? _errorDataApi;
  TextEditingController controllerName = TextEditingController();
  List<String> nombreFondos = [];
  List<FondoCompanion> fondosSugeridos = [];
  Options selectedOption = Options.isin;
  bool searchingNames = false;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    controllerName.dispose();
    _validIsin = null;
    _errorDataApi = null;
    super.dispose();
  }

  Icon _resultIsValid() {
    if (_validIsin == true) {
      return const Icon(Icons.check_box, color: Colors.green);
    } else if (_validIsin == false) {
      return const Icon(Icons.disabled_by_default, color: Colors.red);
    } else {
      return const Icon(Icons.check_box_outline_blank);
    }
  }

  bool _checkIsin(String inputIsin) {
    var isin = inputIsin.trim().toUpperCase();
    if (isin.length != 12) {
      return false;
    }
    RegExp regExp = RegExp("^[A-Z]{2}[A-Z0-9]{9}");
    if (!regExp.hasMatch(isin)) {
      return false;
    }
    var digitos = <int>[];
    for (var char in isin.codeUnits) {
      if (char >= 65 && char <= 90) {
        final value = char - 55;
        digitos.add(value ~/ 10);
        digitos.add(value % 10);
      } else if (char >= 48 && char <= 57) {
        digitos.add(char - 48);
      } else {
        return false;
      }
    }
    digitos.removeLast();
    digitos = digitos.reversed.toList();
    var suma = 0;
    digitos.asMap().forEach((index, value) {
      if (index.isOdd) {
        suma += value;
      } else {
        var doble = value * 2;
        suma += doble < 9 ? doble : (doble ~/ 10) + (doble % 10);
      }
    });
    var valor = ((suma / 10).ceil() * 10);
    var dc = valor - suma;
    if (dc != int.parse(isin[11])) {
      return false;
    } else {
      return true;
    }
  }

  Future<FondoCompanion> _searchIsin(String inputIsin) async {
    final FondoCompanion? getFondo =
        await YahooFinance().getFondoByIsin(inputIsin);
    if (getFondo != null) {
      setState(() => _errorDataApi = false);
      return getFondo;
    } else {
      setState(() => _errorDataApi = true);
      return FondoCompanion(
        name: const dr.Value('Fondo no encontrado'),
        isin: dr.Value(inputIsin),
      );
    }
  }

  Widget _resultSearch() {
    if (_buscando) {
      return const Center(child: CircularProgressIndicator());
    } else {
      if (_errorDataApi == false) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  locatedFond?.name.value ?? '',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text('¿Añadir a la cartera?'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          setState(() {
                            _validIsin = null;
                            _errorDataApi = null;
                          });
                        }),
                    TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          var fondo = locatedFond;
                          Navigator.pop(context, fondo);
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      } else if (_errorDataApi == true) {
        return const Center(child: Text('Fondo no encontrado'));
      } else {
        return const Text('');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Fondo'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: SegmentedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity:
                      const VisualDensity(horizontal: -1, vertical: -1),
                  //fixedSize: MaterialStateProperty.all(Size.fromWidth(50)),
                ),
                segments: <ButtonSegment<Options>>[
                  ButtonSegment<Options>(
                    value: Options.isin,
                    label: Text(Options.isin.name.toUpperCase()),
                  ),
                  ButtonSegment<Options>(
                    value: Options.nombre,
                    label: Text(Options.nombre.name.toUpperCase()),
                  ),
                ],
                selected: <Options>{selectedOption},
                onSelectionChanged: (Set<Options> newSelection) {
                  setState(() {
                    selectedOption = newSelection.first;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            if (selectedOption == Options.isin) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Introduce el ISIN del nuevo Fondo:'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              onChanged: (text) {
                                setState(() {
                                  _validIsin = null;
                                  _errorDataApi = null;
                                });
                              },
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z0-9]'))
                              ],
                              decoration: const InputDecoration(
                                hintText: 'ISIN',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          _resultIsValid(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.security),
                            label: const Text('Validar'),
                            onPressed: _controller.text.isNotEmpty
                                ? () => setState(() => _validIsin =
                                    _checkIsin(_controller.value.text))
                                : null,
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.search),
                            label: const Text('Buscar'),
                            onPressed: _controller.text.isEmpty
                                ? null
                                : () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    if (_checkIsin(_controller.value.text)) {
                                      setState(() {
                                        _validIsin = true;
                                        _buscando = true;
                                      });
                                      locatedFond = await _searchIsin(
                                          _controller.value.text);
                                      setState(() => _buscando = false);
                                    } else {
                                      setState(() => _validIsin = false);
                                      if (!mounted) return;
                                      const snackBar = SnackBar(
                                        content: Text('Código ISIN no válido'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _resultSearch(),
            ],
            if (selectedOption == Options.nombre) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Introduce parte del nombre del Fondo:'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controllerName,
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (controllerName.text.trim().length > 3) {
                                setState(() => searchingNames = true);
                                List<FondoCompanion> listaFondos =
                                    await YahooFinance().getFondosByName(
                                        controllerName.text.trim());
                                setState(() => fondosSugeridos = listaFondos);
                                setState(() => searchingNames = false);
                              } else {
                                if (!mounted) return;
                                const snackBar = SnackBar(
                                  content: Text('Dame alguna pista más'),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: const Icon(Icons.search),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (searchingNames == true) const CircularProgressIndicator(),
              if (searchingNames == false && fondosSugeridos.isEmpty)
                const Text('Sin resultados'),
              if (searchingNames == false && fondosSugeridos.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: fondosSugeridos.length,
                    itemBuilder: (context, index) {
                      FondoCompanion fondo = fondosSugeridos[index];
                      String isin = fondo.isin.value!.isEmpty
                          ? 'ISIN no encontrado'
                          : fondo.isin.value!;
                      return Card(
                        key: ValueKey(fondosSugeridos[index].isin),
                        color: Colors.amber,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          enabled: fondo.isin.value!.isNotEmpty,
                          title: Text(
                            fondo.name.value,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                isin,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context, fondo);
                          },
                          trailing: Icon(fondo.isin.value!.isEmpty
                              ? Icons.block_outlined
                              : Icons.add_circle_outline),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
