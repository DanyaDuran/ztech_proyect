import '../../domain/status_history_model.dart';
import '../services/status_history_firestore_service.dart';

class StatusHistoryRepository {
  final StatusHistoryFirestoreService _firestoreService =
      StatusHistoryFirestoreService();

  Stream<List<StatusHistoryModel>> getHistory() {
    return _firestoreService.getHistory();
  }

  Future<void> addHistory(StatusHistoryModel history) async {
    await _firestoreService.addHistory(history);
  }
}
