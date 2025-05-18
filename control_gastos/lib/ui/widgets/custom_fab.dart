import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/db/db_helper.dart';
import '../../core/models/gasto.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onSaved;
  final Color? backgroundColor;

  const CustomFAB({
    super.key,
    required this.onSaved,
    this.backgroundColor,
  });

  void _mostrarFormularioGasto(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final descCtrl = TextEditingController();
    final categoriaCtrl = TextEditingController(text: 'Otros');
    final montoCtrl = TextEditingController();
    DateTime fechaSeleccion = DateTime.now();
    final deepPurple = Colors.deepPurple[800]!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              boxShadow: [
                BoxShadow(
                  color: deepPurple.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'AGREGAR GASTO',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: deepPurple.withOpacity(0.5), thickness: 2, indent: 40, endIndent: 40),
                  const SizedBox(height: 24),

                  // Descripción
                  TextFormField(
                    controller: descCtrl,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      filled: true,
                      focusColor: deepPurple,
                    ),
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),

                  // Categoría (Dropdown)
                  DropdownButtonFormField<String>(
                    value: categoriaCtrl.text,
                    items: const [
                      'Alimentación',
                      'Transporte',
                      'Ocio',
                      'Otros',
                    ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    decoration: InputDecoration(
                      labelText: 'Categoría',
                      filled: true,
                      focusColor: deepPurple,
                    ),
                    dropdownColor: Theme.of(context).colorScheme.surface,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    onChanged: (v) => categoriaCtrl.text = v!,
                  ),
                  const SizedBox(height: 12),

                  // Monto
                  TextFormField(
                    controller: montoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      prefixText: '\$ ',
                      filled: true,
                      focusColor: deepPurple,
                    ),
                    validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 12),

                  // Fecha
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.date_range),
                    label: Text(DateFormat('dd/MM/yyyy').format(fechaSeleccion)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fechaSeleccion,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        fechaSeleccion = picked;
                        (context as Element).markNeedsBuild();
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Botón guardar
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final nuevo = Gasto(
                          descripcion: descCtrl.text,
                          categoria: categoriaCtrl.text,
                          monto: double.parse(montoCtrl.text),
                          fecha: fechaSeleccion,
                        );
                        await DBHelper().insertarGasto(nuevo);
                        if (context.mounted) Navigator.pop(context);
                        onSaved();
                      }
                    },
                    child: const Text(
                      'GUARDAR',
                      style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'fab',
      backgroundColor: Colors.deepPurple[800],
      onPressed: () => _mostrarFormularioGasto(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(
        Icons.add,
        size: 28,
        color: Colors.white,
      ),
    );
  }
}