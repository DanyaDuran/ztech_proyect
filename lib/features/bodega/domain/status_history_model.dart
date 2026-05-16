class StatusHistoryModel {
  final String codigoNotebook;
  final String estadoAnterior;
  final String estadoNuevo;
  final String usuarioResponsable;
  final DateTime fecha;
  final String diagnostico;
  final String accionesRealizadas;
  final String observacion;

  StatusHistoryModel({
    required this.codigoNotebook,
    required this.estadoAnterior,
    required this.estadoNuevo,
    required this.usuarioResponsable,
    required this.fecha,
    required this.diagnostico,
    required this.accionesRealizadas,
    required this.observacion,
  });

  factory StatusHistoryModel.fromMap(Map<String, dynamic> map) {
    return StatusHistoryModel(
      codigoNotebook: map['codigoNotebook'] ?? '',
      estadoAnterior: map['estadoAnterior'] ?? '',
      estadoNuevo: map['estadoNuevo'] ?? '',
      usuarioResponsable: map['usuarioResponsable'] ?? '',
      fecha: DateTime.parse(map['fecha']),

      diagnostico: map['diagnostico'] ?? '',
      accionesRealizadas: map['accionesRealizadas'] ?? '',
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
      'diagnostico': diagnostico,
      'accionesRealizadas': accionesRealizadas,
      'observacion': observacion,
    };
  }
}
