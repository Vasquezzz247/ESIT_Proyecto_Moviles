import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/gasto.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'gastos.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _crearTablas,
    );
  }

  Future<void> _crearTablas(Database db, int version) async {
    await db.execute('''
      CREATE TABLE gastos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        categoria TEXT NOT NULL,
        monto REAL NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertarGasto(Gasto gasto) async {
    final db = await database;
    return await db.insert('gastos', gasto.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Gasto>> obtenerGastos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gastos');

    return List.generate(maps.length, (i) => Gasto.fromMap(maps[i]));
  }

  Future<int> actualizarGasto(Gasto gasto) async {
    final db = await database;
    return await db.update('gastos', gasto.toMap(),
        where: 'id = ?', whereArgs: [gasto.id]);
  }

  Future<int> eliminarGasto(int id) async {
    final db = await database;
    return await db.delete('gastos', where: 'id = ?', whereArgs: [id]);
  }
}
