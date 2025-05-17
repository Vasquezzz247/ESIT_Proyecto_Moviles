import 'package:flutter/foundation.dart';
import '../core/db/db_helper.dart';
import '../core/models/gasto.dart';

class GastosProvider extends ChangeNotifier {
  final DBHelper _db = DBHelper();
  List<Gasto> _gastos = [];

  List<Gasto> get gastos => _gastos;
  double get total => _gastos.fold(0, (s, g) => s + g.monto);

  Future<void> init() async {
    _gastos = await _db.obtenerGastosOrdenados();
    notifyListeners();
  }

  Future<void> add(Gasto g) async {
    await _db.insertarGasto(g);
    await init();
  }

  Future<void> update(Gasto g) async {
    await _db.actualizarGasto(g);
    await init();
  }

  Future<void> remove(int id) async {
    await _db.eliminarGasto(id);
    await init();
  }
}
