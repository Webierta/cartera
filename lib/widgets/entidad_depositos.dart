import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/deposito_screen.dart';
import '../services/app_database.dart';
import '../utils/fecha_util.dart';
import '../utils/number_util.dart';

class EntidadDepositos extends ConsumerStatefulWidget {
  final EntidadData entidad;
  const EntidadDepositos({super.key, required this.entidad});

  @override
  ConsumerState<EntidadDepositos> createState() => _EntidadDepositosState();
}

class _EntidadDepositosState extends ConsumerState<EntidadDepositos> {
  late AppDatabase database;
  List<DepositoData> depositosEntidad = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadDepositosEntidad();
    super.initState();
  }

  Future<void> loadDepositosEntidad() async {
    final depositos = await database.allDepositos;
    if (mounted) {
      setState(() {
        depositosEntidad =
            depositos.where((c) => c.entidad == widget.entidad.name).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //key: UniqueKey(),
      shrinkWrap: true,
      itemCount: depositosEntidad.length,
      itemBuilder: (context, index) {
        final deposito = depositosEntidad[index];
        if (deposito.entidad != widget.entidad.name) {
          return const SizedBox(height: 0);
        }
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DepositoScreen(deposito: deposito),
              ),
            );
          },
          //leading: CircleAvatar(child: Text(entidad[0])),
          leading: CircleAvatar(
            child: Text(
              deposito.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          title: Text(deposito.name),
          subtitle: Text(deposito.codigo ?? ''),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NumberUtil.currency(deposito.imposicion),
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                FechaUtil.dateToString(
                  date: deposito.vencimiento,
                  formato: 'd/MM/yy',
                ),
                style: TextStyle(
                  color:
                      deposito.vencimiento.difference(DateTime.now()).inDays <
                              30
                          ? Colors.red
                          : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
