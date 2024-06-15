import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class ColegiosContrato extends StatefulWidget {
  final String? rol;
  const ColegiosContrato({super.key, this.rol});

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
      final resultMap = await dbHelper.selectDataCaracteristica();
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
    
   final caracteristica = nombreIntitucion
        .map((e) => {
              'distintivo':
                  result.firstWhere((r) => r['institucion'] == e)["caracteristica"],
              'colegio': e,
              'estilo': result.firstWhere((r) => r['institucion'] == e)["estilouniforme"]
            })
        .toList();
  
    final caracteristicasTotales = caracteristica
        .map((c) =>
            result.where((e) => e['institucion'] == c['colegio']).toList())
        .toList();
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colegios con contrato', style: TextStyle(color: Colors.white)),
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
        itemCount: nombreIntitucion.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(nombreIntitucion[index]),
            leading:  Icon(Icons.school_rounded, color: colors.primary,),
            children: [
              const ListTile(
                            title: Text("Caracteristicas del uniforme"),
                          ),
               for (int i = 0;
                          i < caracteristicasTotales[index].length;
                          i++) ...[
                          
                        ListTile(
                          title: Text("#${i+1} ${caracteristicasTotales[index][i]['estilouniforme']}"),
                          subtitle: Text(caracteristicasTotales[index][i]['caracteristica'],
                        )
           ) ]

            ],
          );
        },
      )),
    );
  }
}