import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/presentation/screens/clientes_registrados.dart';
import 'package:proyecto_bd/presentation/screens/colegios_contrato.dart';
import 'package:proyecto_bd/presentation/screens/encargos_clientes.dart';
import 'package:proyecto_bd/presentation/screens/inicio_screen.dart';
import 'package:proyecto_bd/presentation/screens/insert_formulario.dart';
import 'package:proyecto_bd/presentation/screens/login_screen.dart';
import 'package:proyecto_bd/presentation/screens/pedidos_registrados.dart';
import 'package:proyecto_bd/presentation/screens/productos_encargados.dart';
import 'package:proyecto_bd/presentation/screens/proveedores.dart';
import 'package:proyecto_bd/presentation/screens/stock_productos.dart';
import 'package:proyecto_bd/presentation/screens/ventas_colegios.dart';
import 'package:proyecto_bd/presentation/screens/ventas_productos.dart';
import 'package:proyecto_bd/presentation/screens/ventas_totales.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path:'/', builder: (context, state) => const LoginScreen()),
    GoRoute(path:'/inicioScreen', builder: (context, state) => const InicioScreen()),
    GoRoute(path: '/productosEncargados', builder: (context, state) => const ProductosEncargados()),
    GoRoute(path:'/clientes', builder: (context, state) => const EncargosClientes()),
    GoRoute(path: '/stock', builder: (context, state) => const StockProductos()),
    GoRoute(path: '/colegios', builder: (context, state) => const ColegiosContrato()),
    GoRoute(path: '/ventasColegios', builder: (context, state) => const VentasPorColegio()),
    GoRoute(path: '/ventasTotales', builder: (context, state) => const VentasTotales()),
    GoRoute(path: '/ventasClientes', builder: (context, state) => const VentasProductos()),
    GoRoute(path: '/insertar', builder: (context, state) => const FormularioInsertar()),
    GoRoute(path: '/clientesRegistrados', builder: (context, state) => const ClientesRegistrados()),
    GoRoute(path: '/pedidosRegistrados', builder: (context, state) => const PedidosRegistrados()),
    GoRoute(path: '/proveedores',builder: (context, state) => const Proveedores(),)
    


   
  ]
);