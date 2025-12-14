enum TipoNotificacion {
  otAsignada,
  otCambioEstado,
  otPendienteCierre,
  otRechazada,
  otAceptada,
  tecnicoReasignado,
}

class Notificacion {
  final String id;
  final String titulo;
  final String mensaje;
  final TipoNotificacion tipo;
  final DateTime fecha;
  final bool leida;
  final String? otId;
  final String? usuarioId;

  Notificacion({
    required this.id,
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.fecha,
    this.leida = false,
    this.otId,
    this.usuarioId,
  });

  Notificacion copyWith({
    String? id,
    String? titulo,
    String? mensaje,
    TipoNotificacion? tipo,
    DateTime? fecha,
    bool? leida,
    String? otId,
    String? usuarioId,
  }) {
    return Notificacion(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      mensaje: mensaje ?? this.mensaje,
      tipo: tipo ?? this.tipo,
      fecha: fecha ?? this.fecha,
      leida: leida ?? this.leida,
      otId: otId ?? this.otId,
      usuarioId: usuarioId ?? this.usuarioId,
    );
  }
}
