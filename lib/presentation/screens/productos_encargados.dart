import 'package:flutter/material.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class ProductosEncargados extends StatefulWidget {
  const ProductosEncargados({super.key});

  @override
  State<ProductosEncargados> createState() => _ProductosEncargadosState();
}

class _ProductosEncargadosState extends State<ProductosEncargados> {
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

  Future auxProductos() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData('inventarioproducto');
      setState(() {
        result = resultMap;
      });
    }
  }

  @override
  void initState() {
    conexionIsOpen();
    super.initState();
  }

  @override
  void dispose() {
    dbHelper.closeConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prueba = "asda";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Encargados'),
      ),
      body: Center(
        child: Column(
          children: [
            FilledButton(onPressed: 
            () async {
              await auxProductos();
            }
            , child: Text('prueba')),
            Text(result.toString()),
          ],
        ),
      ),
    );
  }
}
