class AppValidators {
  static String? email(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'El correo es obligatorio';
    }

    if (!email.contains('@') || !email.contains('.')) {
      return 'Ingresa un correo válido';
    }

    return null;
  }

  static String? password(String? value) {
    final password = value?.trim() ?? '';

    if (password.isEmpty) {
      return 'La contraseña es obligatoria';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener mínimo 8 caracteres';
    }

    return null;
  }
}
