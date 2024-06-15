import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
import 'package:proyecto_bd/presentation/screens/inicio_screen.dart';

class FormularioEliminar extends StatefulWidget {
  final String username;
  final String rol;
  
  const FormularioEliminar({super.key, required this.username, required this.rol});

  @override
  State<FormularioEliminar> createState() => _FormularioEliminarState();
}

const List<String> list = <String>['cliente', 'pedido'];

class _FormularioEliminarState extends State<FormularioEliminar> {
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
                :  [];
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
          'Eliminar Datos',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
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
                  //height: MediaQuery.sizeOf(context).height * 0.40,
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
                              "¿Que deseas eliminar?",
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
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: ElevatedButton(
                              onPressed: () async{
                                table == 'pedido' ? await dbHelper.deleteDataPedido(dropdownValue2) 
                                : table == 'cliente' ? await dbHelper.deleteDataCliente(dropdownValue2):''; 
                                dbHelper.insertRegistro(table, 'eliminar');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Eliminando datos')));
                                
                                context.go('/inicioScreen/:username/:rol');
                                
                              },
                              child: const Text('Eliminar Datos')),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
