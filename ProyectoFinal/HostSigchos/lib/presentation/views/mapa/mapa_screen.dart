import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../domain/entities/hosteria.dart';
import '../../../themes/esquema_color.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/hosteria_viewmodel.dart';
import '../../../core/services/routing_service.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();
  final RoutingService _routingService = RoutingService();

  List<LatLng> _rutaActual = [];
  LatLng? _ubicacionUsuario;
  bool _isLoadingRuta = false;
  
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    // Cargar hosterías si no están cargadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hosteriaVm = context.read<HosteriaViewModel>();
      if (hosteriaVm.todasHosterias.isEmpty) {
        hosteriaVm.cargarHosterias();
      }
    });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _trazarRuta(Hosteria hosteria) async {
    setState(() {
      _isLoadingRuta = true;
    });

    try {
      // Pedir permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Permiso de ubicación denegado.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permisos de ubicación denegados permanentemente.');
      }

      // Obtener ubicación actual
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final origen = LatLng(position.latitude, position.longitude);
      final destino = LatLng(hosteria.latitud, hosteria.longitud);

      // Obtener ruta
      final ruta = await _routingService.getRoute(origen, destino);

      setState(() {
        _ubicacionUsuario = origen;
        _rutaActual = ruta;
      });

      // Encuadrar la cámara para mostrar origen y destino
      if (ruta.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints([origen, destino, ...ruta]);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50.0),
          ),
        );
      } else {
        throw Exception('No se pudo encontrar una ruta.');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al trazar la ruta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRuta = false;
        });
      }
    }
  }

  void _toggleTracking() {
    if (_isTracking) {
      // Detener seguimiento
      _positionStream?.cancel();
      setState(() {
        _isTracking = false;
      });
    } else {
      // Iniciar seguimiento
      setState(() {
        _isTracking = true;
      });

      // Si tenemos ubicación, acercar el zoom al usuario
      if (_ubicacionUsuario != null) {
        _mapController.move(_ubicacionUsuario!, 17.0);
      }

      // Suscribirse a cambios de ubicación
      _positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5, // Notificar cada 5 metros
        ),
      ).listen((Position position) {
        if (mounted && _isTracking) {
          final nuevaUbicacion = LatLng(position.latitude, position.longitude);
          setState(() {
            _ubicacionUsuario = nuevaUbicacion;
          });
          // Centrar la cámara en la nueva ubicación
          _mapController.move(nuevaUbicacion, 17.0);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hosteriaVm = context.watch<HosteriaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.hotelMap),
        centerTitle: true,
      ),
      body: hosteriaVm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: const MapOptions(
                    initialCenter: LatLng(
                      AppConstants.sigchosLatitud,
                      AppConstants.sigchosLongitud,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.hostsigchos',
                    ),
                    if (_rutaActual.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: _rutaActual,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        ...hosteriaVm.todasHosterias.map((hosteria) {
                          return Marker(
                            point: LatLng(hosteria.latitud, hosteria.longitud),
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                _mostrarInfoHosteria(context, hosteria);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ColorSchemeApp.primaryGreen,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.home_work_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 6,
                                    color: ColorSchemeApp.primaryGreen,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        if (_ubicacionUsuario != null)
                          Marker(
                            point: _ubicacionUsuario!,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.my_location,
                              color: Colors.blue,
                              size: 30,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (_isLoadingRuta)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Calculando ruta...'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: _rutaActual.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _toggleTracking,
              backgroundColor: _isTracking ? Colors.red : ColorSchemeApp.primaryGreen,
              icon: Icon(
                _isTracking ? Icons.stop : Icons.navigation,
                color: Colors.white,
              ),
              label: Text(
                _isTracking ? 'Detener' : 'Seguir Ruta',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  void _mostrarInfoHosteria(BuildContext context, Hosteria hosteria) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hosteria.nombre,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorSchemeApp.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hosteria.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: ColorSchemeApp.softGray),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar modal
                    // Redirigir al detalle de la hosteria
                    context.read<HosteriaViewModel>().cargarHosteriaDetalle(
                      hosteria.id,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.habitaciones,
                      arguments: hosteria.id,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorSchemeApp.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(AppLocalizations.of(context)!.reservationDetails),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context); // Cerrar modal
                    _trazarRuta(hosteria); // Llamar a nuestra nueva función
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorSchemeApp.primaryGreen,
                    side: const BorderSide(color: ColorSchemeApp.primaryGreen),
                  ),
                  icon: const Icon(Icons.directions),
                  label: Text(AppLocalizations.of(context)!.getDirections),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
