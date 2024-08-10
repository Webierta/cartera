import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../widgets/historico_valores.dart';
import '../widgets/title_section.dart';

class FondoTabTabla extends ConsumerStatefulWidget {
  final FondoData fondo;
  final Function(ValoresFondoData) deleteValor;
  final Function(ValoresFondoData) deleteOperacion;
  const FondoTabTabla({
    super.key,
    required this.fondo,
    required this.deleteValor,
    required this.deleteOperacion,
  });

  @override
  ConsumerState<FondoTabTabla> createState() => _FondoTabTablaState();
}

class _FondoTabTablaState extends ConsumerState<FondoTabTabla> {
  late AppDatabase database;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<List<ValoresFondoData>>(
            stream: database.getValoresFondo(widget.fondo.id),
            builder: (
              BuildContext context,
              AsyncSnapshot<List<ValoresFondoData>> snapshot,
            ) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        const TitleSection(
                          title: 'OPERACIONES',
                          icon: Icons.shopping_cart,
                        ),
                        HistoricoValores(
                          valores: snapshot.data!
                              .where((data) => data.tipo != null)
                              .toList(),
                          delete: widget.deleteOperacion,
                          //delete: deleteOperacion,
                          fondo: widget.fondo,
                          isOperacion: true,
                        ),
                        const SizedBox(height: 40),
                        const TitleSection(
                          title: 'HISTÓRICO',
                          icon: Icons.calendar_month,
                        ),
                        HistoricoValores(
                          valores: snapshot.data!,
                          //delete: deleteValor,
                          delete: widget.deleteValor,
                          fondo: widget.fondo,
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
