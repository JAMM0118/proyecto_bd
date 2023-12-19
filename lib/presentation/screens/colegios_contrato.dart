import 'package:flutter/material.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class ColegiosContrato extends StatefulWidget {
  const ColegiosContrato({super.key});

  @override
  State<ColegiosContrato> createState() => _ColegiosContratoState();
}

class _ColegiosContratoState extends State<ColegiosContrato> {
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
  

  Future auxData() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData("uniforme");
      setState(() {
        result = resultMap;
      });
    }
  }
  @override
  void initState() {
   super.initState();
     WidgetsBinding.instance.addPostFrameCallback( (_) async {
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
    
    final nombreIntitucion = result
                      .map((e) => e['institucion'])
                      .toSet()
                      .toList();
    //print(nombreIntitucion);
    //print(result);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colegios con contrato'),
      ),
      body: Center( child:(!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            :ListView.builder(
        itemCount: nombreIntitucion.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(nombreIntitucion[index]),
            leading: const Icon(Icons.school_rounded),
          );
        },
      )),
    );
  }
}