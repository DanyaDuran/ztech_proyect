import 'package:cloud_firestore/cloud_firestore.dart';

class SystemEventModel {
  final String id;
  final String usuario;
  final String tipoEvento;
  final String modulo;
  final String detalle;
  final DateTime fecha;

  SystemEventModel({
    this.id = '',
    required this.usuario,
    required this.tipoEvento,
    required this.modulo,
    required this.detalle,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'usuario': usuario,
      'tipoEvento': tipoEvento,
      'modulo': modulo,
      'detalle': detalle,
      'fecha': Timestamp.fromDate(fecha),
    };
  }

  factory SystemEventModel.fromMap(Map<String, dynamic> map, String id) {
    return SystemEventModel(
      id: id,
      usuario: map['usuario'] ?? '',
      tipoEvento: map['tipoEvento'] ?? '',
      modulo: map['modulo'] ?? '',
      detalle: map['detalle'] ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
    );
  }
}
