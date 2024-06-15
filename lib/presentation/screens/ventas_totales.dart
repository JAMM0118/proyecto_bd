import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class VentasTotales extends StatefulWidget {
  
  const VentasTotales({super.key, });

  @override
  State<VentasTotales> createState() => _VentasTotalesState();
}

class _VentasTotalesState extends State<VentasTotales> {
  final dbHelper = DatabaseHelper(
    host: 'monorail.proxy.rlwy.net',
    port: 31218,
    databaseName: 'railway',
    username: 'postgres',
    password: '4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c',
  );
  
  bool conexionIsOpen2 = false;
  bool prizeReady = false;
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
  List<Map<String, dynamic>> resultUniforme = [];
  List<Map<String, dynamic>> resultPrenda = [];
  

  Future auxVentasTotales() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectDataTotalVentas();
      final resultMap2 = await dbHelper.selectDataVentasTotalUniforme();
      final resultMap3 = await dbHelper.selectDataVentasTotalPrenda();
      //print(resultMap);
      setState(() {
        result = resultMap;
        resultUniforme = resultMap2;
        resultPrenda = resultMap3;
        prizeReady = true;
      });

    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxVentasTotales();
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
        title: const Text('Ventas totales', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/inicioScreen/:username/:rol');
          },
        ),
        
          backgroundColor:colors.primary,
      ),
      body:  (!prizeReady) ? const Center(child: CircularProgressIndicator(
                strokeWidth: 2,
              )):Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                swapAnimationCurve: Curves.easeInOut,
                swapAnimationDuration: const Duration(milliseconds: 150),
                PieChartData(
                  centerSpaceRadius: 50,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 5,
                  sections: [
                    PieChartSectionData(
                      color: Colors.red,
                      borderSide: const BorderSide(color: Colors.black),
                      radius: 80,
                      value: (resultUniforme[0]['total_ventas'] / result[0]['total_ventas'] * 100),
                      title: '${num.parse((resultUniforme[0]['total_ventas'] / result[0]['total_ventas'] * 100).toStringAsFixed(2))}%',
                    ),
                    PieChartSectionData(
                      color: Colors.blue,
                      borderSide: const BorderSide(color: Colors.black),
                      radius: 80,
                      value: (resultPrenda[0]['total_ventas'] / result[0]['total_ventas'] * 100),
                      title: '${num.parse((resultPrenda[0]['total_ventas'] / result[0]['total_ventas'] * 100).toStringAsFixed(2))}%',
                    ),
                  ],
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.black45),
                  ),
                ),
                const Text('Uniformes'),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.black45),
                  ),
                ),
                const Text('Prendas de vestir'),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(30),
              ),
              width: MediaQuery.sizeOf(context).width * 0.8,
              height: MediaQuery.sizeOf(context).height * 0.2,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(TextSpan(
                      text: "Ventas de uniformes: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text:  resultUniforme[0]['total_ventas'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.normal))
                      ])),
                  const SizedBox(
                    height: 30,
                  ),
                  Text.rich(TextSpan(
                      text: "Ventas de prendas de vestir: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: resultPrenda[0]['total_ventas'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.normal))
                      ])),
                      const SizedBox(
                    height: 30,
                  ),
                      Text.rich(TextSpan(
                      text: "Total de ventas: ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: result[0]['total_ventas'].toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.normal))
                      ])),
                ],
              ),
            )
          ]) 
    );
  }
}
