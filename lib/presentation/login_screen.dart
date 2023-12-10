import 'package:flutter/material.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class LoginScreen extends StatefulWidget {
    const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  final dbHelper = DatabaseHelper(
    host: 'monorail.proxy.rlwy.net',
    port: 31218,
    databaseName: 'railway',
    username: 'postgres',
    password: '4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c',);

  void aux() async{
    if (await dbHelper.openConnection()) {

    await dbHelper.insertData('prueba', {"userName": 'prue121ba', "passwordUser": 'p2121rueba'});
    print('Datos insertados con éxito');
    await dbHelper.closeConnection();
  } else {
    print('Error al abrir la conexión');
  }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //if(connectionStatus() == null) Text("conectado") else Text("no conectado")
            
              
            FilledButton(
              onPressed: () => (),
              child:  const Text("Login"),
            ),
            const SizedBox(width: 10,),
            FilledButton(
              onPressed: () =>(),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}