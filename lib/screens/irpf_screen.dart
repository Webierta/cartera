import 'package:carteradb/screens/irpf_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/app_database.dart';
import '../services/tablas.dart';
import '../utils/number_util.dart';
import '../widgets/background_image.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/menu.dart';
import 'cartera_screen.dart';

class IRPFScreen extends ConsumerStatefulWidget {
  final Titular? titular;
  const IRPFScreen({super.key, this.titular = Titular.ambos});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IRPFScreenState();
}

class _IRPFScreenState extends ConsumerState<IRPFScreen> {
  late AppDatabase database;
  List<IRPFData> irpf = [];
  Titular titularSelect = Titular.ambos;

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    setTitular();
    loadIRPF();
    super.initState();
  }

  setTitular() {
    setState(() {
      titularSelect = widget.titular ?? Titular.ambos;
    });
  }

  changeTitular() {}

  loadIRPF() async {
    var irpfList = await database.allIRPF;
    if (mounted) {
      setState(() {
        irpf = irpfList;
      });
    }
  }

  deleteAllIRPF(BuildContext context) async {
    final rentas = await database.allIRPF;
    if (rentas.isEmpty) {
      return;
    }
    if (!context.mounted) return;
    //if (!mounted) return;
    var confirm = await ConfirmDialog.dialogBuilder(
      context,
      '¿Eliminar todos los regitros de IRPF?',
    );
    if (confirm == true) {
      await database.deleteAllIRPF();
      if (!context.mounted) return;
      //if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CarteraScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CarteraScreen(),
              ),
            );
          },
          icon: const Icon(Icons.home),
        ),
        title: const Text('IRPF'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<Titular>(
                isDense: true,
                value: titularSelect,
                alignment: Alignment.center,
                onChanged: (Titular? value) {
                  setState(() => titularSelect = value ?? Titular.ambos);
                  changeTitular();
                },
                underline: SizedBox(),
                items: Titular.values.reversed
                    .map((e) => DropdownMenuItem<Titular>(
                          value: e,
                          child: Text(e.name.toUpperCase()),
                        ))
                    .toList(),
              ),
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            offset: Offset(0.0, AppBar().preferredSize.height),
            //shape: AppBox.roundBorder,
            itemBuilder: (ctx) => <PopupMenuItem<Enum>>[
              MenuItem.buildMenuItem(Menu.eliminar),
            ],
            onSelected: (item) async {
              if (item == Menu.eliminar) {
                deleteAllIRPF(context);
              }
            },
          ),
        ],
      ),
      /* body: Column(
        children: [
          if (irpf.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Ninguna registro a la vista'),
              ),
            ),
          if (irpf.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: irpf.length,
                itemBuilder: (context, index) {
                  final renta = irpf[index];
                  return ListTile(
                    title: Text(renta.ejercicio.toString()),
                  );
                },
              ),
            ),
        ],
      ), */
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: FutureBuilder<List<IRPFData>>(
          //future: database.allIRPF,
          future: database.titularIRPF(titularSelect),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return ListadoIRPF(rentas: snapshot.data!);
            } else {
              return const Center(child: Text('No hay cuentas todavía'));
            }
          },
        ),
      ),
    );
  }
}

class ListadoIRPF extends ConsumerStatefulWidget {
  final List<IRPFData> rentas;
  const ListadoIRPF({super.key, required this.rentas});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListadoIRPFState();
}

class _ListadoIRPFState extends ConsumerState<ListadoIRPF> {
  late AppDatabase database;
  //Set<String> entidadesSet = {};
  //List<EntidadData> entidades = [];

