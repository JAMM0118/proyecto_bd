import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
String roles = 'admin';
class FormularioConsultar extends StatefulWidget {
  final String? rol;
  const FormularioConsultar({super.key,  this.rol});

  @override
  State<FormularioConsultar> createState() => _FormularioConsultarState();
}

const List<String> list = <String>['cliente', 'pedido', 'producto', 'Insumo'];
class _FormularioConsultarState extends State<FormularioConsultar> {
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
  List clientesCedulas = [];
  List clientes = [];
  
  bool query = false;
  late TextEditingController controllers = TextEditingController();
  Future auxSelect() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData(table);
      setState(() {
        result = resultMap;

        query = true;
        if(table == 'cliente'){      
        clientesCedulas = result.map((e) => e['documentocliente']).toSet().toList();
        clientes = clientesCedulas
        .map((e) => {
              'cliente': result.firstWhere((r) => r['documentocliente'] == e)['nombrecompletocliente'],
              'cedula': e
            })
        .toList();
        }

        if(table == 'pedido'){
          clientesCedulas = result.map((e) => e['productoencargado']).toSet().toList();
          clientes = clientesCedulas
          .map((e) => {
                'cliente': e,
                'cedula': result.firstWhere((r) => r['productoencargado'] == e)['estado']
              })
          .toList();
        }
        if(table == 'inventarioproducto'){
          clientesCedulas = result.map((e) => e['codigoproducto']).toSet().toList();
          clientes = clientesCedulas
          .map((e) => {
                'cliente': e,
                'cedula': result.firstWhere((r) => r['codigoproducto'] == e)['descripcionproducto']
              })
          .toList();
        }
        if(table == 'materiaprima'){
          clientesCedulas = result.map((e) => e['tipo']).toSet().toList();
          clientes = clientesCedulas
          .map((e) => {
                'cliente': e,
                'cedula': result.firstWhere((r) => r['tipo'] == e)['unidadmedida']
              })
          .toList();
        }
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
          'Consultar Datos',
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
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                              "¿Que deseas cosultar?",
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
                        
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                  setState(() {
                                    auxSelect();
                                  });
                                  showAdaptiveDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Datos'),
                                      content: SizedBox(
                                        height: MediaQuery.sizeOf(context).height * 0.5,
                                        width: MediaQuery.sizeOf(context).width * 0.8,
                                        child: ListView.builder(
                                          itemCount: clientesCedulas.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: table == 'cliente' ? Text("Nombre: ${clientes[index]['cliente']}"):
                                              table == 'pedido' ? Text("Codigo: ${clientes[index]['cliente']}"):
                                              table == 'inventarioproducto' ? Text("Codigo producto: ${clientes[index]['cliente']}"):
                                              table == 'materiaprima' ? Text("Descripcion: ${clientes[index]['cliente']}"): const Text(""),
                                              subtitle: table == 'cliente' ? Text("Documento: ${clientes[index]['cedula']}"):
                                              table == 'pedido' ? Text("Estado: ${clientes[index]['cedula']}"):
                                              table == 'inventarioproducto' ? Text("Descripcion: ${clientes[index]['cedula']}"):
                                              table == 'materiaprima' ? Text("Medida: ${clientes[index]['cedula']}"): const Text(""),
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cerrar'),
                                        )
                                      ],
                                    ),
                                  );
                                
                              },
                              child: const Text('Ver Datos')),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}