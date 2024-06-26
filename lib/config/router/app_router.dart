import 'package:go_router/go_router.dart';
import 'package:proyecto_bd/presentation/screens/agregar_usuario_formulario.dart';
import 'package:proyecto_bd/presentation/screens/clientes_registrados.dart';
import 'package:proyecto_bd/presentation/screens/colegios_contrato.dart';
import 'package:proyecto_bd/presentation/screens/consulta_formulario.dart';
import 'package:proyecto_bd/presentation/screens/eliminar_formulario.dart';
import 'package:proyecto_bd/presentation/screens/encargos_clientes.dart';
import 'package:proyecto_bd/presentation/screens/inicio_screen.dart';
import 'package:proyecto_bd/presentation/screens/insert_formulario.dart';
import 'package:proyecto_bd/presentation/screens/login_screen.dart';
import 'package:proyecto_bd/presentation/screens/modificar_formulario.dart';
import 'package:proyecto_bd/presentation/screens/pedidos_registrados.dart';
import 'package:proyecto_bd/presentation/screens/productos_encargados.dart';
import 'package:proyecto_bd/presentation/screens/proveedores.dart';
import 'package:proyecto_bd/presentation/screens/stock_productos.dart';
import 'package:proyecto_bd/presentation/screens/ventas_colegios.dart';
import 'package:proyecto_bd/presentation/screens/ventas_productos.dart';
import 'package:proyecto_bd/presentation/screens/ventas_totales.dart';
import 'package:proyecto_bd/presentation/screens/ver_registros.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path:'/', builder: (context, state) => const LoginScreen()),
    GoRoute(path:'/inicioScreen/:username/:rol', builder: (context, state) =>  InicioScreen(
      username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    )),
    GoRoute(path: '/productosEncargados', builder: (context, state) => const ProductosEncargados(
      
    )),
    GoRoute(path:'/clientes', builder: (context, state) => const EncargosClientes()),
    GoRoute(path: '/stock', builder: (context, state) => const StockProductos()),
    GoRoute(path: '/colegios', builder: (context, state) => const ColegiosContrato()),
    GoRoute(path: '/ventasColegios', builder: (context, state) => const VentasPorColegio()),
    GoRoute(path: '/ventasTotales', builder: (context, state) => const VentasTotales()),
    GoRoute(path: '/ventasClientes', builder: (context, state) => const VentasProductos()),
    GoRoute(path: '/insertar/:username/:rol', builder: (context, state) =>  FormularioInsertar(
      username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    )),
    GoRoute(path: '/clientesRegistrados', builder: (context, state) => const ClientesRegistrados()),
    GoRoute(path: '/pedidosRegistrados', builder: (context, state) => const PedidosRegistrados()),
    GoRoute(path: '/proveedores',builder: (context, state) => const Proveedores(),),
    GoRoute(path: '/modificar/:username/:rol',builder: (context, state) =>  FormularioModificar(
      username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    ),),
    GoRoute(path: '/eliminar/:username/:rol',builder: (context, state) =>  FormularioEliminar(
      username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    ),),
    GoRoute(path: '/consultar',builder: (context, state) => const FormularioConsultar(
      
    ),),
    GoRoute(path: '/usuario/:username/:rol',builder: (context, state) =>  FormularioAgregarUsuario(
      username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    ),),
    GoRoute(path: '/registros/:username/:rol',builder: (context, state) =>  FormularioRegistros(
        username: state.pathParameters['username']!, 
      rol: state.pathParameters['rol']!,
    ),),
    


   
  ]
);