import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory VentaModel.fromMap(Map<String, dynamic> map) {
    final fecha = map['fechaVenta'];

    return VentaModel(
      notebook: NotebookModel.fromMap(
        Map<String, dynamic>.from(map['notebook'] ?? {}),
      ),
      cliente: map['cliente'] ?? '',
      telefono: map['telefono'] ?? '',
      precio: map['precio'] ?? '',
      formaPago: map['formaPago'] ?? '',
      notas: map['notas'] ?? '',
      fechaVenta: fecha is Timestamp
          ? fecha.toDate()
          : fecha is DateTime
          ? fecha
          : DateTime.tryParse(fecha?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notebook': notebook.toMap(),
      'codigoNotebook': notebook.codigo,
      'cliente': cliente,
      'telefono': telefono,
      'precio': precio,
      'formaPago': formaPago,
      'notas': notas,
      'fechaVenta': Timestamp.fromDate(fechaVenta),
    };
  }
}
