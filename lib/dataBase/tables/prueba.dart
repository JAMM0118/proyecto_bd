class Prueba{
  String user;
  String password;
  Prueba({required this.user,required this.password});


  Prueba.fromMap(Map<String, dynamic> map)
      : user = map['userName'],
        password = map['passwordUser'];

  Map<String, dynamic> toMap(){
    return {
      'userName': user,
      'passwordUser': password,
    };
  }
}