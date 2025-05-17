import 'package:flutter/material.dart';
import '../../core/db/db_helper.dart';
import '../widgets/custom_bottom_navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _totalGastado = 0.0;

  Future<void> _cargarTotal() async {
    final total = await DBHelper().obtenerTotalGastos();
    setState(() {
      _totalGastado = total;
    });
  }

  @override
  void initState() {
    super.initState();
    _cargarTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Fondo suave
      appBar: null,
      body: Column(
        children: [
          // Encabezado estilizado
          Container(
            padding: const EdgeInsets.only(top: 70, bottom: 30),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'ESTADO DE GASTOS',
                  style: TextStyle(
                    fontSize: 32, // Más grande
                    fontWeight: FontWeight.w900, // Más grueso
                    color: Colors.deepPurple[800], // Color elegante
                    letterSpacing: 1.5, // Espaciado entre letras
                    fontFamily: 'RobotoCondensed', // Tipografía moderna
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.deepPurple[200]!.withOpacity(0.8),
                  thickness: 3,
                  height: 2,
                  indent: 40,
                  endIndent: 40,
                ),
              ],
            ),
          ),

          // Tarjeta con nuevo diseño
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                color: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: Colors.deepPurple[100]!,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TOTAL GASTADO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$${_totalGastado.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800],
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 4,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/gastos');
          }
        },
      ),
    );
  }
}