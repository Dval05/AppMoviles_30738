import 'package:geolocator/geolocator.dart';
import '../models/sitio_turistico.dart';

class TurismoService {
  // Lista de sitios turísticos (Simulada para el ejercicio)
  final List<SitioTuristico> _sitios = [
    SitioTuristico(
      nombre: "Parque Central",
      descripcion: "Un lugar hermoso para descansar y disfrutar la naturaleza.",
      latitud: -0.2105,
      longitud: -78.4890,
      imagenUrl: "https://images.unsplash.com/photo-1549144464-f6eb00924190",
    ),
    SitioTuristico(
      nombre: "Mirador de la Loma",
      descripcion: "Vista panorámica de toda la ciudad.",
      latitud: -0.2150,
      longitud: -78.4950,
      imagenUrl: "https://images.unsplash.com/photo-1519046904884-53103b34b206",
    ),
    SitioTuristico(
      nombre: "Museo Histórico",
      descripcion: "Descubre la historia y cultura de la región.",
      latitud: -0.2080,
      longitud: -78.4850,
      imagenUrl: "https://images.unsplash.com/photo-1503174971373-b1f69850bbd6",
    ),
  ];

  List<SitioTuristico> obtenerSitios() => _sitios;

  double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  Future<Position> obtenerUbicacionActual() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están desactivados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación denegados permanentemente.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
