import '../../auth/data/mock_users.dart';
import '../../auth/domain/user_model.dart';

class UserRepository {
  final List<UserModel> _users = mockUsers;

  List<UserModel> getUsers() {
    return _users;
  }

  void createUser(UserModel user) {
    _users.add(user);
  }

  void updateUser({required int index, required UserModel updatedUser}) {
    _users[index] = updatedUser;
  }

  void deleteUser(int index) {
    _users.removeAt(index);
  }

  void toggleUserStatus(int index) {
    final user = _users[index];

    _users[index] = UserModel(
      nombre: user.nombre,
      correo: user.correo,
      password: user.password,
      rol: user.rol,
      activo: !user.activo,
    );
  }

  bool emailExists(String email) {
    return _users.any((user) => user.correo == email);
  }
}
