import 'package:flutter/material.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class EncargosClientes extends StatefulWidget {
  const EncargosClientes({super.key});

  @override
  State<EncargosClientes> createState() => _EncargosClientesState();
}

class _EncargosClientesState extends State<EncargosClientes> {
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
        print('conexion abierta');
      });
    } else {
      setState(() {
        conexionIsOpen2 = false;
      });
    }
  }

  List<Map<String, dynamic>> result = [];

  Future auxClientes() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataClientes();
      setState(() {
        result = resultMap;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxClientes();
    });
  }

  @override
  void dispose() {
    dbHelper.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteUnicos = result
                      .map((e) => e['documentocliente'].toString())
                      .toSet()
                      .toList();
    final nombreClientes = result
                      .map((e) => e['nombrecompletocliente'].toString())
                      .toSet()
                      .toList();
    final pedidosporcliente = clienteUnicos.map((e) =>
     result.where((i) => i['documentocliente'].toString() == e).toString()).toList();
                  
              
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encargos Clientes'),
      ),
      body: Center(
        child: (!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : ListView.builder(
                  
                itemCount: result.length,
                itemBuilder: (context, index) {
                  print(clienteUnicos);
                  // final pedidoUnicos = result
                  //     .map((e) => e['descripcionproducto'])
                  //     .toSet()
                  //     .toList();

                    print(pedidosporcliente);
                  //print(pedidoUnicos);
                  return ExpansionTile(
                    //controlAffinity: ListTileControlAffinity.leading ,
                    leading: const Icon(Icons.person_pin_rounded),
                    trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
                    title: Text.rich(TextSpan(
                        text: "Nombre: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: result[index]['nombrecompletocliente'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),

                    subtitle: Text.rich(TextSpan(
                        text: "Documento: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: result[index]['documentocliente'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),

                    children: [

                      // for(int i = 0; i < pedidosporcliente.length; i++)
                      // ListTile(
                      //   title: Text(pedidosporcliente[i]),
                      // ),
                      ListTile(
                        title: Text.rich(TextSpan(
                            text: "Pedido: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: result[index]['descripcionproducto'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal))
                            ])),
                        subtitle: Text.rich(TextSpan(
                            text: "Tipo: ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: result[index]['tipoproducto'] ==
                                          "prendavestir"
                                      ? "prenda de vestir"
                                      : result[index]['tipoproducto'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal))
                           
                    ])),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
