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

  Future<void> deleteDataPedido(String eliminacion) async {
    try {
      await _connection.query(
        'DELETE FROM pedido WHERE "numeropedido" = @eliminacion',
        substitutionValues: {
          'eliminacion': eliminacion,
        },
      );
    } catch (e) {
      throw Exception('Error al eliminar datos en la tabla pedido');
    }
  }

  Future<void> deleteDataCliente(String eliminacion) async {
    try {
      // Primero, elimina las filas de la tabla 'telefono'
      await _connection.query(
        """DELETE FROM telefono 
           WHERE idtelefono IN (
             SELECT telefonocliente FROM cliente WHERE documentocliente = @eliminacion
           )""",
        substitutionValues: {
          'eliminacion': eliminacion,
        },
      );

      // Luego, elimina las filas de la tabla 'cliente'
      await _connection.query(
        """DELETE FROM cliente 
           WHERE documentocliente = @eliminacion""",
        substitutionValues: {
          'eliminacion': eliminacion,
        },
      );
    } catch (e) {
      throw Exception('Error al eliminar datos en la tabla cliente');
    }
  }


  Future<void> insertUser(String username, String password, String rol) async {
    try {
      await _connection.query(
        'INSERT INTO users("username", "password","rol") VALUES (@userName, @passwordUser,@rol)',
        substitutionValues: {
          'userName': username,
          'passwordUser': password,
          'rol': rol,
        },
      );
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla users');
    }
  }
  Future<void> insertRegistro(String table, String operacion) async {
    try {
      await _connection.query(
        'INSERT INTO registro("tablamodificada", "operacion") VALUES (@tabla, @operacion)',
        substitutionValues: {
          'tabla': table,
          'operacion': operacion,
        
        },
      );
      print("excelente");
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla registros');
    }
  }

  Future<void> insertDataClientes(
       String nombre, String telefono,String cedula) async {
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
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla clientes');
    }
  }

  Future<void> insertDataProducto(
      String codigo,
      String precio,
      String geneno,
      String descripcion,
      String talla,
      String colores,
      String stock,
      String tipo,
      String caracteristica,
      String materiaPrima) async {
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
      if (tipo == 'uniforme') {
        await _connection.query(
          """INSERT INTO uniforme("codigouniforme","estilouniforme", "institucion") VALUES (
          @codigouniforme,@estilouniforme,@institucion)""",
          substitutionValues: {
            'codigouniforme': codigo,
            'estilouniforme': caracteristica,
            'institucion': 'institucion $idUniforme',
          },
        );
      } else {
        await _connection.query(
          """INSERT INTO prendadevestir("codigoprenda", "estiloprenda") VALUES (@codigoprenda,@estiloprenda)""",
          substitutionValues: {
            'codigoprenda': codigo,
            'estiloprenda': caracteristica,
          },
        );
      }
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
    final results = await _connection
        .query("""SELECT nombreproveedor,unidadmedida,materiaprimasuministrada
    FROM materiaprima inner join proveedor on materiaprima.nitproveedor = proveedor.nitproveedor
    """);
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataPedidos() async {
    final results = await _connection.query(
        """SELECT fechaencargo, fechaentrega,estado,descripcionproducto,tipoproducto
    FROM pedido inner join inventarioproducto on pedido.productoencargado = inventarioproducto.codigoproducto
    """);
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataCaracteristica() async {
    final results = await _connection
        .query("""select u.institucion, u.estilouniforme, cr.caracteristica
from  caracteristicaadicional cr inner join inventarioProducto ip on 
cr.idCaracteristica=ip.caracteristica inner join uniforme u on u.codigouniforme = ip.codigoproducto 

group by u.institucion, u.estilouniforme, cr.caracteristica 
;
    """);
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<List<Map<String, dynamic>>> selectDataWhere(
      String table,
      String table2,
      String atributo,
      String atributo2,
      String atributo3,
      String necesario) async {
    final results = await _connection.query("""SELECT * FROM $table,$table2 
    
    where $table.$atributo = $table2.$atributo2 and 
    $table.$atributo3 = $necesario::character varying""");
    List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
  }

  Future<void> updateDataClientes(
      String nombreCliente, String telefono, String cedula) async {
    List<Map<String, dynamic>> results = await selectDataWhere(
        'cliente',
        'telefono',
        'telefonocliente',
        'idtelefono',
        'documentocliente',
        cedula);
    String id = results[0]['idtelefono'];
    try {
      await _connection.query(
        'UPDATE telefono SET numerotelefono = @telefono WHERE idtelefono = @id',
        substitutionValues: {
          'telefono': telefono,
          'id': id,
        },
      );
      await _connection.query(
        'UPDATE cliente SET nombrecompletocliente = @nombreCliente WHERE documentocliente = @cedula',
        substitutionValues: {
          'nombreCliente': nombreCliente,
          'cedula': cedula,
        },
      );
    } catch (e) {
      throw Exception('Error al modificar datos en la tabla clientes $e');
    }
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
    } catch (e) {
      throw Exception(
          'Error al insertar datos en la tabla materia prima y proveedor $e');
    }
  }

  Future<void> updateDataPedidos(
      String abono,
      String fechaEncargo,
      String fechaEntrega,
      String medidas,
      String estado,
      String cantidad,
      String numeropedido) async {
    try {
      await _connection
          .query("""UPDATE pedido SET abono = @abono, fechaencargo = @fechaencargo, 
        fechaentrega = @fechaentrega, anotacionmedidas = @anotacionmedidas, estado = @estado, 
        cantidad = @cantidad 
         WHERE numeropedido = @numeropedido""", substitutionValues: {
        'abono': abono,
        'fechaencargo': fechaEncargo,
        'fechaentrega': fechaEntrega,
        'anotacionmedidas': medidas,
        'estado': estado,
        'cantidad': cantidad,
        'numeropedido': numeropedido,
      });
    } catch (e) {
      throw Exception('Error al modificar datos en la tabla pedidos $e');
    }
  }

  Future<void> updateDataMateriaPrima(String tipo, String stock,
      String descripcion, String medida, String codigo) async {
    try {
      await _connection
          .query("""UPDATE materiaprima SET tipo = @tipo, stockmateriaprima = @stockmateriaprima, 
        descripcionmateriaprima = @descripcionmateriaprima, unidadmedida = @unidadmedida 
         WHERE codigomateriaprima = @codigomateriaprima""",
              substitutionValues: {
            'tipo': tipo,
            'stockmateriaprima': stock,
            'descripcionmateriaprima': descripcion,
            'unidadmedida': medida,
            'codigomateriaprima': codigo,
          });
    } catch (e) {
      throw Exception('Error al modificar datos en la tabla materia prima $e');
    }
  }

  Future<void> updateDataInventarioProducto(
      String precio,
      String genero,
      String descripcion,
      String talla,
      String color,
      String cantidad,
      String codigo) async {
    try {
      await _connection
          .query("""UPDATE inventarioproducto SET precioventa = @precioventa, genero = @genero, 
        descripcionproducto = @descripcionproducto, talla = @talla, especificacioncolor = @especificacioncolor, 
        stockproducto = @stockproducto 
         WHERE codigoproducto = @codigoproducto""", substitutionValues: {
        'precioventa': precio,
        'genero': genero,
        'descripcionproducto': descripcion,
        'talla': talla,
        'especificacioncolor': color,
        'stockproducto': cantidad,
        'codigoproducto': codigo,
      });
    } catch (e) {
      throw Exception('Error al modificar datos en la tabla pedidos $e');
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
