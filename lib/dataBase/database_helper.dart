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
      return false;
      
    }
  }

  Future<void> closeConnection() async {
    await _connection.close();
    print("Conexión cerrada");
  }

  Future<void> insertData(String table, Map<String, dynamic> values) async {
    try {
      await _connection.query(
        'INSERT INTO $table("user", "password") VALUES (@userName, @passwordUser)',
        substitutionValues: values,
      );
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla $table');
    }
  }

  Future<List<Map<String,dynamic>>> selectData(String table) async {

  final results = await _connection.query('SELECT * FROM $table');
  List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
}

  Future<List<Map<String,dynamic>>> selectDataInventario(String table) async {

  final results = await _connection.query("""SELECT fechaencargo, fechaentrega , 
  descripcionproducto, tipoproducto FROM pedido inner join $table on
   inventarioproducto.encargado = pedido.numeropedido and pedido.estado ilike 'En espera' 
   ORDER BY fechaencargo""");
  List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
}

Future<List<Map<String,dynamic>>> selectDataClientes() async {

  final results = await _connection.query("""select nombrecompletocliente, documentocliente, descripcionproducto,
  tipoproducto 
  from cliente inner join pedido on  cliente.documentocliente = pedido.cliente inner 
  join inventarioproducto on  inventarioproducto.encargado = pedido.numeropedido and pedido.estado ilike 'En espera'""");
  List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
  print(resultMap);
    return resultMap;
}

Future<List<Map<String,dynamic>>> selectDataStock() async {

  final results = await _connection.query("""
select descripcionproducto,tipoproducto, stockproducto - COALESCE(SUM((pedido.cantidad)),0) 
AS cantidad 
from inventarioproducto
left join pedido on pedido.numeropedido = inventarioproducto.encargado
group by descripcionproducto,tipoproducto,stockproducto""");
  List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
    return resultMap;
}


Future<List<Map<String, dynamic>>> convertResultToMap(PostgreSQLResult result) async {
  // Obtener las filas del resultado
  List<Map<String, dynamic>> rows = result.map((row) => row.toColumnMap()).toList();

  // Si solo esperas una fila, puedes devolver el primer elemento de la lista
  if (rows.isNotEmpty) {
    return rows;
  } else {
    // Si no hay filas, puedes devolver un mapa vacío o lanzar una excepción según tus necesidades
    return [];
  }
}


}



