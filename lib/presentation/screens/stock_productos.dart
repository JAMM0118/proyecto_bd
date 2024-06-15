import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class StockProductos extends StatefulWidget {
  
  const StockProductos({super.key,});

  @override
  State<StockProductos> createState() => _StockProductosState();
}

class _StockProductosState extends State<StockProductos> {
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
  

  Future auxStock() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataStock();
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
      await auxStock();
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
        title: const Text('Stock',style: TextStyle(color: Colors.white),),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
          },
        ),
        backgroundColor: colors.primary,
      ),
      body:Center(
        child: (!conexionIsOpen2)
            ? const CircularProgressIndicator(
                strokeWidth: 2,
              )
            : ListView.builder(
                itemCount: result.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    iconColor: colors.primary,
                    leading: const Icon(Icons.checkroom_outlined),
                    title:
                        Text(result[index]['descripcionproducto'].toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            )),
                    subtitle: Text(
                        (result[index]['tipoproducto'] == 'prendavestir')
                            ? 'prenda de vestir'
                            : result[index]['tipoproducto']),
                    trailing: Text(
                      "Stock: ${result[index]['cantidad'].toString()}",
                    ),
                  );
                },
              ),
      ),
    );
  }
}