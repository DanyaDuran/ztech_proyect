import '../../domain/system_event_model.dart';
import '../services/system_event_firestore_service.dart';

class SystemEventRepository {
  final SystemEventFirestoreService _service = SystemEventFirestoreService();

  Stream<List<SystemEventModel>> getEvents() {
    return _service.getEvents();
  }

  Future<void> addEvent(SystemEventModel event) {
    return _service.addEvent(event);
  }
}
