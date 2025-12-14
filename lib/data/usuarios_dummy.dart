import '../models/usuario.dart';

final List<Usuario> usuariosDummy = [
  // Administrador
  Usuario(
    id: 'USR-001',
    nombre: 'Jorge Administrador',
    email: 'admin@mantenimiento.com',
    password: 'admin123',
    rol: Rol.administrador,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 365)),
  ),

  // Supervisor
  Usuario(
    id: 'USR-002',
    nombre: 'Ana Supervisor',
    email: 'supervisor@mantenimiento.com',
    password: 'super123',
    rol: Rol.supervisor,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 200)),
  ),

  // Técnicos
  Usuario(
    id: 'TEC-001',
    nombre: 'Carlos Rodríguez',
    email: 'carlos.rodriguez@mantenimiento.com',
    password: 'tec123',
    rol: Rol.tecnico,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 180)),
  ),

  Usuario(
    id: 'TEC-002',
    nombre: 'Ana Martínez',
    email: 'ana.martinez@mantenimiento.com',
    password: 'tec123',
    rol: Rol.tecnico,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 150)),
  ),

  Usuario(
    id: 'TEC-003',
    nombre: 'Roberto López',
    email: 'roberto.lopez@mantenimiento.com',
    password: 'tec123',
    rol: Rol.tecnico,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 120)),
  ),

  Usuario(
    id: 'TEC-004',
    nombre: 'Luis Fernández',
    email: 'luis.fernandez@mantenimiento.com',
    password: 'tec123',
    rol: Rol.tecnico,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 90)),
  ),

  // Solicitantes
  Usuario(
    id: 'SOL-001',
    nombre: 'María García',
    email: 'maria.garcia@empresa.com',
    password: 'sol123',
    rol: Rol.solicitante,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 60)),
  ),

  Usuario(
    id: 'SOL-002',
    nombre: 'Juan Pérez',
    email: 'juan.perez@empresa.com',
    password: 'sol123',
    rol: Rol.solicitante,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 50)),
  ),

  Usuario(
    id: 'SOL-003',
    nombre: 'Laura Sánchez',
    email: 'laura.sanchez@empresa.com',
    password: 'sol123',
    rol: Rol.solicitante,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 40)),
  ),

  Usuario(
    id: 'SOL-004',
    nombre: 'Pedro Ramírez',
    email: 'pedro.ramirez@empresa.com',
    password: 'sol123',
    rol: Rol.solicitante,
    fechaCreacion: DateTime.now().subtract(const Duration(days: 30)),
  ),
];
