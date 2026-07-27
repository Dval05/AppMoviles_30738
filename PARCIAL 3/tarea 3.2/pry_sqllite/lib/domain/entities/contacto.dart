//1.
class Contacto {
  final int? id;
  final String nombre;
  final String telefono;
  final String correo;

  Contacto({
    this.id,
    required this.nombre,
    required this.telefono,
    required this.correo,
  });

  factory Contacto.fromMap(Map<String, dynamic> map) {
    return Contacto(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      telefono: map['telefono'] as String,
      correo: map['correo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'correo': correo,
    };
  }
}