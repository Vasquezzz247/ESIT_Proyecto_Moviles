class Gasto {
  final int? id;
  final String descripcion;
  final String categoria;
  final double monto;
  final DateTime fecha;

  Gasto({
    this.id,
    required this.descripcion,
    required this.categoria,
    required this.monto,
    required this.fecha,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
      'categoria': categoria,
      'monto': monto,
      'fecha': fecha.toIso8601String(),
    };
  }

  // read from SQLite
  factory Gasto.fromMap(Map<String, dynamic> map) {
    return Gasto(
      id: map['id'],
      descripcion: map['descripcion'],
      categoria: map['categoria'],
      monto: map['monto'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
