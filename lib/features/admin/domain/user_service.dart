import '../../auth/domain/user_model.dart';
import '../data/user_repository.dart';

class UserService {
  final UserRepository repository;

  UserService(this.repository);

  final List<String> allowedRoles = ['admin', 'bodega', 'tecnico', 'ventas'];

  String? validateUser(UserModel user) {
    if (user.nombre.trim().isEmpty) {
      return 'El nombre es obligatorio';
    }

    if (user.nombre.trim().length < 3) {
      return 'El nombre debe tener al menos 3 caracteres';
    }

    if (user.correo.trim().isEmpty) {
      return 'El correo es obligatorio';
    }

    if (!user.correo.contains('@')) {
      return 'Correo inválido';
    }

    if (repository.emailExists(user.correo)) {
      return 'El correo ya existe';
    }

    if (user.password.trim().length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }

    if (!allowedRoles.contains(user.rol)) {
      return 'Rol no permitido';
    }

    if (user.rol == 'superusuario') {
      return 'No se puede crear otro superusuario';
    }

    return null;
  }

  List<UserModel> getUsers() {
    return repository.getUsers();
  }

  bool createUser(UserModel user) {
    final validation = validateUser(user);

    if (validation != null) {
      return false;
    }

    repository.createUser(user);

    return true;
  }

  void updateUser({required int index, required UserModel updatedUser}) {
    repository.updateUser(index: index, updatedUser: updatedUser);
  }

  void deleteUser(int index) {
    repository.deleteUser(index);
  }

  void toggleUserStatus(int index) {
    repository.toggleUserStatus(index);
  }
}
