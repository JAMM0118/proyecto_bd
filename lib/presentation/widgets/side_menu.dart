import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/config/menu/menu_items.dart';

class SideMenu extends StatefulWidget {

  final GlobalKey<ScaffoldState>scaffoldKey;
  const SideMenu({super.key, required this.scaffoldKey});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {

  int navDrawerIndex  = 0;
  @override
  Widget build(BuildContext context) {
    
    final hastNotch = MediaQuery.of(context).viewPadding.top >35; //para saber si el dispositivo tiene notch
    
    
    return NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) { //para poder cambiar la seleccion del menu
        
        setState(() {navDrawerIndex = value;});
        final menuItem = appMenuItems[value];
        context.push(menuItem.link); //push genera un stack (pila) go solo genera una nueva ubicacion
         
        //recuerda el widget para hacer la referencia de la super key de un stafulWidget
        widget.scaffoldKey.currentState?.closeDrawer();
      }, 
      children: [

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("EXIT", style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,),
        IconButton(
          
          onPressed: () => showDialog(
            context: context, // Add the required 'context' argument
            builder: (BuildContext context) { // Add the required 'builder' argument
              return AlertDialog(
                title: const Text('Cerrar sesion'),
                content: const Text('¿Estas seguro de cerrar sesion?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Si'),
                  ),
                ],
              );
            },
            
          ),
        icon: const Icon(Icons.exit_to_app_rounded),),
          ],
        ),
        
        Padding(
          padding: EdgeInsets.fromLTRB(28,hastNotch ? 10 : 20,16,10), //para darle un padding al texto en todas las direcciones all-version is better
          child: const Text("Main Options")
        ),
        ...appMenuItems
          .sublist(0,3) //para que se muestre de la primer hasta la 3 opcion de la opciones

          .map((item) => NavigationDrawerDestination(
            icon: Icon(item.icon), 
            label: Text(item.title),
             
            )
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text("More options"),
          ),

          ...appMenuItems
          .sublist(3) //para se demuestre despues del tercer elementos de las opciones
          .map((item) => NavigationDrawerDestination(
            icon: Icon(item.icon), 
            label: Text(item.title)
            )
          ),


       
      ]
    );
  }
}