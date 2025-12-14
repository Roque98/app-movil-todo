enum EstadoOT {
  abierta,
  asignada,
  enProgreso,
  pausada,
  pendienteCierre,
  cerrada,
  rechazada,
}

enum Prioridad {
  critica,
  alta,
  media,
  baja,
}

enum TipoFalla {
  electrica,
  plomeria,
  climatizacion,
  estructural,
  limpieza,
  seguridad,
  tecnologia,
  otro,
}

class Material {
  final String id;
  final String nombre;
  final int cantidad;
  final double costoUnitario;

  Material({
    required this.id,
    required this.nombre,
    required this.cantidad,
    required this.costoUnitario,
  });

  double get costoTotal => cantidad * costoUnitario;
}

class OrdenTrabajo {
  // Información de Creación
  final String idOT;
  final DateTime fechaSolicitud;
  final String solicitanteId;
  final String solicitanteNombre;
  final String ubicacion;
  final double? latitud;
  final double? longitud;
  final TipoFalla tipoFalla;
  final Prioridad prioridadSolicitada;
  final String descripcionProblema;
  final List<String> archivosAdjuntos;

  // Información de Gestión
  final String? tecnicoAsignadoId;
  final String? tecnicoAsignadoNombre;
  final DateTime? fechaAsignacion;
  final Prioridad? prioridadAsignada;
  final Duration? slaTimeRespuesta;
  final DateTime? fechaCompromiso;
  final String? comentariosGestion;

  // Información de Seguimiento
  final EstadoOT estado;
  final DateTime? fechaHoraInicioReal;
  final DateTime? fechaHoraCierreTecnico;
  final String? descripcionTrabajoRealizado;
  final List<Material> materialesUsados;
  final List<String> fotosCierre;
  final Duration? tiempoTotalTrabajado;

  // Información de Cierre
  final bool? estatusAceptacion;
  final String? comentariosSolicitante;
  final DateTime? fechaCierreTotal;

  OrdenTrabajo({
    required this.idOT,
    required this.fechaSolicitud,
    required this.solicitanteId,
    required this.solicitanteNombre,
    required this.ubicacion,
    this.latitud,
    this.longitud,
    required this.tipoFalla,
    required this.prioridadSolicitada,
    required this.descripcionProblema,
    this.archivosAdjuntos = const [],
    this.tecnicoAsignadoId,
    this.tecnicoAsignadoNombre,
    this.fechaAsignacion,
    this.prioridadAsignada,
    this.slaTimeRespuesta,
    this.fechaCompromiso,
    this.comentariosGestion,
    required this.estado,
    this.fechaHoraInicioReal,
    this.fechaHoraCierreTecnico,
    this.descripcionTrabajoRealizado,
    this.materialesUsados = const [],
    this.fotosCierre = const [],
    this.tiempoTotalTrabajado,
    this.estatusAceptacion,
    this.comentariosSolicitante,
    this.fechaCierreTotal,
  });

  // Método copyWith para crear copias modificadas
  OrdenTrabajo copyWith({
    String? idOT,
    DateTime? fechaSolicitud,
    String? solicitanteId,
    String? solicitanteNombre,
    String? ubicacion,
    double? latitud,
    double? longitud,
    TipoFalla? tipoFalla,
    Prioridad? prioridadSolicitada,
    String? descripcionProblema,
    List<String>? archivosAdjuntos,
    String? tecnicoAsignadoId,
    String? tecnicoAsignadoNombre,
    DateTime? fechaAsignacion,
    Prioridad? prioridadAsignada,
    Duration? slaTimeRespuesta,
    DateTime? fechaCompromiso,
    String? comentariosGestion,
    EstadoOT? estado,
    DateTime? fechaHoraInicioReal,
    DateTime? fechaHoraCierreTecnico,
    String? descripcionTrabajoRealizado,
    List<Material>? materialesUsados,
    List<String>? fotosCierre,
    Duration? tiempoTotalTrabajado,
    bool? estatusAceptacion,
    String? comentariosSolicitante,
    DateTime? fechaCierreTotal,
  }) {
    return OrdenTrabajo(
      idOT: idOT ?? this.idOT,
      fechaSolicitud: fechaSolicitud ?? this.fechaSolicitud,
      solicitanteId: solicitanteId ?? this.solicitanteId,
      solicitanteNombre: solicitanteNombre ?? this.solicitanteNombre,
      ubicacion: ubicacion ?? this.ubicacion,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      tipoFalla: tipoFalla ?? this.tipoFalla,
      prioridadSolicitada: prioridadSolicitada ?? this.prioridadSolicitada,
      descripcionProblema: descripcionProblema ?? this.descripcionProblema,
      archivosAdjuntos: archivosAdjuntos ?? this.archivosAdjuntos,
      tecnicoAsignadoId: tecnicoAsignadoId ?? this.tecnicoAsignadoId,
      tecnicoAsignadoNombre: tecnicoAsignadoNombre ?? this.tecnicoAsignadoNombre,
      fechaAsignacion: fechaAsignacion ?? this.fechaAsignacion,
      prioridadAsignada: prioridadAsignada ?? this.prioridadAsignada,
      slaTimeRespuesta: slaTimeRespuesta ?? this.slaTimeRespuesta,
      fechaCompromiso: fechaCompromiso ?? this.fechaCompromiso,
      comentariosGestion: comentariosGestion ?? this.comentariosGestion,
      estado: estado ?? this.estado,
      fechaHoraInicioReal: fechaHoraInicioReal ?? this.fechaHoraInicioReal,
      fechaHoraCierreTecnico: fechaHoraCierreTecnico ?? this.fechaHoraCierreTecnico,
      descripcionTrabajoRealizado: descripcionTrabajoRealizado ?? this.descripcionTrabajoRealizado,
      materialesUsados: materialesUsados ?? this.materialesUsados,
      fotosCierre: fotosCierre ?? this.fotosCierre,
      tiempoTotalTrabajado: tiempoTotalTrabajado ?? this.tiempoTotalTrabajado,
      estatusAceptacion: estatusAceptacion ?? this.estatusAceptacion,
      comentariosSolicitante: comentariosSolicitante ?? this.comentariosSolicitante,
      fechaCierreTotal: fechaCierreTotal ?? this.fechaCierreTotal,
    );
  }

  double get costoTotalMateriales {
    return materialesUsados.fold(0.0, (sum, material) => sum + material.costoTotal);
  }

  String get estadoTexto {
    switch (estado) {
      case EstadoOT.abierta:
        return 'Abierta';
      case EstadoOT.asignada:
        return 'Asignada';
      case EstadoOT.enProgreso:
        return 'En Progreso';
      case EstadoOT.pausada:
        return 'Pausada';
      case EstadoOT.pendienteCierre:
        return 'Pendiente Cierre';
      case EstadoOT.cerrada:
        return 'Cerrada';
      case EstadoOT.rechazada:
        return 'Rechazada';
    }
  }

  String get prioridadTexto {
    final prioridad = prioridadAsignada ?? prioridadSolicitada;
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

  String get tipoFallaTexto {
    switch (tipoFalla) {
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
}
