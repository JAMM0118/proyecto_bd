import 'package:flutter/material.dart';

class MenuItem{
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title, 
    required this.subTitle, 
    required this.link, 
    required this.icon
    });

  
}

const appMenuItems = <MenuItem>[
    MenuItem(
    title: "Productos Encargados", 
    subTitle: "pendientes por entregar", 
    link: '/productosEncargados', 
    icon: Icons.inventory_rounded
    
    ),
    
  MenuItem(
    title: "Encargos de clientes", 
    subTitle: "pendientes por entregar", 
    link: '/clientes', 
    icon: Icons.pending_actions_rounded
    ),
  
  
  MenuItem(
    title: "Stock", 
    subTitle: "Productos en stock", 
    link: "/stock", 
    icon: Icons.inventory_2_sharp
    
    ),
  
  MenuItem(
    title: "Colegios", 
    subTitle: "Colegios en contrato", 
    link: "/colegios", 
    icon: Icons.school
    ),
    MenuItem(
    title: "Clientes", 
    subTitle: "Clientes registrados", 
    link: "/clientesRegistrados", 
    icon: Icons.person_rounded
    ),

    MenuItem(
    title: "Compras de los colegios", 
    subTitle: "productos vendidos por colegio", 
    link: "/ventasColegios", 
    icon: Icons.shopping_cart
    ),

    MenuItem(
    title: "Productos Vendidos", 
    subTitle: "Productos vendidos por cliente", 
    link: "/ventasClientes", 
    icon: Icons.sell_rounded
    
    ),
    
    MenuItem(
    title: "Ventas totales", 
    subTitle: "Ventas totales por todos los clientes", 
    link: "/ventasTotales", 
    icon: Icons.monetization_on
    
    ),
   
     MenuItem(
    title: "Ver registros", 
    subTitle: "Ver registros de la base de datos", 
    link: "/snackbdasar", 
    icon: Icons.view_list
    
    ),
  
    
    MenuItem(
    title: "Agregar Usuario", 
    subTitle: "Agregar usuario a la base de datos", 
    link: "/animated", 
    icon: Icons.person_add_alt_1_rounded
    
    ),
    MenuItem(
    title: "Consulta de datos", 
    subTitle: "Consultar datos de la base de datos", 
    link: "/noa", 
    icon: Icons.search
    
    ),

    MenuItem(
    title: "Insertar datos", 
    subTitle: "Insertar datos de la base de datos", 
    link: "/insertar", 
    icon: Icons.playlist_add
    
    ),
   
    MenuItem(
    title: "Modificar datos", 
    subTitle: "Modificar datos de la base de datos", 
    link: "/noa", 
    icon: Icons.rebase_edit
    
    ),
   
    MenuItem(
    title: "Eliminar datos", 
    subTitle: "Eliminar datos de la base de datos", 
    link: "/snackbaar", 
    icon: Icons.delete_forever
    
    ),

    
   
  
   
  
  
];