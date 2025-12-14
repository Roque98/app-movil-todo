import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/orden_trabajo.dart';

class PdfService {
  static Future<void> generarPDF(OrdenTrabajo ot) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Encabezado
          _buildEncabezado(ot),
          pw.SizedBox(height: 20),
          pw.Divider(thickness: 2),
          pw.SizedBox(height: 20),

          // Información de Creación
          _buildSeccion('Información de Creación', [
            _buildCampo('ID OT:', ot.idOT),
            _buildCampo('Fecha de Solicitud:', _formatFecha(ot.fechaSolicitud)),
            _buildCampo('Solicitante:', '${ot.solicitanteNombre} (${ot.solicitanteId})'),
            _buildCampo('Ubicación:', ot.ubicacion),
            if (ot.latitud != null && ot.longitud != null)
              _buildCampo('Coordenadas GPS:', '${ot.latitud!.toStringAsFixed(6)}, ${ot.longitud!.toStringAsFixed(6)}'),
            _buildCampo('Tipo de Falla:', _getTipoFallaTexto(ot.tipoFalla)),
            _buildCampo('Prioridad Solicitada:', _getPrioridadTexto(ot.prioridadSolicitada)),
          ]),
          pw.SizedBox(height: 20),

          // Descripción del Problema
          _buildSeccion('Descripción del Problema', [
            pw.Text(ot.descripcionProblema, style: const pw.TextStyle(fontSize: 11)),
          ]),
          pw.SizedBox(height: 20),

          // Información de Gestión (si existe)
          if (ot.tecnicoAsignadoNombre != null) ...[
            _buildSeccion('Información de Gestión', [
              _buildCampo('Técnico Asignado:', ot.tecnicoAsignadoNombre!),
              if (ot.fechaAsignacion != null)
                _buildCampo('Fecha de Asignación:', _formatFecha(ot.fechaAsignacion!)),
              if (ot.prioridadAsignada != null)
                _buildCampo('Prioridad Asignada:', _getPrioridadTexto(ot.prioridadAsignada!)),
              _buildCampo('Estado:', _getEstadoTexto(ot.estado)),
            ]),
            pw.SizedBox(height: 20),
          ],

          // Información del Trabajo Realizado (si existe)
          if (ot.descripcionTrabajoRealizado != null) ...[
            _buildSeccion('Trabajo Realizado', [
              pw.Text(ot.descripcionTrabajoRealizado!, style: const pw.TextStyle(fontSize: 11)),
            ]),
            pw.SizedBox(height: 10),
            if (ot.fechaHoraInicioReal != null)
              _buildCampo('Fecha de Inicio:', _formatFecha(ot.fechaHoraInicioReal!)),
            if (ot.fechaHoraCierreTecnico != null)
              _buildCampo('Fecha de Cierre:', _formatFecha(ot.fechaHoraCierreTecnico!)),
            if (ot.tiempoTotalTrabajado != null)
              _buildCampo('Tiempo Total:', _formatDuracion(ot.tiempoTotalTrabajado!)),
            pw.SizedBox(height: 20),
          ],

