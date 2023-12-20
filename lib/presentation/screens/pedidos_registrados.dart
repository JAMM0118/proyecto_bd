import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class PedidosRegistrados extends StatefulWidget {
  const PedidosRegistrados({super.key});

  @override
  State<PedidosRegistrados> createState() => _PedidosRegistradosState();
}

class _PedidosRegistradosState extends State<PedidosRegistrados> {
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

  Future auxData() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataPedidos();
      setState(() {
        result = resultMap;
        print(result);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxData();
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
        title: const Text('Pedidos Registrados',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen');
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
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text.rich(TextSpan(
                          text: "Producto: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: result[index]['descripcionproducto'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal))
                          ])),
                      leading: Icon(Icons.receipt_long, color: colors.primary),
                      subtitle: Text.rich(TextSpan(
                          text: "Estado: ",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: result[index]['estado'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal))
                          ])),
                      children: [
                        ListTile(
                          title: Text.rich(TextSpan(
                              text: "Tipo: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: result[index]['tipoproducto'] ==
                                            "prendavestir"
                                        ? "prenda de vestir"
                                        : result[index]['tipoproducto'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                          trailing: Text(
                            "Encargo: ${DateFormat('yyyy-MM-dd').format(result[index]['fechaencargo']).toString()} \n Entrega: ${DateFormat('yyyy-MM-dd').format(result[index]['fechaentrega']).toString()}",
                          ),
                        )
                      ],
                    );
                  },
                )),
    );
  }
}
