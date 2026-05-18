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

  static String? requiredField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'El campo $fieldName es obligatorio';
    }

    return null;
  }

  static String? codigoNotebook(String? value) {
    final code = value?.trim() ?? '';

    if (code.isEmpty) {
      return 'El código es obligatorio';
    }

    if (!RegExp(r'^[A-Z]{2,4}-\d{3,4}$').hasMatch(code)) {
      return 'Formato inválido. Use Ej: ZT-001 o NB-105';
    }

    return null;
  }

  static String? modeloSerie(String? value) {
    final model = value?.trim() ?? '';

    if (model.isEmpty) {
      return 'El modelo es obligatorio';
    }

    if (!RegExp(r'^[A-Z]{1}\d{6}$').hasMatch(model)) {
      return 'Formato inválido. Ej: T123456';
    }

    return null;
  }

  static String? modeloNotebook(String? value) {
    final model = value?.trim() ?? '';

    if (model.isEmpty) {
      return 'El modelo es obligatorio';
    }

    if (model.length < 2) {
      return 'El modelo debe tener al menos 2 caracteres';
    }

    if (model.length > 50) {
      return 'El modelo es demasiado largo';
    }

    return null;
  }

  static String? descripcionOpcional(String? value, String fieldName) {
    final text = value?.trim() ?? '';

    if (text.isNotEmpty && text.length < 10) {
      return '$fieldName debe tener al menos 10 caracteres';
    }

    return null;
  }
}
