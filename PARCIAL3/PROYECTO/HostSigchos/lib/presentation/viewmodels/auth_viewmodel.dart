import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../domain/entities/usuario.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../domain/usecases/auth/register_usecase.dart';
import '../../../domain/usecases/auth/google_signin_usecase.dart';
import '../../../domain/usecases/auth/logout_usecase.dart';
import '../../../domain/usecases/auth/actualizar_perfil_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final LogoutUseCase logoutUseCase;
  final ActualizarPerfilUseCase actualizarPerfilUseCase;

  Usuario? _usuarioActual;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.googleSignInUseCase,
    required this.logoutUseCase,
    required this.actualizarPerfilUseCase,
  });

  Usuario? get usuarioActual => _usuarioActual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setUsuarioActual(Usuario? usuario) {
    _usuarioActual = usuario;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      _usuarioActual = await loginUseCase(email, password);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register({
    required String nombre,
    required String email,
    required String password,
    required String cedula,
    DateTime? fechaNacimiento,
    String? telefono,
    String? ubicacion,
    Uint8List? fotoBytes,
  }) async {
    _setLoading(true);
    try {
      _usuarioActual = await registerUseCase(
        nombre: nombre,
        email: email,
        password: password,
        cedula: cedula,
        fechaNacimiento: fechaNacimiento,
        telefono: telefono,
        ubicacion: ubicacion,
        fotoBytes: fotoBytes,
      );
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginConGoogle() async {
    _setLoading(true);
    try {
      _usuarioActual = await googleSignInUseCase();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await logoutUseCase();
      _usuarioActual = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> actualizarPerfil({
    required String uid,
    String? nombre,
    String? cedula,
    DateTime? fechaNacimiento,
    String? telefono,
    String? ubicacion,
    Uint8List? fotoBytes,
  }) async {
    _setLoading(true);
    try {
      _usuarioActual = await actualizarPerfilUseCase(
        uid: uid,
        nombre: nombre,
        cedula: cedula,
        fechaNacimiento: fechaNacimiento,
        telefono: telefono,
        ubicacion: ubicacion,
        fotoBytes: fotoBytes,
      );
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
