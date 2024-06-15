import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class VentasPorColegio extends StatefulWidget {
  
  
  const VentasPorColegio({super.key, });

  @override
  State<VentasPorColegio> createState() => _VentasPorColegioState();
}

class _VentasPorColegioState extends State<VentasPorColegio> {
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

  Future auxVentasColegios() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataVentasColegios();
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
      await auxVentasColegios();
    });
  }

  @override
  void dispose() {
    dbHelper.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colegiosUnicos = result.map((e) => e['institucion']).toSet().toList();
    final colegiosProducto = colegiosUnicos
        .map((e) => {
              'producto':
                  result.firstWhere((r) => r['institucion'] == e)["producto"],
              'colegio': e
            })
        .toList();

    final ventasPorColegio = colegiosProducto
        .map((c) =>
            result.where((e) => e['institucion'] == c['colegio']).toList())
        .toList();
      final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compras por colegio', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
          },
        ),
          backgroundColor:colors.primary,
      ),
      body: Center(
        child: (!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : ListView.builder(
                itemCount: colegiosProducto.length,
                itemBuilder: (context, index) {
                  return ExpansionTile(
                    //controlAffinity: ListTileControlAffinity.leading ,
                    leading: const Icon(Icons.school_outlined),
                    trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
                    title: Text.rich(TextSpan(
                        text: "Institution: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: colegiosProducto[index]['colegio'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),

                    children: [
                      for (int i = 0;
                          i < ventasPorColegio[index].length;
                          i++) ...[
                        ListTile(
                          title: Text.rich(TextSpan(
                              text: "Producto: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ventasPorColegio[index][i]
                                        ['producto'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                          trailing: ventasPorColegio[index][i]
                                      ['precio_unitario'] !=
                                  null
                              ? Text.rich(TextSpan(
                                  text: "Valor Unitario:",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                      TextSpan(
                                          text: ventasPorColegio[index][i]
                                                  ['precio_unitario']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal))
                                    ]))
                              : const Text(''),
                          subtitle: Text.rich(TextSpan(
                              text: "Cantidad Vendida: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ventasPorColegio[index][i]
                                            ['cantidad_vendida']
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                        ),
                        ListTile(
                            title: ventasPorColegio[index][i]['total_venta'] !=
                                    null
                                ? Text.rich(TextSpan(
                                    text: "Total Venta: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                    children: <TextSpan>[
                                        TextSpan(
                                            text: ventasPorColegio[index][i]
                                                    ['total_venta']
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal))
                                      ]))
                                : const Text(''),
                            subtitle: ventasPorColegio[index][i]
                                        ['fecha_entrega'] !=
                                    null
                                ? Text.rich(TextSpan(
                                    text: "Fecha de compra: ",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                        TextSpan(
                                            text: DateFormat('yyyy-MM-dd')
                                                .format(ventasPorColegio[index]
                                                    [i]['fecha_entrega'])
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal))
                                      ]))
                                : const Text('')),
                      ]
                    ],
                  );
                },
              ),
      ),
    );
  }
}
