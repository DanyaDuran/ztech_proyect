import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/status_history_model.dart';

class StatusHistoryFirestoreService {
  final CollectionReference _historyCollection = FirebaseFirestore.instance
      .collection('status_history');

  Stream<List<StatusHistoryModel>> getHistory() {
    return _historyCollection
        .orderBy('fecha', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return StatusHistoryModel.fromMap(
              doc.data() as Map<String, dynamic>,
            );
          }).toList();
        });
  }

  Future<void> addHistory(StatusHistoryModel history) async {
    await _historyCollection.add(history.toMap());
  }
}
