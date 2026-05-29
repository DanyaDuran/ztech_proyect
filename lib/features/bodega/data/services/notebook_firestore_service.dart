import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';

class NotebookFirestoreService {
  final CollectionReference notebooks = FirebaseFirestore.instance.collection(
    'notebooks',
  );
  Stream<List<NotebookModel>> getNotebooks() {
    return notebooks.snapshots().map((snapshot) {
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

  Future<List<NotebookModel>> getNotebooksOnce() async {
    final snapshot = await notebooks.get();
    return snapshot.docs.map((doc) {
      return NotebookModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
