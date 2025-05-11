import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/gasto.dart';
import '../widgets/custom_action_button.dart';
import '../widgets/custom_bottom_navbar.dart';
import '../widgets/gasto_card.dart';
import '../widgets/custom_fab.dart';

class gastosPage extends StatefulWidget {
  const gastosPage({super.key});

  @override
  State<gastosPage> createState() => _gastosPageState();
}

class _gastosPageState extends State<gastosPage> {
  List<Gasto> _gastos = [];
  bool _isLoading = true;

  void _mostrarFormularioGasto(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _descripcionController = TextEditingController();
    final _categoriaController = TextEditingController();
    final _montoController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 3,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'AGREGAR GASTO',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: Colors.deepPurple[200],
                  thickness: 2,
                  height: 1,
                  indent: 40,
                  endIndent: 40,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple[400]!),
                    ),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Este campo es requerido' : null,
                ),
                TextFormField(
                  controller: _categoriaController,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple[400]!),
                    ),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Este campo es requerido' : null,
                ),
                TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Monto',
                    labelStyle: TextStyle(color: Colors.grey[700]),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple[400]!),
                    ),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Este campo es requerido' : null,
                ),
                const SizedBox(height: 30),
                CustomActionButton(
                  label: 'GUARDAR',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final nuevoGasto = Gasto(
                        descripcion: _descripcionController.text,
                        categoria: _categoriaController.text,
                        monto: double.parse(_montoController.text),
                        fecha: DateTime.now(),
                      );

                      await DBHelper().insertarGasto(nuevoGasto);
                      Navigator.pop(context);
                      await _cargarGastos(); // recarga inmediata
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    setState(() => _isLoading = true);
    final gastos = await DBHelper().obtenerGastosOrdenados();
    setState(() {
      _gastos = gastos;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: null,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 70, bottom: 25),
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  'MOVIMIENTOS',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.deepPurple[800],
                    letterSpacing: 1.5,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
                const SizedBox(height: 15),
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

          // Lista de gastos
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple[400],
              ),
            )
                : _gastos.isEmpty
                ? Center(
              child: Text(
                'No hay gastos registrados',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: _gastos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: GastoCard(
                    gasto: _gastos[index],
                    onTap: () async {
                      final wasUpdated = await Navigator.pushNamed(
                        context,
                        '/detalle',
                        arguments: _gastos[index],
                      );

                      if (wasUpdated == true) {
                        await _cargarGastos();
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: CustomFAB(
        backgroundColor: Colors.deepPurple[600],
        onSaved: _cargarGastos,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
      ),
    );
  }
}
