class UserModel {
  final String nombre;
  final String correo;
  final String password;
  final String rol;
  final bool activo;

  UserModel({
    required this.nombre,
    required this.correo,
    required this.password,
    required this.rol,
    required this.activo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      password: map['password'] ?? '',
      rol: map['rol'] ?? 'usuario',
      activo: map['activo'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'correo': correo,
      'password': password,
      'rol': rol,
      'activo': activo,
    };
  }
}