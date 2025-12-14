import 'package:flutter/material.dart';
import '../models/notificacion.dart';
import '../data/notificaciones_dummy.dart';
import '../services/auth_service.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  final _authService = AuthService();
  late List<Notificacion> _notificaciones;

  @override
  void initState() {
    super.initState();
    _cargarNotificaciones();
  }

  void _cargarNotificaciones() {
    final usuarioId = _authService.usuarioActual?.id;
    if (usuarioId != null) {
      _notificaciones = notificacionesDummy
          .where((n) => n.usuarioId == usuarioId)
          .toList()
        ..sort((a, b) => b.fecha.compareTo(a.fecha));
    } else {
      _notificaciones = [];
    }
  }

  void _marcarComoLeida(Notificacion notificacion) {
    setState(() {
      final index = _notificaciones.indexWhere((n) => n.id == notificacion.id);
      if (index != -1) {
        _notificaciones[index] = notificacion.copyWith(leida: true);
      }
    });
  }

  void _marcarTodasComoLeidas() {
    setState(() {
      _notificaciones = _notificaciones.map((n) => n.copyWith(leida: true)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todas las notificaciones marcadas como leídas'),
        backgroundColor: Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  int get _notificacionesNoLeidas {
    return _notificaciones.where((n) => !n.leida).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (_notificacionesNoLeidas > 0)
              Text(
                '$_notificacionesNoLeidas no leída${_notificacionesNoLeidas > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          if (_notificacionesNoLeidas > 0)
            TextButton.icon(
              onPressed: _marcarTodasComoLeidas,
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Marcar todas'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[700],
              ),
            ),
        ],
      ),
      body: _notificaciones.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notificaciones.length,
              itemBuilder: (context, index) {
                final notificacion = _notificaciones[index];
                return _buildNotificacionCard(notificacion);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No hay notificaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aquí aparecerán las actualizaciones\nde tus órdenes de trabajo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificacionCard(Notificacion notificacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notificacion.leida ? Colors.white : Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notificacion.leida ? Colors.grey[200]! : Colors.blue[200]!,
          width: notificacion.leida ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (!notificacion.leida) {
            _marcarComoLeida(notificacion);
          }
          // Aquí podrías navegar al detalle de la OT si existe otId
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTipoColor(notificacion.tipo).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTipoIcon(notificacion.tipo),
                  color: _getTipoColor(notificacion.tipo),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notificacion.titulo,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: notificacion.leida ? FontWeight.w600 : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!notificacion.leida)
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.blue[600],
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notificacion.mensaje,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatFecha(notificacion.fecha),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        if (notificacion.otId != null) ...[
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              notificacion.otId!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTipoColor(TipoNotificacion tipo) {
    switch (tipo) {
      case TipoNotificacion.otAsignada:
        return Colors.blue;
      case TipoNotificacion.otCambioEstado:
        return Colors.purple;
      case TipoNotificacion.otPendienteCierre:
        return Colors.orange;
      case TipoNotificacion.otRechazada:
        return Colors.red;
      case TipoNotificacion.otAceptada:
        return Colors.green;
      case TipoNotificacion.tecnicoReasignado:
        return Colors.teal;
    }
  }

  IconData _getTipoIcon(TipoNotificacion tipo) {
    switch (tipo) {
      case TipoNotificacion.otAsignada:
        return Icons.assignment_ind_rounded;
      case TipoNotificacion.otCambioEstado:
        return Icons.sync_rounded;
      case TipoNotificacion.otPendienteCierre:
        return Icons.pending_actions_rounded;
      case TipoNotificacion.otRechazada:
        return Icons.cancel_rounded;
      case TipoNotificacion.otAceptada:
        return Icons.check_circle_rounded;
      case TipoNotificacion.tecnicoReasignado:
        return Icons.swap_horiz_rounded;
    }
  }

  String _formatFecha(DateTime fecha) {
    final diferencia = DateTime.now().difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Justo ahora';
    } else if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays}d';
    } else {
      return '${fecha.day}/${fecha.month}/${fecha.year}';
    }
  }
}
