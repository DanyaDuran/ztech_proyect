import '../domain/user_model.dart';

final List<UserModel> mockUsers = [
  UserModel(
    nombre: 'Administrador ZTech',
    correo: 'admin@ztech.cl',
    password: '12345678',
    rol: 'admin',
    activo: true,
  ),
  UserModel(
    nombre: 'Super Usuario',
    correo: 'super@ztech.cl',
    password: '12345678',
    rol: 'superusuario',
    activo: true,
  ),
  UserModel(
    nombre: 'Encargado de Bodega',
    correo: 'bodega@ztech.cl',
    password: '12345678',
    rol: 'bodega',
    activo: true,
  ),
  UserModel(
    nombre: 'Técnico Reparación',
    correo: 'tecnico@ztech.cl',
    password: '12345678',
    rol: 'tecnico',
    activo: true,
  ),
  UserModel(
    nombre: 'Encargada de Ventas',
    correo: 'ventas@ztech.cl',
    password: '12345678',
    rol: 'ventas',
    activo: true,
  ),
];
