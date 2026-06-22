import '../../features/auth/domain/user_model.dart';

class CurrentUser {
  static UserModel? user;

  static String? get role => user?.rol;

  static bool get isLoggedIn => user != null;

  static void login(UserModel loggedUser) {
    user = loggedUser;
  }

  static void logout() {
    user = null;
  }
}
