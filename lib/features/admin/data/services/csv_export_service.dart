import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_saver/file_saver.dart';

class CsvExportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> _generarYGuardarCsv(List<List<dynamic>> rows, String fileName) async {
    if (rows.length <= 1) {
      throw Exception('No existen registros para exportar.');
    }

    String csvData = rows.map((row) {
      return row.map((item) {
        String cell = item.toString().replaceAll('"', '""');
        return '"$cell"';
      }).join(',');
    }).join('\r\n');

    final List<int> codeUnits = utf8.encode('\uFEFF$csvData');
    final Uint8List bytes = Uint8List.fromList(codeUnits);

    String path = await FileSaver.instance.saveFile(
      name: fileName,
      bytes: bytes,
      mimeType: MimeType.csv,
    );

    return path;
  }

  Future<String> exportarInventarioCsv() async {
    final querySnapshot = await _firestore.collection('notebooks').get();
    
    List<List<dynamic>> rows = [
      ['codigo', 'marca', 'modelo', 'procesador', 'ram', 'almacenamiento', 'estado', 'seccion', 'estante', 'nivel', 'fecha ingreso']
    ];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      rows.add([
        data['codigo'] ?? '',
        data['marca'] ?? '',
        data['modelo'] ?? '',
        data['procesador'] ?? '',
        data['ram'] ?? '',
        data['almacenamiento'] ?? '',
        data['estado'] ?? '',
        data['seccion'] ?? '',
        data['estante'] ?? '',
        data['nivel'] ?? '',
        data['fecha_ingreso'] ?? '',
      ]);
    }

    return await _generarYGuardarCsv(rows, 'inventario_notebooks.csv');
  }

  Future<String> exportarVentasCsv() async {
    final querySnapshot = await _firestore.collection('ventas').get();
    
    List<List<dynamic>> rows = [
      ['codigo notebook', 'marca', 'modelo', 'cliente', 'precio', 'fecha venta', 'observaciones']
    ];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      rows.add([
        data['codigo_notebook'] ?? '',
        data['marca'] ?? '',
        data['modelo'] ?? '',
        data['cliente'] ?? '',
        data['precio'] ?? '',
        data['fecha_venta'] ?? '', 
        data['observaciones'] ?? '',
      ]);
    }

    return await _generarYGuardarCsv(rows, 'ventas_registradas.csv');
  }

  Future<String> exportarHistorialTecnicoCsv() async {
    final querySnapshot = await _firestore.collection('status_history').get();
    
    List<List<dynamic>> rows = [
      ['codigo notebook', 'estado anterior', 'estado nuevo', 'usuario responsable', 'diagnostico', 'acciones realizadas', 'observacion', 'fecha']
    ];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      rows.add([
        data['codigo_notebook'] ?? '',
        data['estado_anterior'] ?? '',
        data['estado_nuevo'] ?? '',
        data['usuario_responsable'] ?? '',
        data['diagnostico'] ?? '',
        data['acciones_realizadas'] ?? '',
        data['observacion'] ?? '',
        data['fecha'] ?? '',
      ]);
    }

    return await _generarYGuardarCsv(rows, 'historial_tecnico.csv');
  }
}