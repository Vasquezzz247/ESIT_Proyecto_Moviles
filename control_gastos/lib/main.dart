import 'package:control_gastos/ui/pages/detalle_gasto.dart';
import 'package:control_gastos/ui/pages/gastos_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';            // ← NUEVO
import 'providers/gastos_provider.dart';            // ← NUEVO


import 'ui/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final provider = GastosProvider();
  await provider.init();
  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const ControlGastosApp(),
    ),
  );
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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/gastos': (context) => const GastosPage(),
        '/detalle': (context) => const DetalleGastoPage()
      },
    );
  }
}