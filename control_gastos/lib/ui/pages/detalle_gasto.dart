import 'package:flutter/material.dart';
import '../../core/models/gasto.dart';
import '../../core/db/db_helper.dart';
import '../widgets/custom_action_button.dart';

class DetalleGastoPage extends StatefulWidget {
  const DetalleGastoPage({super.key});

  @override
  State<DetalleGastoPage> createState() => _DetalleGastoPageState();
}

class _DetalleGastoPageState extends State<DetalleGastoPage> {
  late Gasto gasto;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args is Gasto) {
      gasto = args;
    }
  }

  void _mostrarFormularioEdicion(BuildContext context) {
    final _descripcionController = TextEditingController(text: gasto.descripcion);
    final _categoriaController = TextEditingController(text: gasto.categoria);
    final _montoController = TextEditingController(text: gasto.monto.toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'EDITAR GASTO',
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
                      ),
                      validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    TextFormField(
                      controller: _categoriaController,
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    TextFormField(
                      controller: _montoController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Monto',
                        labelStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: (value) => value!.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 30),
                    CustomActionButton(
                      label: 'GUARDAR CAMBIOS',
                      onPressed: () async {
                        if (_descripcionController.text.isEmpty ||
                            _categoriaController.text.isEmpty ||
                            _montoController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Todos los campos son requeridos')),
                          );
                          return;
                        }

                        setModalState(() => _isLoading = true);
                        try {
                          final gastoActualizado = Gasto(
                            id: gasto.id,
                            descripcion: _descripcionController.text,
                            categoria: _categoriaController.text,
                            monto: double.parse(_montoController.text),
                            fecha: gasto.fecha,
                          );

                          await DBHelper().actualizarGasto(gastoActualizado);
                          if (mounted) {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al actualizar: ${e.toString()}')),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setModalState(() => _isLoading = false);
                          }
                        }
                      },
                      backgroundColor: Colors.deepPurple[800]!,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETALLE DEL GASTO',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Sin cambios
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 30),
            Text('Descripción: ${gasto.descripcion}', style: _infoStyle()),
            Text('Categoría: ${gasto.categoria}', style: _infoStyle()),
            Text('Monto: \$${gasto.monto.toStringAsFixed(2)}', style: _infoStyle()),
            Text('Fecha: ${gasto.fecha.toLocal().toString().split(' ')[0]}', style: _infoStyle()),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: CustomActionButton(
                    label: 'EDITAR',
                    onPressed: () => _mostrarFormularioEdicion(context),
                    backgroundColor: Colors.deepPurple[800]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomActionButton(
                    label: 'ELIMINAR',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: const Text('¿Estás seguro de eliminar este gasto?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Eliminar'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await DBHelper().eliminarGasto(gasto.id!);
                        if (mounted) {
                          Navigator.pop(context, true);
                        }
                      }
                    },
                    backgroundColor: Colors.red[400]!,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextStyle _infoStyle() => const TextStyle(fontSize: 18, height: 1.5);
}