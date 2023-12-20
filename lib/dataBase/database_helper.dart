import 'package:postgres/postgres.dart';

class DatabaseHelper {
  late PostgreSQLConnection _connection;

  DatabaseHelper({
    required String host,
    required int port,
    required String databaseName,
    required String username,
    required String password,
  }) {
    _connection = PostgreSQLConnection(
      host,
      port,
      databaseName,
      username: username,
      password: password,
    );
  }

  Future<bool> openConnection() async {
    try {
      await _connection.open();
      print("Conexión exitosa");
      return true;
    } catch (e) {
      print("Error al abrir la conexión");
      return false;
    }
  }

  Future<void> closeConnection() async {
    await _connection.close();
    print("Conexión cerrada");
  }

  // Future<void> insertData(String table, Map<String, dynamic> values) async {
  //   try {
  //     await _connection.query(
  //       'INSERT INTO $table("user", "password") VALUES (@userName, @passwordUser)',
  //       substitutionValues: values,
  //     );
  //   } catch (e) {
  //     throw Exception('Error al insertar datos en la tabla $table');
  //   }
  // }

  Future<void> insertDataClientes(
      String cedula, String nombre, String telefono) async {
    final results = await selectData('telefono');
    final length = results.length + 1;
    final id = length.toString();
    try {
      await _connection.query(
          'INSERT INTO telefono("idtelefono","numerotelefono") VALUES (@idtelefono,@numerotelefono)',
          substitutionValues: {
            'idtelefono': id,
            'numerotelefono': telefono,
          });
      await _connection.query(
        'INSERT INTO cliente("documentocliente", "nombrecompletocliente","telefonocliente") VALUES (@documentocliente,@nombrecompletocliente, @telefonocliente)',
        substitutionValues: {
          'documentocliente': cedula,
          'nombrecompletocliente': nombre,
          'telefonocliente': id,
        },
      );
      print("Cliente insertado");
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla clientes');
    }
  }

Future<void> insertDataProducto( String codigo, String precio, String geneno,String descripcion, String talla,
String colores, String stock, String tipo, String caracteristica, String materiaPrima) async {
    final results = await selectData('caracteristicaadicional');
    final length = results.length + 1;
    final id = length.toString();

    final resulsUniforme = await selectData('uniforme');
    final lengthUniforme = resulsUniforme.length + 1;
    final idUniforme = lengthUniforme.toString();
    try {
      await _connection.query(
          'INSERT INTO caracteristicaadicional("idcaracteristica","caracteristica") VALUES (@idcaracteristica,@caracteristica)',
          substitutionValues: {
            'idcaracteristica': id,
            'caracteristica': caracteristica,
          });
      await _connection.query(
        """INSERT INTO inventarioproducto("codigoproducto", "precioventa","genero",
        "descripcionproducto","talla","especificacioncolor","stockproducto","tipoproducto",
        "caracteristica","materiaprima") VALUES (@codigoproducto,@precioventa,@genero,@descripcionproducto,@talla,
        @especificacioncolor,
        @stockproducto,@tipoproducto,
        @caracteristica, @materiaprima)""",
        substitutionValues: {
          'codigoproducto': codigo,
          'precioventa': precio,
          'genero': geneno,
          'descripcionproducto': descripcion,
          'talla': talla,
          'especificacioncolor': colores,
          'stockproducto': stock,
          'tipoproducto': tipo == 'uniforme' ? 'uniforme' : 'prendavestir',
          'caracteristica': id,
          'materiaprima': materiaPrima,
        },
      );
      if(tipo == 'uniforme'){
        await _connection.query(
        """INSERT INTO uniforme("codigouniforme","estilouniforme", "institucion") VALUES (
          @codigouniforme,@estilouniforme,@institucion)""",
        substitutionValues: {
          'codigouniforme': codigo,
          'estilouniforme': caracteristica,
          'institucion': 'institucion $idUniforme',
        },
      );
      }else{
        await _connection.query(
        """INSERT INTO prendadevestir("codigoprenda", "estiloprenda") VALUES (@codigoprenda,@estiloprenda)""",
        substitutionValues: {
          'codigoprenda': codigo,
          'estiloprenda': caracteristica,
        },
      );
      }
      print("producto insertado");
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla clientes');
    }
  }

