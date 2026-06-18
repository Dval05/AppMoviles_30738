import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:latlong2/latlong.dart';
import '../models/sitio_turistico.dart';
import '../services/turismo_service.dart';
import '../services/ruta_service.dart';

class TurismoViewModel extends ChangeNotifier {
  final TurismoService _service = TurismoService();
  final RutaService _rutaService = RutaService();

  Position? _posicionActual;
  List<SitioTuristico> _sitios = [];
  double? _rumbo;
  bool _cargando = false;
  String? _error;
  
  // Lista de puntos para la ruta (Polyline)
  List<LatLng> _puntosRuta = [];
  SitioTuristico? _sitioSeleccionado;

  Position? get posicionActual => _posicionActual;
  List<SitioTuristico> get sitios => _sitios;
  double? get rumbo => _rumbo;
  bool get cargando => _cargando;
  String? get error => _error;
  List<LatLng> get puntosRuta => _puntosRuta;
  SitioTuristico? get sitioSeleccionado => _sitioSeleccionado;

  TurismoViewModel() {
    inicializar();
  }

  Future<void> inicializar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _posicionActual = await _service.obtenerUbicacionActual();
      _sitios = _service.obtenerSitios();
      
      // Escuchar cambios en la brújula
      FlutterCompass.events?.listen((event) {
        _rumbo = event.heading;
        notifyListeners();
      });

      // Escuchar cambios de posición
      Geolocator.getPositionStream().listen((Position position) {
        _posicionActual = position;
        notifyListeners();
      });

    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // Trazar ruta hacia un sitio específico
  Future<void> trazarRuta(SitioTuristico sitio) async {
    if (_posicionActual == null) return;
    
    _cargando = true;
    _sitioSeleccionado = sitio;
    _puntosRuta = [];
    notifyListeners();

    try {
      final inicio = LatLng(_posicionActual!.latitude, _posicionActual!.longitude);
      final destino = LatLng(sitio.latitud, sitio.longitud);
      
      _puntosRuta = await _rutaService.obtenerPuntosRuta(inicio, destino);
      
      if (_puntosRuta.isEmpty) {
        _error = "No se pudo encontrar una ruta.";
      }
    } catch (e) {
      _error = "Error al trazar la ruta: $e";
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiarRuta() {
    _puntosRuta = [];
    _sitioSeleccionado = null;
    notifyListeners();
  }

  double obtenerDistancia(SitioTuristico sitio) {
    if (_posicionActual == null) return 0;
    return _service.calcularDistancia(
      _posicionActual!.latitude,
      _posicionActual!.longitude,
      sitio.latitud,
      sitio.longitud,
    );
  }

  String formatearDistancia(double metros) {
    if (metros < 1000) {
      return "${metros.toStringAsFixed(0)} m";
    } else {
      return "${(metros / 1000).toStringAsFixed(2)} km";
    }
  }
}
