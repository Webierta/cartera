import 'package:flutter/material.dart';

enum Orden { none, capital, alpha }

class SortButtons extends StatefulWidget {
  final Function() sortByCapital;
  final Function() sortByName;

  const SortButtons({
    super.key,
    required this.sortByCapital,
    required this.sortByName,
  });

  @override
  State<SortButtons> createState() => _SortButtonsState();
}

class _SortButtonsState extends State<SortButtons> {
  Orden orden = Orden.none;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Orden>(
      style: SegmentedButton.styleFrom(
        //backgroundColor: Colors.grey[200],
        //foregroundColor: Colors.red,
        selectedForegroundColor: Colors.white,
        selectedBackgroundColor: Theme.of(context).colorScheme.primary,
      ),
      segments: const <ButtonSegment<Orden>>[
        ButtonSegment<Orden>(
          value: Orden.capital,
          label: Text('Capital'),
          icon: Icon(Icons.sort),
        ),
        ButtonSegment<Orden>(
          value: Orden.alpha,
          label: Text('Nombre'),
          icon: Icon(Icons.sort_by_alpha),
        ),
      ],
      selected: <Orden>{orden},
      onSelectionChanged: (Set<Orden> newSelection) {
        setState(() {
          orden = newSelection.first;
        });
        if (newSelection.first == Orden.capital) {
          widget.sortByCapital();
        } else if (newSelection.first == Orden.alpha) {
          widget.sortByName();
        }
      },
    );
  }
}
