import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
class VentasProductos extends StatefulWidget {
  const VentasProductos({super.key});

  @override
  State<VentasProductos> createState() => _VentasProductosState();
}

class _VentasProductosState extends State<VentasProductos> {
    final dbHelper = DatabaseHelper(
    host: 'monorail.proxy.rlwy.net',
    port: 31218,
    databaseName: 'railway',
    username: 'postgres',
    password: '4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c',
  );
  bool conexionIsOpen2 = false;
  bool consultaReady = false;
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

  Future auxVentasPrendas() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataVentasPrendasVestir();
      setState(() {
        result = resultMap;
        consultaReady = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxVentasPrendas();
    });
  }

  @override
  Widget build(BuildContext context) {
    print(result);
    final cedulasUnicas =
         result.map((e) => e['cedula']).toSet().toList();

     final clienteUnicos = cedulasUnicas
        .map((e) => {
              'cliente': result.firstWhere(
                  (r) => r['cedula'] == e)['cliente'],
              'cedula': e
            })
        .toList();
      

    final ventasporcliente = clienteUnicos
        .map((c) =>
            result.where((e) => e['cedula'] == c['cedula']).toList())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas por productos'),
      ),
      body:  Center(
        child:(!consultaReady)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              ): ListView.builder(
                itemCount: clienteUnicos.length,
                itemBuilder: (context, index) {
                  
                  return ExpansionTile(
                    //controlAffinity: ListTileControlAffinity.leading ,
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
                        ])) ,

                    children: [
                      for (int i = 0;
                          i < ventasporcliente[index].length;
                          i++) ...[
                        ListTile(
                          title: Text.rich(TextSpan(
                              text: "Producto: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: ventasporcliente[index][i]
                                        ['producto'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                          trailing: ventasporcliente[index][i]
                                      ['precio_unitario'] !=
                                  null
                              ? Text.rich(TextSpan(
                                  text: "Valor Unitario:",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                      TextSpan(
                                          text: ventasporcliente[index][i]
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
                                    text: ventasporcliente[index][i]
                                            ['cantidad_vendida']
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal))
                              ])),
                        ),
                        ListTile(
                          title: ventasporcliente[index][i]['total_venta'] !=
                                  null
                              ? Text.rich(TextSpan(
                                  text: "Total Venta: ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                  children: <TextSpan>[
                                      TextSpan(
                                          text: ventasporcliente[index][i]
                                                  ['total_venta']
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal))
                                    ]))
                              : const Text(''),
                            subtitle: ventasporcliente[index][i]['fecha_entrega'] !=
                                  null
                              ? Text.rich(TextSpan(
                                  text: "Fecha de compra: ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                      TextSpan(
                                          text: DateFormat('yyyy-MM-dd').format(ventasporcliente[index][i]
                                                  ['fecha_entrega'])
                                              .toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal))
                                    ]))
                              : const Text('')
                        ),
                      ]
                    ],
                  );
                },
              ),
      ),
    );
  }
}