import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
import 'package:proyecto_bd/presentation/screens/inicio_screen.dart';

class FormularioModificar extends StatefulWidget {
  final String username;
  final String rol;
  
  const FormularioModificar({super.key, required this.username, required this.rol});

  @override
  State<FormularioModificar> createState() => _FormularioModificarState();
}

const List<String> list = <String>['cliente', 'pedido', 'producto', 'Insumo'];

class _FormularioModificarState extends State<FormularioModificar> {
  String dropdownValue = list.first;
  String dropdownValue2 = '';
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
  List distintivosDeTablas = [];

  bool query = false;
  List<TextEditingController> controllers = [];
  Future auxSelect() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData(table);
      setState(() {
        result = resultMap;
        query = true;
        distintivosDeTablas = table == 'cliente'
            ? result
                .map((e) => e['documentocliente'].toString())
                .toSet()
                .toList()
            : table == 'pedido'
                ? result
                    .map((e) => e['numeropedido'].toString())
                    .toSet()
                    .toList()
                : table == 'inventarioproducto'
                    ? result
                        .map((e) => e['codigoproducto'].toString())
                        .toSet()
                        .toList()
                    : table == 'materiaprima'
                        ? result
                            .map((e) => e['codigomateriaprima'].toString())
                            .toSet()
                            .toList()
                        : [];
                  dropdownValue2 = distintivosDeTablas.first;
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
          'Modificar Datos',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/$roles');
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
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 20),
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
                              "¿Que deseas modificar?",
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
                                                  ? 'materiaprima'
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              table == "cliente"
                                  ? "Seleccione cedula"
                                  : table == "pedido"
                                      ? "Seleccione\n numero de pedido"
                                      : table == "inventarioproducto"
                                          ? "Seleccione\n codigo del producto"
                                          : table == "materiaprima"
                                              ? "Seleccione\n codigo de insumo"
                                              : "",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            DropdownMenu<String>(
                              initialSelection: distintivosDeTablas.first,
                              inputDecorationTheme: InputDecorationTheme(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              onSelected: (String? value) {
                                setState(() {
                                  dropdownValue2 = value!;

                                });
                              },
                              menuHeight: 230,
                              dropdownMenuEntries: distintivosDeTablas
                                  .map<DropdownMenuEntry<String>>((value) {
                                return DropdownMenuEntry<String>(
                                  value: value.toString(),
                                  label: value.toString(),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Ingrese los nuevos valores"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: List.generate(
                                (table == 'pedido' ?result.first.keys.length-3:
                                table == 'inventarioproducto' ? result.first.length-4 :
                                table == 'cliente' ? result.first.length-1 :
                                result.first.length-2 ), (index) {
                                controllers.add(TextEditingController());
                              return TextFormField(
                                controller: controllers[index],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'El campo no puede estar vacio';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: table !='cliente' ? result.first.keys.elementAt(index +1)
                                  :result.first.keys.elementAt(index)
                                      ,
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formularioEstado.currentState!
                                    .validate()) {
                                    List<String> valores = controllers.map((controller) => controller.text).toList();
                                      List<String> valoresReales = valores.where((element) => element.isNotEmpty).toList();
                            
                                  table == 'cliente' ? dbHelper.updateDataClientes(valoresReales[0], valoresReales[1], dropdownValue2.toString()) 
                                  : table == 'pedido' ? dbHelper.updateDataPedidos(valoresReales[0], valoresReales[1], valoresReales[2],
                                  valoresReales[3], valoresReales[4],valoresReales[5], dropdownValue2.toString()):
                                  table == 'inventarioproducto' ? dbHelper.updateDataInventarioProducto(valoresReales[0], valoresReales[1], valoresReales[2],
                                  valoresReales[3], valoresReales[4],valoresReales[5], dropdownValue2.toString()) :
                                  dbHelper.updateDataMateriaPrima(valoresReales[0], valoresReales[1], valoresReales[2],valoresReales[3],dropdownValue2.toString());
                                  dbHelper.insertRegistro(table, 'modificar');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Modificando datos')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Datos invalidos')));
                                }
                                setState(() {
                                  controllers.clear();
                                
                                });
                              },
                              child: const Text('Modificar Datos')),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
