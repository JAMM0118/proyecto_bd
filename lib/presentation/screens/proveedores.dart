import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
class Proveedores extends StatefulWidget {
  
  
  const Proveedores({super.key,});

  @override
  State<Proveedores> createState() => _ProveedoresState();
}

class _ProveedoresState extends State<Proveedores> {
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
      final resultMap = await dbHelper.selectDataProveedores();
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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores Registrados', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
          },
        ),
        
          backgroundColor:colors.primary,
      ),
      body: Center( child:(!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            :ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text.rich(TextSpan(
                        text: "Nombre: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: result[index]['nombreproveedor'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),
            leading:  Icon(Icons.business,color: colors.primary),
            trailing: Text.rich(TextSpan(
                        text: "Medida: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: result[index]['unidadmedida'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),
            subtitle: Text.rich(TextSpan(
                        text: "Insumo: ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: result[index]['materiaprimasuministrada'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal))
                        ])),
          );
        },
      )),
    );

  }
}