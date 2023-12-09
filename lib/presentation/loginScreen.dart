import 'package:flutter/material.dart';
import 'package:proyecto_bd/dataBase/database.dart';

class LoginScreen extends StatelessWidget {
    const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body:  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () => operation(),
              child: const Text("Login"),
            ),
            const SizedBox(width: 10,),
            FilledButton(
              onPressed: () => operation(),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}