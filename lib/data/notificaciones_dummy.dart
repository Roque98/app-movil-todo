import '../models/notificacion.dart';

final List<Notificacion> notificacionesDummy = [
  // Notificaciones para Admin (USR-001)
  Notificacion(
    id: 'NOT-001',
    titulo: 'Nueva OT Creada',
    mensaje: 'María García creó la OT-2025-0001: Problema eléctrico en oficina 305',
    tipo: TipoNotificacion.otCambioEstado,
    fecha: DateTime.now().subtract(const Duration(hours: 2)),
    leida: false,
    otId: 'OT-2025-0001',
    usuarioId: 'USR-001',
  ),
  Notificacion(
    id: 'NOT-002',
    titulo: 'OT Pendiente de Cierre',
    mensaje: 'Carlos Rodríguez finalizó la OT-2025-0003 y espera aprobación',
    tipo: TipoNotificacion.otPendienteCierre,
    fecha: DateTime.now().subtract(const Duration(hours: 5)),
    leida: false,
    otId: 'OT-2025-0003',
    usuarioId: 'USR-001',
  ),

  // Notificaciones para Supervisor (USR-002)
  Notificacion(
    id: 'NOT-003',
    titulo: 'OT Asignada',
    mensaje: 'Se asignó la OT-2025-0002 a Ana Martínez',
    tipo: TipoNotificacion.otAsignada,
    fecha: DateTime.now().subtract(const Duration(hours: 1)),
    leida: false,
    otId: 'OT-2025-0002',
    usuarioId: 'USR-002',
  ),
  Notificacion(
    id: 'NOT-004',
    titulo: 'Trabajo Rechazado',
    mensaje: 'Juan Pérez rechazó el trabajo de la OT-2025-0005',
    tipo: TipoNotificacion.otRechazada,
    fecha: DateTime.now().subtract(const Duration(hours: 4)),
    leida: true,
    otId: 'OT-2025-0005',
    usuarioId: 'USR-002',
  ),

  // Notificaciones para Técnico Carlos (TEC-001)
  Notificacion(
    id: 'NOT-005',
    titulo: 'Nueva OT Asignada',
    mensaje: 'Se te asignó la OT-2025-0003: Fuga de agua en baño 2do piso',
    tipo: TipoNotificacion.otAsignada,
    fecha: DateTime.now().subtract(const Duration(minutes: 30)),
    leida: false,
    otId: 'OT-2025-0003',
    usuarioId: 'TEC-001',
  ),
  Notificacion(
    id: 'NOT-006',
    titulo: 'Trabajo Aceptado',
    mensaje: 'María García aceptó tu trabajo en la OT-2025-0001',
    tipo: TipoNotificacion.otAceptada,
    fecha: DateTime.now().subtract(const Duration(hours: 3)),
    leida: false,
    otId: 'OT-2025-0001',
    usuarioId: 'TEC-001',
  ),
  Notificacion(
    id: 'NOT-007',
    titulo: 'OT Reasignada',
    mensaje: 'La OT-2025-0004 fue reasignada a Roberto López',
    tipo: TipoNotificacion.tecnicoReasignado,
    fecha: DateTime.now().subtract(const Duration(days: 1)),
    leida: true,
    otId: 'OT-2025-0004',
    usuarioId: 'TEC-001',
  ),

  // Notificaciones para Solicitante María (SOL-001)
  Notificacion(
    id: 'NOT-008',
    titulo: 'OT Asignada a Técnico',
    mensaje: 'Tu OT-2025-0001 fue asignada a Carlos Rodríguez',
    tipo: TipoNotificacion.otAsignada,
    fecha: DateTime.now().subtract(const Duration(hours: 6)),
    leida: true,
    otId: 'OT-2025-0001',
    usuarioId: 'SOL-001',
  ),
  Notificacion(
    id: 'NOT-009',
    titulo: 'Trabajo Iniciado',
    mensaje: 'Carlos Rodríguez comenzó a trabajar en tu OT-2025-0001',
    tipo: TipoNotificacion.otCambioEstado,
    fecha: DateTime.now().subtract(const Duration(hours: 4)),
    leida: false,
    otId: 'OT-2025-0001',
    usuarioId: 'SOL-001',
  ),
  Notificacion(
    id: 'NOT-010',
    titulo: 'Trabajo Finalizado - Requiere Aprobación',
    mensaje: 'Carlos Rodríguez finalizó el trabajo en tu OT-2025-0001. Por favor revisa y acepta o rechaza.',
    tipo: TipoNotificacion.otPendienteCierre,
    fecha: DateTime.now().subtract(const Duration(minutes: 15)),
    leida: false,
    otId: 'OT-2025-0001',
    usuarioId: 'SOL-001',
  ),

  // Notificaciones para otros técnicos
  Notificacion(
    id: 'NOT-011',
    titulo: 'Nueva OT Asignada',
    mensaje: 'Se te asignó la OT-2025-0002: Mantenimiento de aire acondicionado',
    tipo: TipoNotificacion.otAsignada,
    fecha: DateTime.now().subtract(const Duration(hours: 8)),
    leida: true,
    otId: 'OT-2025-0002',
    usuarioId: 'TEC-002',
  ),
];
