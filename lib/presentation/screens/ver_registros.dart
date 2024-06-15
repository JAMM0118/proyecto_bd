import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class FormularioRegistros extends StatefulWidget {
  final String username;
  final String rol;
  const FormularioRegistros(
      {super.key, required this.rol, required this.username});

  @override
  State<FormularioRegistros> createState() => _FormularioRegistrosState();
}

const List<String> list = <String>['cliente', 'pedido', 'producto', 'Insumo'];

class _FormularioRegistrosState extends State<FormularioRegistros> {

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

  List resultValuesUnique = [];
  List allValues = [];
  bool query = false;
  late TextEditingController controllers = TextEditingController();
  Future auxSelect() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData('registro');
      setState(() {
        result = resultMap;
        query = true;
         resultValuesUnique = result.map((e) => e['idregistro']).toSet().toList();
          allValues = resultValuesUnique
          .map((e) => {
                'fecha': result.firstWhere((r) => r['idregistro'] == e)['fechahora'],
                'operacion': result.firstWhere((r) => r['idregistro'] == e)['operacion'],
                'tabla': result.firstWhere((r) => r['idregistro'] == e)['tablamodificada']
              })
          .toList();
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
            'Ver Registros ',
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
            : ListView.builder(
              itemCount: resultValuesUnique.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text.rich(TextSpan(
                        text: "Operacion: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: allValues[index]['operacion'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ]))
                    ,
                    subtitle: Text.rich(TextSpan(
                        text: "Tabla afectada: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: allValues[index]['tabla'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),
                        leading: const Icon(Icons.list_alt),
                    trailing: Text.rich(TextSpan(
                        text: "Fecha: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: DateFormat('yyyy-MM-dd').format(allValues[index]['fecha']).toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),
                  ),
                );
              },
            ));
  }
}
