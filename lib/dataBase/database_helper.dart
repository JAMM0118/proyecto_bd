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
      //print('Datos insertados con éxito en la tabla $table');
    } catch (e) {
      throw Exception('Error al insertar datos en la tabla $table');
    }
  }

  Future<List<Map<String,dynamic>>> selectData(String table) async {

  final results = await _connection.query('SELECT * FROM $table');
  List<Map<String, dynamic>> resultMap = await convertResultToMap(results);
  //print(resultMap);
  //print(results);
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



