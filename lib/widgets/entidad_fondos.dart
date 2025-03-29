import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/fondo_screen.dart';
import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';
import '../utils/stats.dart';

class EntidadFondos extends ConsumerStatefulWidget {
  final EntidadData entidad;
  const EntidadFondos({super.key, required this.entidad});

  @override
  ConsumerState<EntidadFondos> createState() => _EntidadFondosState();
}

class _EntidadFondosState extends ConsumerState<EntidadFondos> {
  late AppDatabase database;
  List<FondoData> fondosEntidad = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadFondosEntidad();
    super.initState();
  }

  loadFondosEntidad() async {
    final fondos = await database.allFondos;
    if (mounted) {
      setState(() {
        fondosEntidad =
            fondos.where((c) => c.entidad == widget.entidad.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: fondosEntidad.length,
      itemBuilder: (context, index) {
        final fondo = fondosEntidad[index];
        if (fondo.entidad != widget.entidad.name) {
          return const SizedBox(height: 0);
        }
        /*List<ValorFondo> valores = [];
          valores.addAll(fondo.valores);
          if (valores.length > 1) {
          valores.sort((a, b) => a.fecha.compareTo(b.fecha));
          }*/
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FondoScreen(fondo: fondo),
              ),
            );
          },
          leading: CircleAvatar(
            child: Text(fondo.name[0].toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium),
          ),
          title: Text(fondo.name),
          subtitle: Text(fondo.isin ?? ''),
          trailing: FutureBuilder(
            future: database.getValores(fondo.id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final valoresFondo = snapshot.data!;
                Stats stats = Stats(valoresFondo);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      NumberUtil.currency(stats.resultado() ?? 0),
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (valoresFondo.isNotEmpty)
                      Text(FechaUtil.dateToString(
                        date: valoresFondo.first.fecha,
                        formato: 'MMM yy',
                      )),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
