import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:ztech_flutter__app/features/bodega/domain/notebook_model.dart';
import 'package:ztech_flutter__app/core/session/current_user.dart';

class ComprobanteSalidaPdfService {
  Future<void> generarComprobanteSalida({
    required NotebookModel notebook,
  }) async {
    final pdf = pw.Document();
    final fecha = DateTime.now();
    final usuario = CurrentUser.user?.correo ?? 'Usuario desconocido';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Comprobante de Salida',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 24),

                pw.Text('Sistema ZTech'),
                pw.Divider(),

                pw.SizedBox(height: 16),

                pw.Text('ID del equipo: ${notebook.codigo}'),
                pw.Text('Marca: ${notebook.marca}'),
                pw.Text('Modelo: ${notebook.modelo}'),
                pw.Text('Estado: ${notebook.estado}'),

                pw.SizedBox(height: 16),

                pw.Text('Fecha/Hora de transacción: ${_formatDateTime(fecha)}'),
                pw.Text('Usuario responsable: $usuario'),

                pw.SizedBox(height: 32),

                pw.Text(
                  'Este documento certifica la salida del equipo desde inventario por proceso de venta.',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();

    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year - $hour:$minute';
  }
}
