import 'package:flutter/material.dart';

class StockProductos extends StatelessWidget {
  const StockProductos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
      ),
      body: const Center(
        child: Text('Stock'),
      ),
    );
  }
}