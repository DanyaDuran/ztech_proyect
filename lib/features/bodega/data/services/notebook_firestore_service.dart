import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';
import 'package:ztech_flutter__app/core/session/current_user.dart';
import 'package:ztech_flutter__app/features/admin/data/services/system_event_firestore_service.dart';
import 'package:ztech_flutter__app/features/admin/domain/system_event_model.dart';

class NotebookFirestoreService {
  final CollectionReference notebooks = FirebaseFirestore.instance.collection(
    'notebooks',
  );

  Stream<List<NotebookModel>> getNotebooks() {
    return notebooks.orderBy('fechaIngreso', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return NotebookModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<NotebookModel?> getNotebookByCodigo(String codigo) async {
    final querySnapshot = await notebooks
        .where('codigo', isEqualTo: codigo)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    return NotebookModel.fromMap(
      querySnapshot.docs.first.data() as Map<String, dynamic>,
    );
  }

  Future<void> addNotebook(NotebookModel notebook) async {
    await notebooks.add(notebook.toMap());

    await SystemEventFirestoreService().addEvent(
      SystemEventModel(
        usuario: CurrentUser.user?.correo ?? 'Usuario desconocido',
        tipoEvento: 'Ingreso de inventario',
        modulo: 'Bodega',
        detalle: 'Se registró el notebook ${notebook.codigo}',
        fecha: DateTime.now(),
      ),
    );
  }

  Future<void> updateNotebook(NotebookModel notebook) async {
    final querySnapshot = await notebooks
        .where('codigo', isEqualTo: notebook.codigo)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Notebook no encontrado');
    }

    await notebooks.doc(querySnapshot.docs.first.id).update(notebook.toMap());
  }

  Future<void> updateEstadoNotebook({
    required String codigo,
    required String nuevoEstado,
  }) async {
    final querySnapshot = await notebooks
        .where('codigo', isEqualTo: codigo)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('Notebook no encontrado');
    }

    await notebooks.doc(querySnapshot.docs.first.id).update({
      'estado': nuevoEstado,
    });
  }

  Future<List<NotebookModel>> getNotebooksOnce() async {
    final snapshot = await notebooks
        .orderBy('fechaIngreso', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return NotebookModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
