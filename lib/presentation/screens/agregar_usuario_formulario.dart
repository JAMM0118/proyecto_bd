import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/dataBase/database_helper.dart';
class FormularioAgregarUsuario extends StatefulWidget {
  final String username;
  final String rol;
  
  const FormularioAgregarUsuario({super.key, required this.username, required this.rol});

  @override
  State<FormularioAgregarUsuario> createState() => _FormularioAgregarUsuarioState();
}

const List<String> list = <String>['cliente', 'pedido', 'producto', 'Insumo'];
class _FormularioAgregarUsuarioState extends State<FormularioAgregarUsuario> {
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();
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

  
  late TextEditingController controller1 = TextEditingController();
  
  late TextEditingController controller2 = TextEditingController();
  
  late TextEditingController controller3 = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await conexionIsOpen();
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
          'Agregar Usuario',
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
      body: (!conexionIsOpen2)
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Form(
              key: _formularioEstado,
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey)),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 10),
                    child: Column(
                      children: [
                        
                        const SizedBox(height: 20,),
                        TextFormField(
                                  controller: controller1,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'El campo no puede estar vacio';
                                    }
                                    return null;
                                  },

                                  decoration: const InputDecoration(  
                                      
                                    hintText:
                                        "Nombre de usuario",
                                    hintStyle:  TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    
                                  ),
                                ),
                        
                        const SizedBox(height: 20,),
                        
                        TextFormField(
                                  controller: controller2,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'El campo no puede estar vacio';
                                    }
                                    return null;
                                  },

                                  decoration: const InputDecoration(  
                                      
                                    hintText:
                                        "contraseña",
                                    hintStyle:  TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    
                                  ),
                                ),
                        
                        const SizedBox(height: 20,),
                        TextFormField(
                                  controller: controller3,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'El campo no puede estar vacio';
                                    }
                                    return null;
                                  },

                                  decoration: const InputDecoration(  
                                      
                                    hintText:
                                        "Rol",
                                    hintStyle:  TextStyle(
                                        fontSize: 14, color: Colors.grey),
                                    
                                  ),
                                ),
                        
                        const SizedBox(height: 20,),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.5,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formularioEstado.currentState!
                                    .validate()) {
                                      dbHelper.insertUser(controller1.text, controller2.text,controller3.text);
                                      dbHelper.insertRegistro('users', 'insertar');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Agregando usuario')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Datos invalidos')));
                                }
                                setState(() {
                                  controller1.clear();
                                  controller2.clear();
                                  controller3.clear();
                                
                                });
                              },
                              child: const Text('Agregar Usuario')),
                        )
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}