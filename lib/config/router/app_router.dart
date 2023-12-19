import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/presentation/screens/colegios_contrato.dart';
import 'package:proyecto_bd/presentation/screens/encargos_clientes.dart';
import 'package:proyecto_bd/presentation/screens/inicio_screen.dart';
import 'package:proyecto_bd/presentation/screens/login_screen.dart';
import 'package:proyecto_bd/presentation/screens/productos_encargados.dart';
import 'package:proyecto_bd/presentation/screens/stock_productos.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path:'/', builder: (context, state) => const LoginScreen()),
    GoRoute(path:'/inicioScreen', builder: (context, state) => const InicioScreen()),
    GoRoute(path: '/productosEncargados', builder: (context, state) => const ProductosEncargados()),
    GoRoute(path:'/clientes', builder: (context, state) => const EncargosClientes()),
    GoRoute(path: '/stock', builder: (context, state) => const StockProductos()),
    GoRoute(path: '/colegios', builder: (context, state) => const ColegiosContrato()),
    


   
  ]
);