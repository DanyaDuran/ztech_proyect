import 'package:cloud_firestore/cloud_firestore.dart';

class NotebookModel {
  final String codigo;
  final String marca;
  final String linea;
  final String modelo;
  final String procesador;
  final String generacion;
  final String ram;
  final String almacenamiento;
  final String tarjetaGrafica;
  String estado;
  final String seccion;
  final String estante;
  final String nivel;
  final String descripcionProblema;
  final String observacionesBodega;
  final DateTime fechaIngreso;

  NotebookModel({
    required this.codigo,
    required this.marca,
    required this.linea,
    required this.modelo,
    required this.procesador,
    required this.generacion,
    required this.ram,
    required this.almacenamiento,
    required this.tarjetaGrafica,
    required this.estado,
    required this.seccion,
    required this.estante,
    required this.nivel,
    this.descripcionProblema = '',
    this.observacionesBodega = '',
    DateTime? fechaIngreso,
  }) : fechaIngreso = fechaIngreso ?? DateTime.now();

  factory NotebookModel.fromMap(Map<String, dynamic> map) {
    final fecha = map['fechaIngreso'];

    return NotebookModel(
      codigo: map['codigo'] ?? '',
      marca: map['marca'] ?? '',
      linea: map['linea'] ?? '',
      modelo: map['modelo'] ?? '',
      procesador: map['procesador'] ?? '',
      generacion: map['generacion'] ?? '',
      ram: map['ram'] ?? '',
      almacenamiento: map['almacenamiento'] ?? '',
      tarjetaGrafica: map['tarjetaGrafica'] ?? '',
      estado: map['estado'] ?? '',
      seccion: map['seccion'] ?? '',
      estante: map['estante'] ?? '',
      nivel: map['nivel'] ?? '',
      descripcionProblema: map['descripcionProblema'] ?? '',
      observacionesBodega: map['observacionesBodega'] ?? '',
      fechaIngreso: fecha is Timestamp
          ? fecha.toDate()
          : fecha is DateTime
          ? fecha
          : DateTime.tryParse(fecha?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'marca': marca,
      'linea': linea,
      'modelo': modelo,
      'procesador': procesador,
      'generacion': generacion,
      'ram': ram,
      'almacenamiento': almacenamiento,
      'tarjetaGrafica': tarjetaGrafica,
      'estado': estado,
      'seccion': seccion,
      'estante': estante,
      'nivel': nivel,
      'descripcionProblema': descripcionProblema,
      'observacionesBodega': observacionesBodega,
      'fechaIngreso': Timestamp.fromDate(fechaIngreso),
    };
  }
}
