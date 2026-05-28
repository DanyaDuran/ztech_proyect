import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/user_model.dart';

class UserFirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );

  Stream<List<UserModel>> obtenerUsuarios() {
    return users.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
      }).toList();
    });
  }

  Future<void> crearUsuarioFirestore({
    required String uid,
    required String nombre,
    required String correo,
    required String rol,
    bool activo = true,
  }) async {
    await users.doc(uid).set({
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'activo': activo,
    });
  }

  Future<void> actualizarUsuario(UserModel user) async {
    await users.doc(user.id).update(user.toMap());
  }

  Future<void> actualizarEstadoUsuario({
    required String uid,
    required bool activo,
  }) async {
    await users.doc(uid).update({'activo': activo});
  }

  Future<void> eliminarUsuarioFirestore(String uid) async {
    await users.doc(uid).delete();
  }
}