  Future<List<Map<String, dynamic>>> selectData(String table) async {
    final results = await _connection.query('SELECT * FROM $table');
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataProveedores() async {
    final results = await _connection.query("""SELECT nombreproveedor,unidadmedida,materiaprimasuministrada
    FROM materiaprima inner join proveedor on materiaprima.nitproveedor = proveedor.nitproveedor
    """);
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataPedidos() async {
    final results = await _connection.query("""SELECT fechaencargo, fechaentrega,estado,descripcionproducto,tipoproducto
    FROM pedido inner join inventarioproducto on pedido.productoencargado = inventarioproducto.codigoproducto
    """);
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }


  Future<void> insertDataMateriaPrima(
      String codigo,
      String tipo,
      String stock,
      String descripcion,
      String medida,
      String nit,
      String nombre,
      String direccion,
      String telefono,
      String suministro) async {
    final results = await selectData('materiaprima');
    final length = results.length + 1;
    final id = length.toString();

    try {
      await _connection
          .query("""INSERT INTO proveedor("nitproveedor","nombreproveedor",
        "direccionproveedor","telefonoproveedor","materiaprimasuministrada") VALUES (@nitproveedor,@nombreproveedor,@direccionproveedor,
        @telefonoproveedor,@materiaprimasuministrada)""", substitutionValues: {
        'nitproveedor': nit,
        'direccionproveedor': direccion,
        'nombreproveedor': nombre,
        'telefonoproveedor': telefono,
        'materiaprimasuministrada': suministro,
      });
      await _connection.query(
        """INSERT INTO materiaprima("codigomateriaprima", "tipo","stockmateriaprima","descripcionmateriaprima",
        "unidadmedida","nitproveedor" ) VALUES (@codigomateriaprima,@tipo, @stockmateriaprima,@descripcionmateriaprima,@unidadmedida, @nitproveedor)""",
        substitutionValues: {
          'codigomateriaprima': id,
          'tipo': tipo,
          'stockmateriaprima': stock,
          'descripcionmateriaprima': descripcion,
          'unidadmedida': medida,
          'nitproveedor': nit,
        },
      );
      print("Materia prima y proveedor insertado");
    } catch (e) {
      throw Exception(
          'Error al insertar datos en la tabla materia prima y proveedor $e');
    }
  }

  Future<void> insertDataPedido(
      String numero,
      String abono,
      String fechaEncargo,
      String fechaEntrega,
      String medidas,
      String estado,
      String cliente,
      String cantidad,
      String producto) async {
    final results = await selectData('pedido');
    final length = results.length + 1;
    final id = length.toString();

    try {
      await _connection.query("""INSERT INTO pedido("numeropedido","abono",
        "fechaencargo","fechaentrega","anotacionmedidas","estado","cliente","cantidad","productoencargado") 
        VALUES (@numeropedido,@abono,@fechaencargo,
        @fechaentrega,@anotacionmedidas,@estado,@cliente,@cantidad,@productoencargado)""",
          substitutionValues: {
            'numeropedido': id,
            'abono': abono,
            'fechaencargo': fechaEncargo,
            'fechaentrega': fechaEntrega,
            'anotacionmedidas': medidas,
            'estado': estado,
            'cliente': cliente,
            'cantidad': cantidad,
            'productoencargado': producto,
          });
      print("pedido insertado");
    } catch (e) {
      throw Exception(
          'Error al insertar datos en la tabla materia prima y proveedor $e');
    }
  }

  Future<List<Map<String, dynamic>>> selectDataClientesRegistrados() async {
    final results = await _connection.query("""
Select c.documentocliente,c.nombrecompletocliente,t.numerotelefono 
from cliente c inner join telefono t on c.telefonocliente = t.idtelefono
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataInventario() async {
    final results =
        await _connection.query("""SELECT fechaencargo, fechaentrega , 
  descripcionproducto, tipoproducto FROM pedido inner join inventarioproducto on
   inventarioproducto.codigoproducto = pedido.productoencargado and pedido.estado ilike 'En espera' 
   ORDER BY fechaencargo
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataClientes() async {
    final results = await _connection.query(
        """select nombrecompletocliente, documentocliente, descripcionproducto,
  tipoproducto 
  from cliente inner join pedido on  cliente.documentocliente = pedido.cliente inner 
  join inventarioproducto on  inventarioproducto.codigoproducto = pedido.productoencargado and pedido.estado ilike 'En espera'
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataVentasColegios() async {
    final results = await _connection.query("""SELECT
    u.institucion AS institucion,
    ip.descripcionProducto AS producto,
    p.fechaencargo as fecha_entrega,
    ip.precioVenta AS precio_unitario,
	SUM(p.cantidad) AS cantidad_vendida,
    SUM(p.cantidad * ip.precioVenta) AS total_venta
FROM
    pedido p inner join inventarioProducto ip ON 
p.productoencargado = ip.codigoproducto inner JOIN uniforme u ON 
u.codigoUniforme = ip.codigoProducto
WHERE p.estado ilike 'Entregado'
GROUP BY u.institucion, ip.descripcionProducto,
    p.fechaencargo, ip.precioVenta;
;
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataVentasTotalUniforme() async {
    final results = await _connection.query("""SELECT
    SUM(p.cantidad * ip.precioVenta) AS total_ventas
FROM
    pedido p inner join inventarioProducto ip ON 
p.productoencargado = ip.codigoproducto
WHERE
    (p.estado ilike 'Entregado') and ip.tipoproducto ilike 'uniforme';

""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataVentasTotalPrenda() async {
    final results = await _connection.query("""SELECT
    SUM(p.cantidad * ip.precioVenta) AS total_ventas
FROM
    pedido p inner join inventarioProducto ip ON 
p.productoencargado = ip.codigoproducto
WHERE
    (p.estado ilike 'Entregado') and ip.tipoproducto ilike 'prendavestir';
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataVentasPrendasVestir() async {
    final results = await _connection.query("""SELECT
    
    c.nombrecompletocliente AS cliente,
    c.documentocliente AS cedula,
    ip.descripcionProducto AS producto,
	p.fechaencargo as fecha_entrega,
    ip.precioVenta AS precio_unitario,
	SUM(p.cantidad) AS cantidad_vendida,
    SUM(p.cantidad * ip.precioVenta) AS total_venta
FROM
    cliente c inner join pedido p on 
c.documentocliente=p.cliente
inner join inventarioProducto ip ON 
p.productoencargado = ip.codigoproducto
WHERE p.estado ilike 'Entregado'
GROUP BY c.nombrecompletocliente,c.documentocliente, ip.descripcionProducto, ip.precioVenta,p.fechaencargo;
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataStock() async {
    final results = await _connection.query(
        """select descripcionproducto,tipoproducto, stockproducto - COALESCE(SUM((pedido.cantidad)),0) 
AS cantidad 
from inventarioproducto
left join pedido on pedido.productoencargado = inventarioproducto.codigoproducto and
pedido.estado ilike 'Entregado'
group by descripcionproducto,tipoproducto,stockproducto
""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataTotalVentas() async {
    final results = await _connection.query("""SELECT
    SUM(p.cantidad * ip.precioVenta) AS total_ventas
FROM
    pedido p inner join inventarioProducto ip ON 
p.productoencargado = ip.codigoproducto
WHERE
    p.estado ilike 'Entregado';


""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> convertResultToMap(
      PostgreSQLResult result) async {
    // Obtener las filas del resultado
    List<Map<String, dynamic>> rows =
        result.map((row) => row.toColumnMap()).toList();

    // Si solo esperas una fila, puedes devolver el primer elemento de la lista
    if (rows.isNotEmpty) {
      return rows;
    } else {
      // Si no hay filas, puedes devolver un mapa vacío o lanzar una excepción según tus necesidades
      return [];
    }
  }
}