          // Materiales Usados
          if (ot.materialesUsados.isNotEmpty) ...[
            _buildSeccion('Materiales Usados', [
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                children: [
                  // Encabezado de tabla
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      _buildCeldaTabla('Material', bold: true),
                      _buildCeldaTabla('Cantidad', bold: true),
                      _buildCeldaTabla('Costo Unit.', bold: true),
                      _buildCeldaTabla('Costo Total', bold: true),
                    ],
                  ),
                  // Filas de datos
                  ...ot.materialesUsados.map((material) => pw.TableRow(
                        children: [
                          _buildCeldaTabla(material.nombre),
                          _buildCeldaTabla(material.cantidad.toString()),
                          _buildCeldaTabla('\$${material.costoUnitario.toStringAsFixed(2)}'),
                          _buildCeldaTabla('\$${material.costoTotal.toStringAsFixed(2)}'),
                        ],
                      )),
                  // Total
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                    children: [
                      _buildCeldaTabla('TOTAL', bold: true),
                      _buildCeldaTabla(''),
                      _buildCeldaTabla(''),
                      _buildCeldaTabla(
                        '\$${ot.materialesUsados.fold(0.0, (sum, m) => sum + m.costoTotal).toStringAsFixed(2)}',
                        bold: true,
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            pw.SizedBox(height: 20),
          ],

          // Información de Cierre (si existe)
          if (ot.estatusAceptacion != null) ...[
            _buildSeccion('Información de Cierre', [
              _buildCampo(
                'Estado Final:',
                ot.estatusAceptacion! ? 'ACEPTADO' : 'RECHAZADO',
              ),
              if (ot.comentariosSolicitante != null)
                _buildCampo('Comentarios del Solicitante:', ot.comentariosSolicitante!),
              if (ot.fechaCierreTotal != null)
                _buildCampo('Fecha de Cierre Total:', _formatFecha(ot.fechaCierreTotal!)),
            ]),
          ],

          // Pie de página
          pw.Spacer(),
          pw.Divider(thickness: 1),
          pw.SizedBox(height: 10),
          pw.Text(
            'Documento generado automáticamente el ${_formatFecha(DateTime.now())}',
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
          ),
        ],
      ),
    );

    // Mostrar el PDF en un visor/imprimir
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'OT_${ot.idOT}.pdf',
    );
  }

  static pw.Widget _buildEncabezado(OrdenTrabajo ot) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'ORDEN DE TRABAJO',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              ot.idOT,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: pw.BoxDecoration(
            color: _getEstadoColor(ot.estado),
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Text(
            _getEstadoTexto(ot.estado),
            style: const pw.TextStyle(
              color: PdfColors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildSeccion(String titulo, List<pw.Widget> contenido) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          titulo,
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
        pw.SizedBox(height: 10),
        ...contenido,
      ],
    );
  }

  static pw.Widget _buildCampo(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildCeldaTabla(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static String _formatFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
  }

  static String _formatDuracion(Duration duracion) {
    final horas = duracion.inHours;
    final minutos = duracion.inMinutes.remainder(60);
    return '$horas h $minutos min';
  }

  static String _getTipoFallaTexto(TipoFalla tipo) {
    switch (tipo) {
      case TipoFalla.electrica:
        return 'Eléctrica';
      case TipoFalla.plomeria:
        return 'Plomería';
      case TipoFalla.climatizacion:
        return 'Climatización';
      case TipoFalla.estructural:
        return 'Estructural';
      case TipoFalla.limpieza:
        return 'Limpieza';
      case TipoFalla.seguridad:
        return 'Seguridad';
      case TipoFalla.tecnologia:
        return 'Tecnología';
      case TipoFalla.otro:
        return 'Otro';
    }
  }

  static String _getPrioridadTexto(Prioridad prioridad) {
    switch (prioridad) {
      case Prioridad.critica:
        return 'Crítica';
      case Prioridad.alta:
        return 'Alta';
      case Prioridad.media:
        return 'Media';
      case Prioridad.baja:
        return 'Baja';
    }
  }

  static String _getEstadoTexto(EstadoOT estado) {
    switch (estado) {
      case EstadoOT.abierta:
        return 'ABIERTA';
      case EstadoOT.asignada:
        return 'ASIGNADA';
      case EstadoOT.enProgreso:
        return 'EN PROGRESO';
      case EstadoOT.pausada:
        return 'PAUSADA';
      case EstadoOT.pendienteCierre:
        return 'PENDIENTE DE CIERRE';
      case EstadoOT.cerrada:
        return 'CERRADA';
      case EstadoOT.rechazada:
        return 'RECHAZADA';
    }
  }

  static PdfColor _getEstadoColor(EstadoOT estado) {
    switch (estado) {
      case EstadoOT.abierta:
        return PdfColors.orange;
      case EstadoOT.asignada:
        return PdfColors.blue;
      case EstadoOT.enProgreso:
        return PdfColors.purple;
      case EstadoOT.pausada:
        return PdfColors.amber;
      case EstadoOT.pendienteCierre:
        return PdfColors.teal;
      case EstadoOT.cerrada:
        return PdfColors.green;
      case EstadoOT.rechazada:
        return PdfColors.red;
    }
  }
}