  Set<int> ejerciciosSet = {};
  double rendimientoEjercicio = 0;
  double retencionEjercicio = 0;
  Map<int, double> mapEjercicioRendimiento = {};
  Map<int, double> mapEjercicioRetencion = {};

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getEjerciciosSet();
    super.initState();
  }

  void loadEjercicioIRPF() {
    for (var ejercicio in ejerciciosSet) {
      double rendimiento = 0;
      double retencion = 0;

      //final List<IRPFData> rentasEjercicio = await database.ejercicioIRPF(ejercicio);
      for (var renta in widget.rentas) {
        rendimiento += renta.rendimiento;
        retencion += renta.rentencion;
      }
      if (mounted) {
        setState(() {
          mapEjercicioRendimiento[ejercicio] = rendimiento;
          mapEjercicioRetencion[ejercicio] = retencion;
        });
      }
    }
  }

  void getEjerciciosSet() {
    Set<int> ejerciciosYear = {};
    for (var renta in widget.rentas) {
      ejerciciosYear.add(renta.ejercicio);
    }
    if (mounted) {
      setState(() => ejerciciosSet = ejerciciosYear);
    }
    loadEjercicioIRPF();
  }

  /* void getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var renta in widget.rentas) {
      entidadesNombres.add(renta.entidad);
    }
    List<EntidadData> allEntidades = await database.allEntidades;
    setState(() {
      entidadesSet = entidadesNombres;
      entidades = allEntidades;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      children: [
        if (ejerciciosSet.isEmpty)
          const Expanded(
            child: Center(
              child: Text('Ningún registro a la vista'),
            ),
          ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(10),
            itemCount: ejerciciosSet.length,
            itemBuilder: (context, index) {
              final int ejercicio = ejerciciosSet.elementAt(index);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'Ejercicio $ejercicio',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Text(
                                NumberUtil.currency(
                                    mapEjercicioRendimiento[ejercicio] ?? 0),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            //const SizedBox(width: 14),
                            const Spacer(),
                            Expanded(
                              flex: 2,
                              child: Text(
                                NumberUtil.currency(
                                    mapEjercicioRetencion[ejercicio] ?? 0),
                                textAlign: TextAlign.right,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (ejerciciosSet.isNotEmpty)
                        EjercicioIRPF(
                          rentas: widget.rentas,
                          ejercicio: ejercicio,
                          key: UniqueKey(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EjercicioIRPF extends ConsumerStatefulWidget {
  final List<IRPFData> rentas;
  final int ejercicio;
  const EjercicioIRPF({
    super.key,
    required this.rentas,
    required this.ejercicio,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EjercicioIRPFState();
}

class _EjercicioIRPFState extends ConsumerState<EjercicioIRPF> {
  late AppDatabase database;

  Set<String> entidadesSet = {};
  List<EntidadData> entidades = [];
  //double rendimientoEntidad = 0;
  //double retencionEntidad = 0;
  Map<String, double> mapEntidadRendimiento = {};
  Map<String, double> mapEntidadRetencion = {};

  //List<IRPFData> irpfEntidad = [];
  //List<IRPFData> ejercicioEntidadIRPF = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    getEntidadesSet();
    super.initState();
  }

  void loadEntidadIRPF() {
    for (var entidad in entidadesSet) {
      double rendimiento = 0;
      double retencion = 0;
      /* final List<IRPFData> rentasEntidad = await database.ejercicioEntidadIRPF(
        widget.ejercicio,
        entidad,
      ); */
      final List<IRPFData> rentasEntidad =
          widget.rentas.where((r) => r.entidad == entidad).toList();
      for (var renta in rentasEntidad) {
        rendimiento += renta.rendimiento;
        retencion += renta.rentencion;
      }
      if (mounted) {
        setState(() {
          mapEntidadRendimiento[entidad] = rendimiento;
          mapEntidadRetencion[entidad] = retencion;
        });
      }
    }
  }

  void getEntidadesSet() async {
    Set<String> entidadesNombres = {};
    for (var renta in widget.rentas) {
      if (renta.ejercicio == widget.ejercicio) {
        entidadesNombres.add(renta.entidad);
      }
    }
    List<EntidadData> allEntidades = await database.allEntidades;
    if (mounted) {
      setState(() {
        entidadesSet = entidadesNombres;
        entidades = allEntidades;
      });
    }
    loadEntidadIRPF();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entidadesSet.length,
      itemBuilder: (context, index) {
        final String entidad = entidadesSet.elementAt(index);
        final entidadData =
            entidades.where((e) => e.name == entidad).toList().firstOrNull;
        //loadEntidadIRPF(entidad);
        //return EntidadIRPF(ejercicio: widget.ejercicio, entidad: entidadData!);
        //final Future<(double, double)> entidadIRPF = loadEntidadIRPF(entidadData!);
        return Card(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                BackgroundImage.getImage(entidadData),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            entidad,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        NumberUtil.currency(
                            mapEntidadRendimiento[entidad] ?? 0),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 2,
                      child: Text(
                        NumberUtil.currency(mapEntidadRetencion[entidad] ?? 0),
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                EntidadIRPF(
                  rentas: widget.rentas,
                  ejercicio: widget.ejercicio,
                  entidad: entidadData!,
                  key: UniqueKey(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EntidadIRPF extends ConsumerStatefulWidget {
  final List<IRPFData> rentas;
  final int ejercicio;
  final EntidadData entidad;
  const EntidadIRPF({
    super.key,
    required this.rentas,
    required this.ejercicio,
    required this.entidad,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EntidadIRPFState();
}

class _EntidadIRPFState extends ConsumerState<EntidadIRPF> {
  late AppDatabase database;
  List<IRPFData> irpfEntidad = [];

  @override
  void initState() {
    database = ref.read(AppDatabase.provider);
    loadIrpfEntidad();
    super.initState();
  }

  void loadIrpfEntidad() {
    /* List<IRPFData> entidadIRPF = await database.ejercicioEntidadIRPF(
        widget.ejercicio, widget.entidad.name); */

    final List<IRPFData> ejercicioIRPF =
        widget.rentas.where((r) => r.ejercicio == widget.ejercicio).toList();

    final List<IRPFData> entidadIRPF =
        ejercicioIRPF.where((r) => r.entidad == widget.entidad.name).toList();
    if (mounted) {
      setState(() => irpfEntidad = entidadIRPF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: irpfEntidad.length,
      itemBuilder: (context, index) {
        final irpf = irpfEntidad[index];
        return InkWell(
          onTap: () {
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IRPFAddScreen(
                  entidad: irpf.entidad,
                  tipoProducto: irpf.tipoProducto,
                  codigo: irpf.codigo,
                  editIRPF: irpf,
                ),
              ),
            );
          },
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    Icon(irpf.tipoProducto.icon),
                    const SizedBox(width: 8),
                    Text(irpf.codigo),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  NumberUtil.currency(irpf.rendimiento),
                  textAlign: TextAlign.right,
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 2,
                child: Text(
                  NumberUtil.currency(irpf.rentencion),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
