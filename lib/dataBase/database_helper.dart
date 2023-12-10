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
      print('Conexión establecida con éxito');
      return true;
    } catch (e) {
      print('Error al abrir la conexión: $e');
      return false;
    }
  }

  Future<void> closeConnection() async {
    await _connection.close();
    print('Conexión cerrada');
  }

  Future<void> insertData(String table, Map<String, dynamic> values) async {
    try {
      await _connection.query(
        'INSERT INTO $table("user", "password") VALUES (@userName, @passwordUser)',
        substitutionValues: values,
      );
      //print('Datos insertados con éxito en la tabla $table');
    } catch (e) {
      print('Error al insertar datos en la tabla $table: $e');
    }
  }

  // Agrega funciones para update y delete según sea necesario
}

void main() async {
  

  
}
