import '../domain/notebook_model.dart';
import 'mock_notebooks.dart';

class NotebookRepository {

  Future<List<NotebookModel>> getNotebooks() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return mockNotebooks;
  }

  Future<NotebookModel?> getNotebookByCodigo(String codigo) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return mockNotebooks.firstWhere((notebook) => notebook.codigo == codigo);
    } catch (e) {
      return null;
    }
  }

  Future<void> addNotebook(NotebookModel notebook) async {
    await Future.delayed(const Duration(milliseconds: 400));
    mockNotebooks.add(notebook);
  }

  Future<void> updateNotebook(NotebookModel updatedNotebook) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = mockNotebooks.indexWhere((n) => n.codigo == updatedNotebook.codigo);

    if (index != -1) {
      mockNotebooks[index] = updatedNotebook;
    } else {
      throw Exception('Notebook no encontrado en el inventario');
    }
  }
}