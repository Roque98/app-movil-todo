enum Rol {
  administrador,
  supervisor,
  tecnico,
  solicitante,
}

enum Permiso {
  // Gestión de OTs
  crearOT,
  verTodasOT,
  verMisOT,
  asignarOT,
  editarOT,
  eliminarOT,
  cerrarOT,
  aceptarRechazarOT,

  // Gestión de usuarios
  crearUsuario,
  editarUsuario,
  eliminarUsuario,
  verUsuarios,

  // Reportes
  verReportes,
  exportarReportes,
  verDashboard,

  // Inventario
  gestionarInventario,
  verInventario,

  // Configuración
  configurarSistema,
}

class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String password;
  final Rol rol;
  final String? foto;
  final bool activo;
  final DateTime fechaCreacion;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.rol,
    this.foto,
    this.activo = true,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  // Obtener permisos según el rol
  List<Permiso> get permisos {
    switch (rol) {
      case Rol.administrador:
        return [
          // Todos los permisos
          Permiso.crearOT,
          Permiso.verTodasOT,
          Permiso.verMisOT,
          Permiso.asignarOT,
          Permiso.editarOT,
          Permiso.eliminarOT,
          Permiso.cerrarOT,
          Permiso.aceptarRechazarOT,
          Permiso.crearUsuario,
          Permiso.editarUsuario,
          Permiso.eliminarUsuario,
          Permiso.verUsuarios,
          Permiso.verReportes,
          Permiso.exportarReportes,
          Permiso.verDashboard,
          Permiso.gestionarInventario,
          Permiso.verInventario,
          Permiso.configurarSistema,
        ];

      case Rol.supervisor:
        return [
          Permiso.crearOT,
          Permiso.verTodasOT,
          Permiso.verMisOT,
          Permiso.asignarOT,
          Permiso.editarOT,
          Permiso.cerrarOT,
          Permiso.verReportes,
          Permiso.exportarReportes,
          Permiso.verDashboard,
          Permiso.verInventario,
        ];

      case Rol.tecnico:
        return [
          Permiso.verMisOT,
          Permiso.editarOT,
          Permiso.cerrarOT,
          Permiso.verInventario,
          Permiso.verDashboard,
        ];

      case Rol.solicitante:
        return [
          Permiso.crearOT,
          Permiso.verMisOT,
          Permiso.aceptarRechazarOT,
        ];
    }
  }

  bool tienePermiso(Permiso permiso) {
    return permisos.contains(permiso);
  }

  String get rolTexto {
    switch (rol) {
      case Rol.administrador:
        return 'Administrador';
      case Rol.supervisor:
        return 'Supervisor';
      case Rol.tecnico:
        return 'Técnico';
      case Rol.solicitante:
        return 'Solicitante';
    }
  }
}
