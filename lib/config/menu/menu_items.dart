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
    title: "Proveedores", 
    subTitle: "Proveedroes de la empresa", 
    link: "/proveedores", 
    icon: Icons.business_outlined
    ),
    MenuItem(
    title: "Pedidos", 
    subTitle: "Todos los pedidos", 
    link: "/pedidosRegistrados", 
    icon: Icons.shopping_bag_rounded
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
    title: "Consulta de datos", 
    subTitle: "Consultar datos de la base de datos", 
    link: "/consultar", 
    icon: Icons.search
    
    ),

    MenuItem(
    title: "Insertar datos", 
    subTitle: "Insertar datos de la base de datos", 
    link: "/insertar/:username/:rol", 
    icon: Icons.playlist_add
    
    ),
    MenuItem(
    title: "Agregar Usuario", 
    subTitle: "Agregar usuario a la base de datos", 
    link: "/usuario/:username/:rol", 
    icon: Icons.person_add_alt_1_rounded
    
    ),
   
    MenuItem(
    title: "Modificar datos", 
    subTitle: "Modificar datos de la base de datos", 
    link: "/modificar/:username/:rol", 
    icon: Icons.rebase_edit
    
    ),
   
    MenuItem(
    title: "Eliminar datos", 
    subTitle: "Eliminar datos de la base de datos", 
    link: "/eliminar/:username/:rol", 
    icon: Icons.delete_forever
    
    ),
 MenuItem(
    title: "Ver registros", 
    subTitle: "Ver registros de la base de datos", 
    link: "/registros/:username/:rol", 
    icon: Icons.view_list
    
    ),
    
   
  
   
  
  
];