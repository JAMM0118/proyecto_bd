import 'package:flutter/material.dart';
import 'package:formulario/widgets/formulario.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: const Formulario()
    );
  }
}