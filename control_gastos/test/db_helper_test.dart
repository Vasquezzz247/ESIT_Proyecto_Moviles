import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:control_gastos/helpers/db_helper.dart';
import 'package:control_gastos/models/gasto.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = DBHelper();

  test('CRUD básico', () async {
    // Insertar
    final id = await db.insertarGasto(Gasto(
      descripcion: 'Test',
      categoria: 'Otros',
      monto: 10.5,
      fecha: DateTime(2025, 1, 1),
    ));
    expect(id, isNonZero);

    // Leer
    final list = await db.obtenerGastos();
    expect(list, isNotEmpty);

    // Update
    final first = list.first;
    await db.actualizarGasto(Gasto(
      id: first.id,
      descripcion: first.descripcion,
      categoria: first.categoria,
      monto: 12.0,
      fecha: first.fecha,
    ));
    final updated = (await db.obtenerGastos()).first;
    expect(updated.monto, 12.0);

    // Delete
    await db.eliminarGasto(first.id!);
    expect((await db.obtenerGastos()).length, 0);
  });
}
