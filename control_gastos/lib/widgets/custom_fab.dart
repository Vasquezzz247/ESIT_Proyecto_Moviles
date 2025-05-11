import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/gasto.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onSaved;
  final Color? backgroundColor;

  const CustomFAB({
    super.key,
    required this.onSaved,
    this.backgroundColor,
  });

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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[600],
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
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
                      onSaved();
                    }
                  },
                  child: const Text(
                    'GUARDAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: backgroundColor ?? Colors.deepPurple[600],
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onPressed: () => _mostrarFormularioGasto(context),
      child: const Icon(
        Icons.add,
        size: 28,
        color: Colors.white,
      ),
      splashColor: Colors.deepPurple[800],
    );
  }
}