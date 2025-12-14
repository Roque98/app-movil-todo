import '../models/usuario.dart';
import '../data/usuarios_dummy.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  Usuario? _usuarioActual;

  Usuario? get usuarioActual => _usuarioActual;
  bool get estaAutenticado => _usuarioActual != null;

  // Login
  Future<bool> login(String email, String password) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 1));

    try {
      final usuario = usuariosDummy.firstWhere(
        (u) => u.email == email && u.password == password && u.activo,
      );
      _usuarioActual = usuario;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Logout
  void logout() {
    _usuarioActual = null;
  }

  // Verificar si el usuario tiene un permiso
  bool tienePermiso(Permiso permiso) {
    if (_usuarioActual == null) return false;
    return _usuarioActual!.tienePermiso(permiso);
  }

  // Verificar si el usuario tiene un rol específico
  bool esRol(Rol rol) {
    if (_usuarioActual == null) return false;
    return _usuarioActual!.rol == rol;
  }
}
