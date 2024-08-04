import 'package:flutter/material.dart';

import '../services/tablas.dart';

class InputTitular extends StatefulWidget {
  final Titular titular;
  final Function changeTitular;
  const InputTitular({
    super.key,
    required this.changeTitular,
    required this.titular,
  });
  @override
  State<InputTitular> createState() => _InputTitularState();
}

class _InputTitularState extends State<InputTitular> {
  Titular titular = Titular.ambos;

  @override
  void initState() {
    titular = widget.titular;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Titular'),
          SegmentedButton(
            segments: const <ButtonSegment<Titular>>[
              ButtonSegment<Titular>(
                value: Titular.ambos,
                label: Text('Ambos'),
                icon: Icon(Icons.group),
              ),
              ButtonSegment<Titular>(
                value: Titular.jcv,
                label: Text('JCV'),
                icon: Icon(Icons.person),
              ),
              ButtonSegment<Titular>(
                value: Titular.rpp,
                label: Text('RPP'),
                icon: Icon(Icons.person),
              ),
            ],
            selected: <Titular>{titular},
            onSelectionChanged: (Set<Titular> newSelection) {
              titular = newSelection.first;
              widget.changeTitular(newSelection.first.name);
            },
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
