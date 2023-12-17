import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/config/menu/menu_items.dart';
import 'package:proyecto_bd/presentation/widgets/side_menu.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: const _HomeView(),
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      
    );
  }
}


class _HomeView extends StatelessWidget {
  const _HomeView();
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: appMenuItems.length, //cantidad de items
      
      itemBuilder: (context, index){
        final menuItem = appMenuItems[index]; //se obtiene el item
        
        return _CustomListTile(menuItem: menuItem);
      },
    ); //builder significa que va hacer en tiempo de construccion
  }
}

class _CustomListTile extends StatelessWidget {
  const _CustomListTile({
    required this.menuItem,
  });

  final MenuItem menuItem;

  
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme; //se obtiene el color del tema de la app

    return ListTile( //se crea el item
      leading:  Icon(menuItem.icon, color: colors.primary),
      trailing: Icon(Icons.arrow_forward_ios_outlined, color: colors.primary),
      title: Text(menuItem.title),
      subtitle: Text(menuItem.subTitle),
      onTap: () {

        context.push(menuItem.link); //forma 5 de navegar entre pantallas con go_router
      },
    );
  }
}