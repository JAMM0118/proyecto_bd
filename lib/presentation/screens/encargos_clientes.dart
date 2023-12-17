import 'package:flutter/material.dart';


class EncargosClientes extends StatelessWidget {
  const EncargosClientes({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Encargos Clientes'),
      ),
      body: const  Center(
        child: Text('Encargos Clientes'),
      ),
    );
  }
}