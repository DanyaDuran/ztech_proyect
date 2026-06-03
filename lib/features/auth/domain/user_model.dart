class UserModel {
  final String id;
  final String nombre;
  final String correo;
  final String rol;
  final bool activo;

  UserModel({
    this.id = '',
    required this.nombre,
    required this.correo,
    required this.rol,
    required this.activo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return UserModel(
      id: id,
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      rol: map['rol'] ?? 'usuario',
      activo: map['activo'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'correo': correo, 'rol': rol, 'activo': activo};
  }
}
