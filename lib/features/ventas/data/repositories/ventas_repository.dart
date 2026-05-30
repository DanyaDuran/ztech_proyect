import '../../domain/venta_model.dart';
import '../services/venta_firestore_service.dart';

class VentaRepository {
  final VentaFirestoreService _firestoreService = VentaFirestoreService();

  Stream<List<VentaModel>> getVentas() {
    return _firestoreService.getVentas();
  }

  Future<void> addVenta(VentaModel venta) async {
    await _firestoreService.addVenta(venta);
  }
}
