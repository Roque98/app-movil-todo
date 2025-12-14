import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../models/orden_trabajo.dart';
import '../models/usuario.dart';
import '../services/auth_service.dart';
import '../services/pdf_service.dart';
import '../data/usuarios_dummy.dart';
import 'editar_ot_screen.dart';

class DetalleOTScreen extends StatelessWidget {
  final OrdenTrabajo ordenTrabajo;
  final Function(OrdenTrabajo)? onOTActualizada;

  const DetalleOTScreen({
    super.key,
    required this.ordenTrabajo,
    this.onOTActualizada,
  });

  static final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ordenTrabajo.idOT),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_authService.tienePermiso(Permiso.editarOT))
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditarOTScreen(
                      ordenTrabajo: ordenTrabajo,
                      onGuardar: (otActualizada) {
                        if (onOTActualizada != null) {
                          onOTActualizada!(otActualizada);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          if (_authService.tienePermiso(Permiso.editarOT) ||
              _authService.tienePermiso(Permiso.asignarOT))
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _onMenuSelected(context, value),
              itemBuilder: (context) => [
                if (_authService.tienePermiso(Permiso.asignarOT))
                  const PopupMenuItem(
                    value: 'reasignar',
                    child: Row(
                      children: [
                        Icon(Icons.person_add, size: 20),
                        SizedBox(width: 12),
                        Text('Reasignar técnico'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'historial',
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 20),
                      SizedBox(width: 12),
                      Text('Ver historial'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'compartir',
                  child: Row(
                    children: [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 12),
                      Text('Compartir'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'exportar',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf, size: 20),
                      SizedBox(width: 12),
                      Text('Exportar PDF'),
                    ],
                  ),
                ),
                if (_authService.usuarioActual?.rol == Rol.administrador) ...[
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'eliminar',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Text('Eliminar OT', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const Divider(height: 1),
            _buildInformacionCreacion(context),
            const Divider(height: 1),
            if (ordenTrabajo.tecnicoAsignadoNombre != null)
              _buildInformacionGestion(),
            if (ordenTrabajo.tecnicoAsignadoNombre != null)
              const Divider(height: 1),
            if (ordenTrabajo.fechaHoraInicioReal != null)
              _buildInformacionSeguimiento(),
            if (ordenTrabajo.fechaHoraInicioReal != null)
              const Divider(height: 1),
            if (ordenTrabajo.estatusAceptacion != null)
              _buildInformacionCierre(),
            if (ordenTrabajo.estatusAceptacion != null)
              const Divider(height: 1),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildHeaderSection() {
    Color estadoColor;
    switch (ordenTrabajo.estado) {
      case EstadoOT.abierta:
        estadoColor = Colors.orange;
        break;
      case EstadoOT.asignada:
        estadoColor = Colors.blue;
        break;
      case EstadoOT.enProgreso:
        estadoColor = Colors.purple;
        break;
      case EstadoOT.pausada:
        estadoColor = Colors.amber;
        break;
      case EstadoOT.pendienteCierre:
        estadoColor = Colors.teal;
        break;
      case EstadoOT.cerrada:
        estadoColor = Colors.green;
        break;
      case EstadoOT.rechazada:
        estadoColor = Colors.red;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: estadoColor.withValues(alpha: 0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: estadoColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ordenTrabajo.estadoTexto.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              _buildPrioridadBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ordenTrabajo.tipoFallaTexto,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: estadoColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ordenTrabajo.descripcionProblema,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPrioridadBadge() {
    final prioridad = ordenTrabajo.prioridadAsignada ?? ordenTrabajo.prioridadSolicitada;
    Color color;
    IconData icon;
    String texto;

    switch (prioridad) {
      case Prioridad.critica:
        color = Colors.red;
        icon = Icons.warning;
        texto = 'CRÍTICA';
        break;
      case Prioridad.alta:
        color = Colors.orange;
        icon = Icons.priority_high;
        texto = 'ALTA';
        break;
      case Prioridad.media:
        color = Colors.blue;
        icon = Icons.remove;
        texto = 'MEDIA';
        break;
      case Prioridad.baja:
        color = Colors.green;
        icon = Icons.arrow_downward;
        texto = 'BAJA';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformacionCreacion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Creación',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.calendar_today, 'Fecha de Solicitud',
              _formatFechaCompleta(ordenTrabajo.fechaSolicitud)),
          _buildInfoRow(Icons.person, 'Solicitante',
              '${ordenTrabajo.solicitanteNombre} (${ordenTrabajo.solicitanteId})'),
          _buildInfoRow(Icons.location_on, 'Ubicación', ordenTrabajo.ubicacion),
          if (ordenTrabajo.latitud != null && ordenTrabajo.longitud != null) ...[
            _buildInfoRow(Icons.gps_fixed, 'Coordenadas GPS',
                '${ordenTrabajo.latitud!.toStringAsFixed(6)}, ${ordenTrabajo.longitud!.toStringAsFixed(6)}'),
            const SizedBox(height: 16),
            _buildMapa(context),
          ],
          if (ordenTrabajo.archivosAdjuntos.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text(
              'Archivos Adjuntos:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ordenTrabajo.archivosAdjuntos.map((archivo) {
                return Chip(
                  avatar: Icon(
                    archivo.endsWith('.mp4') ? Icons.videocam : Icons.image,
                    size: 18,
                  ),
                  label: Text(archivo),
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInformacionGestion() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Gestión',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.engineering, 'Técnico Asignado',
              '${ordenTrabajo.tecnicoAsignadoNombre} (${ordenTrabajo.tecnicoAsignadoId})'),
          if (ordenTrabajo.fechaAsignacion != null)
            _buildInfoRow(Icons.calendar_today, 'Fecha de Asignación',
                _formatFechaCompleta(ordenTrabajo.fechaAsignacion!)),
          if (ordenTrabajo.slaTimeRespuesta != null)
            _buildInfoRow(Icons.timer, 'SLA Tiempo de Respuesta',
                _formatDuracion(ordenTrabajo.slaTimeRespuesta!)),
          if (ordenTrabajo.fechaCompromiso != null)
            _buildInfoRow(Icons.event, 'Fecha Compromiso',
                _formatFechaCompleta(ordenTrabajo.fechaCompromiso!)),
          if (ordenTrabajo.comentariosGestion != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Comentarios de Gestión:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(ordenTrabajo.comentariosGestion!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInformacionSeguimiento() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Seguimiento',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (ordenTrabajo.fechaHoraInicioReal != null)
            _buildInfoRow(Icons.play_arrow, 'Inicio Real',
                _formatFechaCompleta(ordenTrabajo.fechaHoraInicioReal!)),
          if (ordenTrabajo.fechaHoraCierreTecnico != null)
            _buildInfoRow(Icons.stop, 'Cierre Técnico',
                _formatFechaCompleta(ordenTrabajo.fechaHoraCierreTecnico!)),
          if (ordenTrabajo.tiempoTotalTrabajado != null)
            _buildInfoRow(Icons.timer, 'Tiempo Total Trabajado',
                _formatDuracion(ordenTrabajo.tiempoTotalTrabajado!)),
          if (ordenTrabajo.descripcionTrabajoRealizado != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Trabajo Realizado:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Text(ordenTrabajo.descripcionTrabajoRealizado!),
            ),
          ],
          if (ordenTrabajo.materialesUsados.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Materiales Utilizados:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...ordenTrabajo.materialesUsados.map((material) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            material.nombre,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'ID: ${material.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Cant: ${material.cantidad}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '\$${material.costoTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Costo Total de Materiales:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '\$${ordenTrabajo.costoTotalMateriales.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (ordenTrabajo.fotosCierre.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Fotos de Cierre:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ordenTrabajo.fotosCierre.map((foto) {
                return Chip(
                  avatar: const Icon(Icons.photo, size: 18),
                  label: Text(foto),
                  labelStyle: const TextStyle(fontSize: 12),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInformacionCierre() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Cierre',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ordenTrabajo.estatusAceptacion == true
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ordenTrabajo.estatusAceptacion == true
                    ? Colors.green.withValues(alpha: 0.3)
                    : Colors.red.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  ordenTrabajo.estatusAceptacion == true
                      ? Icons.check_circle
                      : Icons.cancel,
                  size: 32,
                  color: ordenTrabajo.estatusAceptacion == true
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 12),
                Text(
                  ordenTrabajo.estatusAceptacion == true
                      ? 'TRABAJO ACEPTADO'
                      : 'TRABAJO RECHAZADO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ordenTrabajo.estatusAceptacion == true
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          if (ordenTrabajo.fechaCierreTotal != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.event_available, 'Fecha de Cierre Total',
                _formatFechaCompleta(ordenTrabajo.fechaCierreTotal!)),
          ],
          if (ordenTrabajo.comentariosSolicitante != null) ...[
            const SizedBox(height: 12),
            const Text(
              'Comentarios del Solicitante:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ordenTrabajo.estatusAceptacion == true
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ordenTrabajo.estatusAceptacion == true
                      ? Colors.green.withValues(alpha: 0.3)
                      : Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: Text(ordenTrabajo.comentariosSolicitante!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMapa(BuildContext context) {
    if (ordenTrabajo.latitud == null || ordenTrabajo.longitud == null) {
      return const SizedBox.shrink();
    }

    final LatLng posicion = LatLng(ordenTrabajo.latitud!, ordenTrabajo.longitud!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mapa de Ubicación',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            TextButton.icon(
              onPressed: () {
                // Abrir en Google Maps (simulado por ahora)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text('Para usar esta función, instala el paquete url_launcher'),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.blue[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Abrir en Maps', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: posicion,
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('ubicacion_ot'),
                  position: posicion,
                  infoWindow: InfoWindow(
                    title: ordenTrabajo.idOT,
                    snippet: ordenTrabajo.ubicacion,
                  ),
                ),
              },
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final usuario = _authService.usuarioActual;
    final esTecnicoAsignado = usuario?.id == ordenTrabajo.tecnicoAsignadoId;
    final esSolicitante = usuario?.id == ordenTrabajo.solicitanteId;

    // Botones de acción según el estado y el rol del usuario
    List<Widget> actionButtons = [];

    // Botón Iniciar - Solo técnico asignado, estado Asignada
    if (esTecnicoAsignado && ordenTrabajo.estado == EstadoOT.asignada) {
      actionButtons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _iniciarTrabajo(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar Trabajo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    // Botón Pausar - Solo técnico asignado, estado En Progreso
    if (esTecnicoAsignado && ordenTrabajo.estado == EstadoOT.enProgreso) {
      actionButtons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _pausarTrabajo(context),
            icon: const Icon(Icons.pause),
            label: const Text('Pausar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange[700],
              side: BorderSide(color: Colors.orange[700]!),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );

      if (actionButtons.isNotEmpty) actionButtons.add(const SizedBox(width: 12));

      actionButtons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _cerrarTrabajo(context),
            icon: const Icon(Icons.check_circle),
            label: const Text('Finalizar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    // Botón Reanudar - Solo técnico asignado, estado Pausada
    if (esTecnicoAsignado && ordenTrabajo.estado == EstadoOT.pausada) {
      actionButtons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _reanudarTrabajo(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Reanudar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    // Botones Aceptar/Rechazar - Solo solicitante, estado Pendiente Cierre
    if (esSolicitante && ordenTrabajo.estado == EstadoOT.pendienteCierre) {
      actionButtons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _rechazarTrabajo(context),
            icon: const Icon(Icons.close),
            label: const Text('Rechazar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red[700],
              side: BorderSide(color: Colors.red[700]!),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );

      actionButtons.add(const SizedBox(width: 12));

      actionButtons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _aceptarTrabajo(context),
            icon: const Icon(Icons.check),
            label: const Text('Aceptar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      );
    }

    // Si no hay botones de acción, mostrar botones genéricos
    if (actionButtons.isEmpty) {
      actionButtons = [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _compartirOT(context),
            icon: const Icon(Icons.share),
            label: const Text('Compartir'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _exportarPDF(context),
            icon: const Icon(Icons.download),
            label: const Text('Exportar PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: actionButtons,
      ),
    );
  }

  void _iniciarTrabajo(BuildContext context) {
    // Validación: Solo se puede iniciar si está asignada
    if (ordenTrabajo.estado != EstadoOT.asignada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Solo se puede iniciar una OT en estado "Asignada"'),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final otActualizada = ordenTrabajo.copyWith(
      estado: EstadoOT.enProgreso,
      fechaHoraInicioReal: DateTime.now(),
    );

    if (onOTActualizada != null) {
      onOTActualizada!(otActualizada);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white),
            SizedBox(width: 12),
            Text('Trabajo iniciado exitosamente'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _pausarTrabajo(BuildContext context) {
    // Validación: Solo se puede pausar si está en progreso
    if (ordenTrabajo.estado != EstadoOT.enProgreso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Solo se puede pausar una OT en estado "En Progreso"'),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final otActualizada = ordenTrabajo.copyWith(
      estado: EstadoOT.pausada,
    );

    if (onOTActualizada != null) {
      onOTActualizada!(otActualizada);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.pause, color: Colors.white),
            SizedBox(width: 12),
            Text('Trabajo pausado'),
          ],
        ),
        backgroundColor: Colors.orange[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _reanudarTrabajo(BuildContext context) {
    // Validación: Solo se puede reanudar si está pausado
    if (ordenTrabajo.estado != EstadoOT.pausada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Solo se puede reanudar una OT en estado "Pausado"'),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    final otActualizada = ordenTrabajo.copyWith(
      estado: EstadoOT.enProgreso,
    );

    if (onOTActualizada != null) {
      onOTActualizada!(otActualizada);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white),
            SizedBox(width: 12),
            Text('Trabajo reanudado'),
          ],
        ),
        backgroundColor: Colors.purple[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _cerrarTrabajo(BuildContext context) {
    // Validación: Solo se puede cerrar si está en progreso o pausado
    if (ordenTrabajo.estado != EstadoOT.enProgreso &&
        ordenTrabajo.estado != EstadoOT.pausada) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No se puede finalizar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'El trabajo debe estar en estado "En Progreso" o "Pausado"',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    _mostrarDialogoCierre(context);
  }

  void _mostrarDialogoCierre(BuildContext context) {
    final descripcionController = TextEditingController();
    final List<String> fotosCierre = [];

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.task_alt, color: Colors.blue),
              SizedBox(width: 12),
              Text('Finalizar Trabajo'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Descripción del trabajo realizado:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descripcionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Describe el trabajo realizado...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Fotos de evidencia:',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${fotosCierre.length}/5',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    if (fotosCierre.length < 5) {
                      setState(() {
                        fotosCierre.add('evidencia_${fotosCierre.length + 1}.jpg');
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Máximo 5 fotos permitidas'),
                          backgroundColor: Colors.orange,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add_a_photo, size: 20),
                  label: const Text('Agregar foto'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (fotosCierre.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: fotosCierre.asMap().entries.map((entry) {
                        final index = entry.key;
                        return Stack(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.shade300),
                              ),
                              child: Icon(
                                Icons.image,
                                color: Colors.green.shade700,
                                size: 30,
                              ),
                            ),
                            Positioned(
                              right: -4,
                              top: -4,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    fotosCierre.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                descripcionController.dispose();
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final descripcion = descripcionController.text.trim();

                if (descripcion.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Debes describir el trabajo realizado'),
                        ],
                      ),
                      backgroundColor: Colors.orange[700],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                  return;
                }

                // Calcular tiempo trabajado
                Duration? tiempoTrabajado;
                if (ordenTrabajo.fechaHoraInicioReal != null) {
                  tiempoTrabajado = DateTime.now().difference(ordenTrabajo.fechaHoraInicioReal!);
                }

                final otActualizada = ordenTrabajo.copyWith(
                  estado: EstadoOT.pendienteCierre,
                  fechaHoraCierreTecnico: DateTime.now(),
                  tiempoTotalTrabajado: tiempoTrabajado,
                  descripcionTrabajoRealizado: descripcion,
                  fotosCierre: List.from(fotosCierre),
                );

                if (onOTActualizada != null) {
                  onOTActualizada!(otActualizada);
                }

                descripcionController.dispose();
                Navigator.pop(dialogContext);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Trabajo finalizado, pendiente de aprobación'),
                      ],
                    ),
                    backgroundColor: Colors.blue[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
              child: const Text('Finalizar'),
            ),
          ],
        ),
      ),
    );
  }

  void _aceptarTrabajo(BuildContext context) {
    final otActualizada = ordenTrabajo.copyWith(
      estado: EstadoOT.cerrada,
      estatusAceptacion: true,
      fechaCierreTotal: DateTime.now(),
      comentariosSolicitante: 'Trabajo aceptado',
    );

    if (onOTActualizada != null) {
      onOTActualizada!(otActualizada);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Trabajo aceptado, OT cerrada'),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _rechazarTrabajo(BuildContext context) {
    final comentarioController = TextEditingController();

    // Mostrar diálogo para comentarios del rechazo
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Rechazar Trabajo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Por favor, indica el motivo del rechazo:'),
            const SizedBox(height: 16),
            TextField(
              controller: comentarioController,
              maxLines: 3,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Motivo del rechazo...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              comentarioController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final comentario = comentarioController.text.trim();

              if (comentario.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Debes ingresar un motivo de rechazo'),
                      ],
                    ),
                    backgroundColor: Colors.orange[700],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
                return;
              }

              comentarioController.dispose();
              Navigator.pop(dialogContext);

              final otActualizada = ordenTrabajo.copyWith(
                estado: EstadoOT.rechazada,
                estatusAceptacion: false,
                fechaCierreTotal: DateTime.now(),
                comentariosSolicitante: 'Rechazado: $comentario',
              );

              if (onOTActualizada != null) {
                onOTActualizada!(otActualizada);
              }

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.white),
                      SizedBox(width: 12),
                      Text('Trabajo rechazado'),
                    ],
                  ),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            child: const Text('Rechazar'),
          ),
        ],
      ),
    );
  }

  String _formatFechaCompleta(DateTime fecha) {
    final meses = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year} - $hora:$minuto';
  }

  String _formatDuracion(Duration duracion) {
    if (duracion.inDays > 0) {
      final horas = duracion.inHours % 24;
      return '${duracion.inDays} día(s) ${horas}h';
    } else if (duracion.inHours > 0) {
      final minutos = duracion.inMinutes % 60;
      return '${duracion.inHours}h ${minutos}min';
    } else {
      return '${duracion.inMinutes} minutos';
    }
  }

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'reasignar':
        _mostrarDialogoReasignar(context);
        break;
      case 'historial':
        _mostrarHistorial(context);
        break;
      case 'compartir':
        _compartirOT(context);
        break;
      case 'exportar':
        _exportarPDF(context);
        break;
      case 'eliminar':
        _confirmarEliminar(context);
        break;
    }
  }

  void _mostrarDialogoReasignar(BuildContext context) {
    final tecnicos = usuariosDummy.where((u) => u.rol == Rol.tecnico).toList();
    String? tecnicoSeleccionadoId = ordenTrabajo.tecnicoAsignadoId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.swap_horiz_rounded, color: Colors.blue[700]),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Reasignar Técnico', style: TextStyle(fontSize: 18)),
                    Text(
                      'Selecciona un nuevo técnico',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (ordenTrabajo.tecnicoAsignadoId != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 20, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Técnico actual: ${ordenTrabajo.tecnicoAsignadoNombre}',
                            style: TextStyle(fontSize: 13, color: Colors.orange[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Técnicos disponibles:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tecnicos.length,
                    itemBuilder: (context, index) {
                      final tecnico = tecnicos[index];
                      final isSelected = tecnicoSeleccionadoId == tecnico.id;
                      final isCurrent = tecnico.id == ordenTrabajo.tecnicoAsignadoId;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue[50] : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.blue[300]! : Colors.grey[300]!,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: isSelected ? Colors.blue[700] : Colors.grey[300],
                            child: Icon(
                              Icons.person,
                              color: isSelected ? Colors.white : Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tecnico.nombre,
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              if (isCurrent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Actual',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange[900],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            tecnico.email,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: isSelected
                              ? Icon(Icons.check_circle, color: Colors.blue[700], size: 24)
                              : null,
                          onTap: () {
                            setState(() {
                              tecnicoSeleccionadoId = tecnico.id;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              onPressed: tecnicoSeleccionadoId == null ||
                         tecnicoSeleccionadoId == ordenTrabajo.tecnicoAsignadoId
                  ? null
                  : () {
                      final tecnicoSeleccionado = tecnicos.firstWhere(
                        (t) => t.id == tecnicoSeleccionadoId,
                      );
                      _realizarReasignacion(context, tecnicoSeleccionado);
                    },
              icon: const Icon(Icons.swap_horiz, size: 18),
              label: const Text('Reasignar'),
            ),
          ],
        ),
      ),
    );
  }

  void _realizarReasignacion(BuildContext context, Usuario nuevoTecnico) {
    final tecnicoAnterior = ordenTrabajo.tecnicoAsignadoNombre ?? 'Sin asignar';

    // Actualizar la OT con el nuevo técnico
    final otActualizada = ordenTrabajo.copyWith(
      tecnicoAsignadoId: nuevoTecnico.id,
      tecnicoAsignadoNombre: nuevoTecnico.nombre,
      fechaAsignacion: DateTime.now(),
      estado: EstadoOT.asignada,
    );

    // Notificar cambios
    if (onOTActualizada != null) {
      onOTActualizada!(otActualizada);
    }

    Navigator.pop(context);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Técnico reasignado exitosamente',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'De "$tecnicoAnterior" a "${nuevoTecnico.nombre}"',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _mostrarHistorial(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.history, color: Colors.blue),
            SizedBox(width: 12),
            Text('Historial de Cambios'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHistorialItem(
                'OT Creada',
                ordenTrabajo.fechaSolicitud,
                'Solicitada por ${ordenTrabajo.solicitanteNombre}',
                Icons.add_circle,
                Colors.blue,
              ),
              if (ordenTrabajo.fechaAsignacion != null)
                _buildHistorialItem(
                  'OT Asignada',
                  ordenTrabajo.fechaAsignacion!,
                  'Asignada a ${ordenTrabajo.tecnicoAsignadoNombre ?? "técnico"}',
                  Icons.assignment_ind,
                  Colors.orange,
                ),
              if (ordenTrabajo.fechaHoraInicioReal != null)
                _buildHistorialItem(
                  'Trabajo Iniciado',
                  ordenTrabajo.fechaHoraInicioReal!,
                  'El técnico inició el trabajo',
                  Icons.play_arrow,
                  Colors.green,
                ),
              if (ordenTrabajo.fechaHoraCierreTecnico != null)
                _buildHistorialItem(
                  'Trabajo Finalizado',
                  ordenTrabajo.fechaHoraCierreTecnico!,
                  'El técnico finalizó el trabajo',
                  Icons.check_circle,
                  Colors.purple,
                ),
              if (ordenTrabajo.fechaCierreTotal != null)
                _buildHistorialItem(
                  ordenTrabajo.estatusAceptacion == true ? 'OT Aceptada' : 'OT Rechazada',
                  ordenTrabajo.fechaCierreTotal!,
                  ordenTrabajo.estatusAceptacion == true
                      ? 'Trabajo aceptado por el solicitante'
                      : 'Trabajo rechazado por el solicitante',
                  ordenTrabajo.estatusAceptacion == true ? Icons.thumb_up : Icons.thumb_down,
                  ordenTrabajo.estatusAceptacion == true ? Colors.green : Colors.red,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorialItem(String titulo, DateTime fecha, String descripcion, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFechaCompleta(fecha),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _compartirOT(BuildContext context) async {
    try {
      // Generar el texto para compartir
      final texto = _generarTextoCompartir();

      // Compartir usando share_plus
      await Share.share(
        texto,
        subject: 'Orden de Trabajo ${ordenTrabajo.idOT}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error al compartir: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  String _generarTextoCompartir() {
    final buffer = StringBuffer();

    // Encabezado
    buffer.writeln('📋 ORDEN DE TRABAJO');
    buffer.writeln('━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('ID: ${ordenTrabajo.idOT}');
    buffer.writeln('Estado: ${_getEstadoTexto(ordenTrabajo.estado)}');
    buffer.writeln();

    // Información básica
    buffer.writeln('📅 Información de Creación');
    buffer.writeln('Fecha: ${_formatFechaCompleta(ordenTrabajo.fechaSolicitud)}');
    buffer.writeln('Solicitante: ${ordenTrabajo.solicitanteNombre}');
    buffer.writeln('Ubicación: ${ordenTrabajo.ubicacion}');
    if (ordenTrabajo.latitud != null && ordenTrabajo.longitud != null) {
      buffer.writeln('GPS: ${ordenTrabajo.latitud!.toStringAsFixed(6)}, ${ordenTrabajo.longitud!.toStringAsFixed(6)}');
      buffer.writeln('Maps: https://www.google.com/maps?q=${ordenTrabajo.latitud},${ordenTrabajo.longitud}');
    }
    buffer.writeln('Tipo de Falla: ${_getTipoFallaTexto(ordenTrabajo.tipoFalla)}');
    buffer.writeln('Prioridad: ${_getPrioridadTexto(ordenTrabajo.prioridadSolicitada)}');
    buffer.writeln();

    // Descripción del problema
    buffer.writeln('📝 Descripción del Problema');
    buffer.writeln(ordenTrabajo.descripcionProblema);
    buffer.writeln();

    // Información de gestión
    if (ordenTrabajo.tecnicoAsignadoNombre != null) {
      buffer.writeln('👷 Información de Gestión');
      buffer.writeln('Técnico: ${ordenTrabajo.tecnicoAsignadoNombre}');
      if (ordenTrabajo.prioridadAsignada != null) {
        buffer.writeln('Prioridad Asignada: ${_getPrioridadTexto(ordenTrabajo.prioridadAsignada!)}');
      }
      buffer.writeln();
    }

    // Trabajo realizado
    if (ordenTrabajo.descripcionTrabajoRealizado != null) {
      buffer.writeln('🔧 Trabajo Realizado');
      buffer.writeln(ordenTrabajo.descripcionTrabajoRealizado);
      if (ordenTrabajo.tiempoTotalTrabajado != null) {
        final horas = ordenTrabajo.tiempoTotalTrabajado!.inHours;
        final minutos = ordenTrabajo.tiempoTotalTrabajado!.inMinutes.remainder(60);
        buffer.writeln('Tiempo: $horas h $minutos min');
      }
      buffer.writeln();
    }

    // Materiales
    if (ordenTrabajo.materialesUsados.isNotEmpty) {
      buffer.writeln('🛠️ Materiales Usados');
      for (final material in ordenTrabajo.materialesUsados) {
        buffer.writeln('- ${material.nombre}: ${material.cantidad} x \$${material.costoUnitario.toStringAsFixed(2)} = \$${material.costoTotal.toStringAsFixed(2)}');
      }
      final costoTotal = ordenTrabajo.materialesUsados.fold(0.0, (sum, m) => sum + m.costoTotal);
      buffer.writeln('Total: \$${costoTotal.toStringAsFixed(2)}');
      buffer.writeln();
    }

    // Estado final
    if (ordenTrabajo.estatusAceptacion != null) {
      buffer.writeln('✓ Estado Final');
      buffer.writeln(ordenTrabajo.estatusAceptacion! ? 'ACEPTADO' : 'RECHAZADO');
      if (ordenTrabajo.comentariosSolicitante != null) {
        buffer.writeln('Comentarios: ${ordenTrabajo.comentariosSolicitante}');
      }
    }

    buffer.writeln();
    buffer.writeln('━━━━━━━━━━━━━━━━━━━');
    buffer.writeln('Generado automáticamente desde App de Mantenimiento');

    return buffer.toString();
  }

  String _getTipoFallaTexto(TipoFalla tipo) {
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

  String _getPrioridadTexto(Prioridad prioridad) {
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

  String _getEstadoTexto(EstadoOT estado) {
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

  Future<void> _exportarPDF(BuildContext context) async {
    try {
      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generando PDF...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Generar PDF
      await PdfService.generarPDF(ordenTrabajo);

      // Cerrar diálogo de carga
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      // Cerrar diálogo de carga si está abierto
      if (context.mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Error al generar PDF: $e'),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  void _confirmarEliminar(BuildContext context) {
    // Validación: No se puede eliminar si está en ciertos estados
    if (ordenTrabajo.estado == EstadoOT.enProgreso ||
        ordenTrabajo.estado == EstadoOT.pausada ||
        ordenTrabajo.estado == EstadoOT.pendienteCierre ||
        ordenTrabajo.estado == EstadoOT.cerrada) {
      String estadoTexto;
      switch (ordenTrabajo.estado) {
        case EstadoOT.enProgreso:
          estadoTexto = 'En Progreso';
          break;
        case EstadoOT.pausada:
          estadoTexto = 'Pausado';
          break;
        case EstadoOT.pendienteCierre:
          estadoTexto = 'Pendiente de Cierre';
          break;
        case EstadoOT.cerrada:
          estadoTexto = 'Cerrada';
          break;
        default:
          estadoTexto = ordenTrabajo.estado.toString();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.block, color: Colors.red),
              SizedBox(width: 12),
              Text('No se puede eliminar'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'No es posible eliminar la OT ${ordenTrabajo.idOT} porque está en estado "$estadoTexto".',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.orange[700]),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Solo se pueden eliminar OTs en estado "Abierta", "Asignada" o "Rechazada"',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Text('Eliminar OT'),
          ],
        ),
        content: Text('¿Estás seguro de que deseas eliminar la OT ${ordenTrabajo.idOT}?\n\nEsta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.white),
                      const SizedBox(width: 12),
                      Text('OT ${ordenTrabajo.idOT} eliminada'),
                    ],
                  ),
                  backgroundColor: Colors.red[600],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600]),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
