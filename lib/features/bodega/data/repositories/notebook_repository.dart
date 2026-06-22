import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';
import 'package:ztech_flutter__app/features/bodega/data/services/notebook_firestore_service.dart';

class NotebookRepository {
  final NotebookFirestoreService _firestoreService = NotebookFirestoreService();
  Stream<List<NotebookModel>> getNotebooks() {
    return _firestoreService.getNotebooks();
  }

  Future<NotebookModel?> getNotebookByCodigo(String codigo) async {
    return await _firestoreService.getNotebookByCodigo(codigo);
  }

  Future<void> addNotebook(NotebookModel notebook) async {
    await _firestoreService.addNotebook(notebook);
  }

  Future<void> updateNotebook(NotebookModel updatedNotebook) async {
    await _firestoreService.updateNotebook(updatedNotebook);
  }

  Future<List<NotebookModel>> getNotebooksOnce() async {
    return await _firestoreService.getNotebooksOnce();
  }
}
