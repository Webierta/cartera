import 'package:flutter/material.dart';

import '../utils/fecha_util.dart';

class DiaCalendario extends StatelessWidget {
  final int epoch;
  const DiaCalendario({super.key, required this.epoch});

  @override
  Widget build(BuildContext context) {
    //int dia = FechaUtil.epochToDate(epoch).day;
    String mesYear = FechaUtil.epochToString(epoch, formato: 'MMM yy');
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              color: Colors.red,
              child: Text(
                mesYear,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(
              FechaUtil.epochToString(epoch, formato: 'dd'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 32, // 32
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
