import '../../auth/domain/user_model.dart';

class UserService {
  final List<String> allowedRoles = ['admin', 'bodega', 'tecnico', 'ventas'];

  String? validateUser({
    required String nombre,
    required String correo,
    required String rol,
    String? password,
    bool isEditing = false,
  }) {
    if (nombre.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }

    if (nombre.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (correo.trim().isEmpty) {
      return 'El correo es obligatorio';
    }

    if (!correo.contains('@')) {
      return 'Correo inválido';
    }

    if (!isEditing && (password == null || password.trim().length < 6)) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    if (!allowedRoles.contains(rol)) {
      return 'Rol no permitido';
    }

    return null;
  }

  String? validateUpdate(UserModel user) {
    return validateUser(
      nombre: user.nombre,
      correo: user.correo,
      rol: user.rol,
      isEditing: true,
    );
  }
}
