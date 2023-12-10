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

    await dbHelper.insertData('prueba', {"userName": 'meva13213', "passwordUser": '12312123'});
    print('Datos insertados con éxito');
    //await dbHelper.closeConnection();
  } else {
    print('Error al abrir la conexión');
  }
  }

  late TextEditingController controllerUser;
  late TextEditingController controllerPassword;
  String textUser = '';
  String textPassword = '';
  @override
  void initState() {
    super.initState();
    controllerUser = TextEditingController();
    controllerPassword = TextEditingController();
    
  }

  @override
  void dispose() {
    //dbHelper.closeConnection();
    controllerUser.dispose();
    controllerPassword.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
  
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),

      body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //if(connectionStatus() == null) Text("conectado") else Text("no conectado")
            
            Padding(
              padding: const EdgeInsets.fromLTRB(15,15,15,10),
              child: TextField(
                
                controller: controllerUser,
                onChanged: (value) => setState(() {
                  textUser = controllerUser.text;
            
                }),
                cursorColor: colors.primary,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  //hintText: 'User',                  
                  labelText: 'User',
                  //hintStyle: TextStyle(color: Colors.white)
                  
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15,15,15,10),
              child: TextField(
                
                cursorColor: colors.primary,
                controller: controllerPassword,
                onChanged: (value) => setState(() {
                  textPassword = controllerPassword.text;
            
                }),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  
                  labelText: 'Password',
                  
                ),
              ),
            ),
            Text(textUser),
            Text(textPassword),
            FilledButton(
              onPressed: () => (),

              child:  const Text("Sign In"),
            ),
           
          ],
        ),
      
    );
  }
}