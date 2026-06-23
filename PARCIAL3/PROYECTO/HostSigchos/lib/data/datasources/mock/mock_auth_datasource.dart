import 'dart:typed_data';
import '../../models/usuario_model.dart';
import '../firebase/auth_datasource.dart';

class MockAuthDataSource implements AuthDataSource {
  UsuarioModel? _usuarioActual;

  @override
  Stream<UsuarioModel?> get authStateChanges async* {
    yield _usuarioActual;
  }

  @override
  Future<UsuarioModel> loginConEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _usuarioActual = UsuarioModel(
      id: 'user123',
      nombre: 'Viajero Local',
      email: email,
      fechaRegistro: DateTime.now(),
      fotoUrl: 'https://ui-avatars.com/api/?name=Viajero+Local',
    );
    return _usuarioActual!;
  }

  @override
  Future<UsuarioModel> registrarse({
    required String nombre,
    required String email,
    required String password,
    required String cedula,
    DateTime? fechaNacimiento,
    String? telefono,
    String? ubicacion,
    Uint8List? fotoBytes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _usuarioActual = UsuarioModel(
      id: 'user123',
      nombre: nombre,
      email: email,
      cedula: cedula,
      fechaNacimiento: fechaNacimiento,
      telefono: telefono,
      ubicacion: ubicacion,
      fechaRegistro: DateTime.now(),
    );
    return _usuarioActual!;
  }

  @override
  Future<UsuarioModel> loginConGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    _usuarioActual = UsuarioModel(
      id: 'google123',
      nombre: 'Usuario Google',
      email: 'test@gmail.com',
      fechaRegistro: DateTime.now(),
      fotoUrl: 'https://ui-avatars.com/api/?name=Usuario+Google',
    );
    return _usuarioActual!;
  }

  @override
  Future<void> cerrarSesion() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _usuarioActual = null;
  }

  @override
  Future<UsuarioModel?> getUsuarioActual() async {
    return _usuarioActual;
  }

  @override
  Future<UsuarioModel> actualizarPerfil({
    required String uid,
    String? nombre,
    String? cedula,
    DateTime? fechaNacimiento,
    String? telefono,
    String? ubicacion,
    Uint8List? fotoBytes,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (_usuarioActual != null && _usuarioActual!.id == uid) {
      _usuarioActual = UsuarioModel(
        id: uid,
        nombre: nombre ?? _usuarioActual!.nombre,
        email: _usuarioActual!.email,
        cedula: cedula ?? _usuarioActual!.cedula,
        fechaNacimiento: fechaNacimiento ?? _usuarioActual!.fechaNacimiento,
        telefono: telefono ?? _usuarioActual!.telefono,
        ubicacion: ubicacion ?? _usuarioActual!.ubicacion,
        fotoUrl: _usuarioActual!.fotoUrl,
        fechaRegistro: _usuarioActual!.fechaRegistro,
        idioma: _usuarioActual!.idioma,
      );
      return _usuarioActual!;
    }
    throw Exception('Usuario no encontrado');
  }
}
