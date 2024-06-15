import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class EncargosClientes extends StatefulWidget {
  final String? rol;
  const EncargosClientes({super.key, this.rol});

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
    final cedulasUnicas =
        result.map((e) => e['documentocliente']).toSet().toList();
    final clienteUnicos = cedulasUnicas
        .map((e) => {
              'cliente': result.firstWhere(
                  (r) => r['documentocliente'] == e)['nombrecompletocliente'],
              'cedula': e
            })
        .toList();

    final pedidosporcliente = clienteUnicos
        .map((c) =>
            result.where((e) => e['documentocliente'] == c['cedula']).toList())
        .toList();
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encargos Clientes', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
          },
        ),
        backgroundColor: colors.primary,
      ),
      body: Center(
        child: (!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : ListView.builder(
                itemCount: clienteUnicos.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    leading: const Icon(Icons.person_pin_rounded),
                    trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
                    title: Text.rich(TextSpan(
                        text: "Nombre: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: clienteUnicos[index]['cliente'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),

                    subtitle: Text.rich(TextSpan(
                        text: "Documento: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: clienteUnicos[index]['cedula'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),

                    children: [
                      for (int i = 0; i < pedidosporcliente[index].length; i++)
                        ListTile(
                          title: Text.rich(TextSpan(
                              text: "Pedido: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: pedidosporcliente[index][i]
                                        ['descripcionproducto'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                          subtitle: Text.rich(TextSpan(
                              text: "Tipo: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: pedidosporcliente[index][i]
                                                ['tipoproducto'] ==
                                            "prendavestir"
                                        ? "prenda de vestir"
                                        : pedidosporcliente[index][i]
                                            ['tipoproducto'],
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
