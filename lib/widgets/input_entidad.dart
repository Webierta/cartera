import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';

class InputEntidad extends ConsumerStatefulWidget {
  final TextEditingController entidadController;
  const InputEntidad({super.key, required this.entidadController});

  @override
  ConsumerState<InputEntidad> createState() => _InputEntidadState();
}

class _InputEntidadState extends ConsumerState<InputEntidad> {
  List<EntidadData> entidades = [];
  //final TextEditingController entidadController = TextEditingController();

  @override
  void initState() {
    loadEntidades();
    super.initState();
  }

  loadEntidades() async {
    final database = ref.read(AppDatabase.provider);
    var entidadesList = await database.allEntidades;
    setState(() {
      entidades = entidadesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.entidadController,
            decoration: const InputDecoration(
              labelText: 'Entidad',
            ),
          ),
        ),
        PopupMenuButton<EntidadData>(
          onSelected: (EntidadData item) {
            widget.entidadController.text = item.name;
          },
          itemBuilder: (BuildContext context) {
            return entidades
                .map((e) => PopupMenuItem<EntidadData>(
                      value: e,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(e.logo),
                            //backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(width: 10),
                          Text(e.name),
                        ],
                      ),
                    ))
                .toList();
          },
          icon: const Icon(Icons.account_balance),
        ),
      ],
    );
  }
}
