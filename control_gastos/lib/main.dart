import 'package:flutter/material.dart';

void main() {
  runApp(const ControlGastosApp());
}

class ControlGastosApp extends StatelessWidget {
  const ControlGastosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Control de Gastos'),
        ),
        body: const Center(
          child: Text('¡Bienvenido! Aquí irá la lista de gastos.'),
        ),
      ),
    );
  }
}
