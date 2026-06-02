import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/system_event_model.dart';

class SystemEventFirestoreService {
  final CollectionReference events = FirebaseFirestore.instance.collection(
    'system_events',
  );

  Stream<List<SystemEventModel>> getEvents() {
    return events.orderBy('fecha', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return SystemEventModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> addEvent(SystemEventModel event) async {
    await events.add(event.toMap());
  }
}
