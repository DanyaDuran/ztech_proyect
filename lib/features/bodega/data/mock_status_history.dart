import '../domain/status_history_model.dart';

List<StatusHistoryModel> mockStatusHistory = [
  StatusHistoryModel(
    codigoNotebook: 'NB-002',
    estadoAnterior: 'Pendiente de revisión',
    estadoNuevo: 'En reparación',
    usuarioResponsable: 'tecnico@ztech.cl',
    fecha: DateTime.now().subtract(const Duration(days: 2)),

    diagnostico: 'Fallo en pin de carga',
    accionesRealizadas: 'Revisión y diagnóstico inicial',
    observacion: 'Se diagnostica fallo en pin de carga, pasa a taller.',
  ),

  StatusHistoryModel(
    codigoNotebook: 'NB-004',
    estadoAnterior: 'Disponible',
    estadoNuevo: 'Vendido',
    usuarioResponsable: 'ventas@ztech.cl',
    fecha: DateTime.now().subtract(const Duration(days: 1)),

    diagnostico: 'Equipo en buen estado general',
    accionesRealizadas: 'Verificación antes de venta',
    observacion: 'Venta confirmada, preparado para despacho.',
  ),

  StatusHistoryModel(
    codigoNotebook: 'NB-005',
    estadoAnterior: 'Pendiente de revisión',
    estadoNuevo: 'Merma',
    usuarioResponsable: 'tecnico@ztech.cl',
    fecha: DateTime.now().subtract(const Duration(hours: 5)),

    diagnostico: 'Derrame de líquido en placa',
    accionesRealizadas: 'Inspección interna',
    observacion:
        'Derrame de líquido daña componentes irreparables. Pasa a desarme.',
  ),
];
