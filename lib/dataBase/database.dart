import 'package:postgres/postgres.dart';

Future operation() async{
    final connection = await Connection.open(Endpoint(
      host: "monorail.proxy.rlwy.net", database: "railway",
      username:"postgres", port:31218 ,password: "4gb5CFaFFAFa5d5E-EeAB*E1f55c1G-c" )
      );

    try {
      final  result =  connection.isOpen;
      print("Connection is open: $result");
      // final prueba = await connection.execute(
      //   Sql.named("SELECT * FROM prueba where name = @name"),
      //   parameters: {"name": "nameTest"}
      //   );
      // print((prueba.toString()));
    } catch (e) {
      print("Could not connect to the server: $e");
    } 

  }