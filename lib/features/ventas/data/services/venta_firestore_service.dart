import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/venta_model.dart';
import 'package:ztech_flutter__app/core/session/current_user.dart';
import 'package:ztech_flutter__app/features/admin/data/services/system_event_firestore_service.dart';
import 'package:ztech_flutter__app/features/admin/domain/system_event_model.dart';

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

    await SystemEventFirestoreService().addEvent(
      SystemEventModel(
        usuario: CurrentUser.user?.correo ?? 'Usuario desconocido',
        tipoEvento: 'Salida de inventario',
        modulo: 'Ventas',
        detalle: 'Se vendió el notebook ${venta.notebook.codigo}',
        fecha: DateTime.now(),
      ),
    );
  }
}
