import '../../bodega/domain/notebook_model.dart';

class VentaModel {
  final NotebookModel notebook;
  final String cliente;
  final String telefono;
  final String precio;
  final String formaPago;
  final String notas;
  final DateTime fechaVenta;

  VentaModel({
    required this.notebook,
    required this.cliente,
    required this.telefono,
    required this.precio,
    required this.formaPago,
    required this.notas,
    required this.fechaVenta,
  });
}
