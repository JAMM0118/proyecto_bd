import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  
  late TextEditingController controllerUser;
  late TextEditingController controllerPassword;
  bool isUser = false;
  String textUser = '';
  String textPassword = '';
  bool passwordNotVisible = true;
  bool conexionIsOpen2 = false;
  String rol = '';
  
  final dbHelper = DatabaseHelper(
    host: 'monorail.proxy.rlwy.net',
    port: 31218,
    databaseName: 'railway',
    username: 'postgres',
    password: '4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c',
  );

  Future conexionIsOpen() async {
    if (await dbHelper.openConnection()) {
      setState(() {
        conexionIsOpen2 = true;
      });
    }
  }

  List<Map<String, dynamic>> result = [];
  Future auxLogin() async {
    if (conexionIsOpen2) {
      final resultMap = await dbHelper.selectData('users');
      setState(() {
        result = resultMap;
      });
    }
  }
@override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
      await auxLogin();
    });
    controllerUser = TextEditingController();
    controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    dbHelper.closeConnection();
    controllerUser.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primary,
      body: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 10,
        verticalDirection: VerticalDirection.up,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              height: MediaQuery.sizeOf(context).height * 0.35,
              margin: MediaQuery.sizeOf(context).width > 900
                  ? const EdgeInsets.only(left: 400, right: 400)
                  : const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
                    child: TextField(
                      controller: controllerUser,
                      onChanged: (value) => setState(() {
                        textUser = controllerUser.text;
                      }),
                      cursorColor: colors.primary,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        labelText: 'User',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 15, 15, 10),
                    child: TextField(
                      cursorColor: colors.primary,
                      controller: controllerPassword,
                      onChanged: (value) => setState(() {
                        textPassword = controllerPassword.text;
                      }),
                      obscureText:
                          passwordNotVisible, // Use secure text for passwords. para que no se vea la contraseña
                      //obscuringCharacter: ':', // para que se vea el caracter que se pone en el obscureText
                      //readOnly: , // para que no se pueda escribir en el textfield
                      //textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                          //icon: Icon(Icons.lock),
            
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffix: IconButton(
                              onPressed: () => (setState(() {
                                    passwordNotVisible = !passwordNotVisible;
                                  })),
                              icon: passwordNotVisible
                                  ? const Icon(Icons.visibility_off_outlined)
                                  : const Icon(Icons.visibility_outlined))),
                    ),
                  ),
                  FilledButton(
                      onPressed: () {
                        for (Map<String, dynamic> row in result) {
                          String user = row['username'];
                          String password = row['password'];
                          String role = row['rol'];
                          if (user == textUser && password == textPassword) {
                            setState(() {
                              rol = role;
                              isUser = true;
                            });
                          }
                        }
            
                        if (isUser) {
                          context.go('/inicioScreen/$textUser/$rol');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content:
                                  const Text('Usuario o contraseña incorrectos'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: const Text("Sign In")),
                ],
              ),
            ),
          ),
          
          Padding(
            padding: MediaQuery.sizeOf(context).width < 720
                ? const EdgeInsets.fromLTRB(0, 10, 0, 0)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: Image.asset(
                "assets/images/test3.png",
                height: MediaQuery.sizeOf(context).width > 720
                    ? MediaQuery.sizeOf(context).height * 0.5
                    : MediaQuery.sizeOf(context).height * 0.25,
              ),
            ),
          ),
          Padding(
            padding: MediaQuery.sizeOf(context).width > 720
                ? const EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                : const EdgeInsets.fromLTRB(60, 70, 60, 10),
            child: const Text("WELCOME TO OUR STORE APP",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
          ),
          
        ],
      ),
    );
  }
}
