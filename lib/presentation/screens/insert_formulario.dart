import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class FormularioInsertar extends StatefulWidget {
  const FormularioInsertar({super.key});

  @override
  State<FormularioInsertar> createState() => _FormularioInsertarState();
}

const List<String> list = <String>[
  'cliente',
  'pedido',
  'producto',
  'Insumo'
];

class _FormularioInsertarState extends State<FormularioInsertar> {
  String dropdownValue = list.first;
  String table = 'cliente';
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper(
    host: 'monorail.proxy.rlwy.net',
    port: 31218,
    databaseName: 'railway',
    username: 'postgres',
    password: '4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c',
  );
  bool conexionIsOpen2 = false;
  Future conexionIsOpen() async {
    if (await dbHelper.openConnection()) {
      setState(() {
        conexionIsOpen2 = true;
      });
    }
  }

  List<Map<String, dynamic>> result = [];
  bool query = false;
List<TextEditingController> controllers = [];
  Future auxSelect() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData(table);
      setState(() {
        result = resultMap;
        query = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxSelect();
    });
  }

  @override
  void dispose() {
    dbHelper.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insertar Datos',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen');
          },
        ),
        backgroundColor: colors.primary,
      ),
      body: (!query)
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Form(
              key: _formularioEstado,
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  height: MediaQuery.sizeOf(context).height * 0.65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey)),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "¿Que deseas insertar?",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 5),
                            DropdownMenu<String>(
                              initialSelection: list.first,
                              inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue = value!;
                                  table = dropdownValue == 'cliente'
                                      ? dropdownValue
                                      : dropdownValue == 'pedido'
                                          ? dropdownValue
                                          : dropdownValue == 'producto'
                                              ? 'inventarioproducto'
                                              : dropdownValue == 'Insumo'
                                                  ? 'materiaprima, proveedor'
                                                  : '';
                                  auxSelect();
                                });
                              },
                              dropdownMenuEntries: list
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                  value: value,
                                  label: value,
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              children: List.generate(result.first.keys.length,
                                  (index) {
                                  controllers.add(TextEditingController());
                                return TextFormField(
                                  controller: controllers[index],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'El ${result.first.keys.elementAt(index)} no puede estar vacio';
                                    }
                                    return null;
                                  },

                                  decoration: InputDecoration(    
                                    hintText:
                                        result.first.keys.elementAt(index),
                                    hintStyle: const TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                );
                              }),
                            )),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formularioEstado.currentState!
                                    .validate()) {
                                      List<String> valores = controllers.map((controller) => controller.text).toList();
                                      List<String> valoresReales = valores.where((element) => element.isNotEmpty).toList();
                                      print(valoresReales);
                                      print(result.first.keys);
                                      print(table);
                                       table =='cliente' ?   dbHelper.insertDataClientes(valoresReales[0], valoresReales[1], 
                                       valoresReales[2])
                                      : table == 'pedido' ? dbHelper.insertDataPedido(valoresReales[0], valoresReales[1], 
                                      valoresReales[2], valoresReales[3], valoresReales[4],valoresReales[5],
                                      valoresReales[6],valoresReales[7],valoresReales[8])
                                      :  table == 'inventarioproducto' ? dbHelper.insertDataProducto(valoresReales[0], valoresReales[1], valoresReales[2], 
                                      valoresReales[3], valoresReales[4],valoresReales[5],
                                      valoresReales[6],valoresReales[7],valoresReales[8],valoresReales[9])
                                      : dbHelper.insertDataMateriaPrima(valoresReales[0], valoresReales[1], valoresReales[2], 
                                      valoresReales[3], valoresReales[4],valoresReales[5],
                                      valoresReales[6],valoresReales[7],valoresReales[8],valoresReales[9]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Enviando datos')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Datos invalidos')));
                                }
                              },
                              child: const Text('Insertar Datos')),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
