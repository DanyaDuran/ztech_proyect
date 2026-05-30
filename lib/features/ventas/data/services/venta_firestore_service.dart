import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/venta_model.dart';

class VentaFirestoreService {
  final CollectionReference ventas = FirebaseFirestore.instance.collection(
    'ventas',
  );

  Stream<List<VentaModel>> getVentas() {
    return ventas.orderBy('fechaVenta', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return VentaModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addVenta(VentaModel venta) async {
    await ventas.add(venta.toMap());
  }
}
