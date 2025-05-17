import 'package:control_gastos/ui/pages/detalle_gasto.dart';
import 'package:control_gastos/ui/pages/gastos_screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/gastos_provider.dart';
import 'ui/theme/app_theme.dart';
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
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routes: {
        '/': (_) => const HomePage(),
        '/gastos': (_) => const GastosPage(),
        '/detalle': (_) => const DetalleGastoPage(),
      },
    );
  }
}