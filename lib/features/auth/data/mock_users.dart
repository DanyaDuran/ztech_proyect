import '../domain/user_model.dart';

final List<UserModel> mockUsers = [
  UserModel(
    nombre: 'Super Usuario',
    correo: 'super@ztech.cl',
    password: 'password123',
    rol: 'superusuario',
    activo: true,
  ),
  UserModel(
    nombre: 'Administrador ZTech',
    correo: 'admin@ztech.cl',
    password: 'password123',
    rol: 'admin',
    activo: true,
  ),
  UserModel(
    nombre: 'Encargado de Bodega',
    correo: 'bodega@ztech.cl',
    password: 'password123',
    rol: 'bodega',
    activo: true,
  ),
  UserModel(
    nombre: 'Técnico Reparación',
    correo: 'tecnico@ztech.cl',
    password: 'password123',
    rol: 'tecnico',
    activo: true,
  ),
  UserModel(
    nombre: 'Encargada de Ventas',
    correo: 'ventas@ztech.cl',
    password: 'password123',
    rol: 'ventas',
    activo: true,
  ),
];