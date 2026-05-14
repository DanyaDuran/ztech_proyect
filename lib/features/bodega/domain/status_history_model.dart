class StatusHistoryModel {
  final String codigoNotebook;
  final String estadoAnterior;
  final String estadoNuevo;
  final String usuarioResponsable;
  final DateTime fecha;
  final String observacion;

  StatusHistoryModel({
    required this.codigoNotebook,
    required this.estadoAnterior,
    required this.estadoNuevo,
    required this.usuarioResponsable,
    required this.fecha,
    required this.observacion,
  });

  factory StatusHistoryModel.fromMap(Map<String, dynamic> map) {
    return StatusHistoryModel(
      codigoNotebook: map['codigoNotebook'] ?? '',
      estadoAnterior: map['estadoAnterior'] ?? '',
      estadoNuevo: map['estadoNuevo'] ?? '',
      usuarioResponsable: map['usuarioResponsable'] ?? '',
      fecha: DateTime.parse(map['fecha']),
      observacion: map['observacion'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigoNotebook': codigoNotebook,
      'estadoAnterior': estadoAnterior,
      'estadoNuevo': estadoNuevo,
      'usuarioResponsable': usuarioResponsable,
      'fecha': fecha.toIso8601String(),
      'observacion': observacion,
    };
  }
}