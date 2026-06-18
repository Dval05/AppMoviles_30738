import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../viewmodels/turismo_viewmodel.dart';

class MapaView extends StatelessWidget {
  const MapaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.posicionActual == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final miPosicion = LatLng(
          viewModel.posicionActual!.latitude,
          viewModel.posicionActual!.longitude,
        );

        return Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: miPosicion,
                initialZoom: 15,
              ),
              children: [
                // Capa de Mapa Gratuita (OpenStreetMap)
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.pry_turismo_app',
                ),
                
                // Capa de la Ruta (Si existe)
                if (viewModel.puntosRuta.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: viewModel.puntosRuta,
                        color: Colors.blueAccent,
                        strokeWidth: 6.0,
                        borderStrokeWidth: 2.0,
                        borderColor: Colors.white,
                      ),
                    ],
                  ),

                // Capa de Marcadores (Sitios y Usuario)
                MarkerLayer(
                  markers: [
                    // Marcador del Usuario
                    Marker(
                      point: miPosicion,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    ),
                    // Marcadores de Sitios Turísticos
                    ...viewModel.sitios.map((sitio) => Marker(
                      point: LatLng(sitio.latitud, sitio.longitud),
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _mostrarDetalleSitio(context, viewModel, sitio),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                      ),
                    )),
                  ],
                ),
              ],
            ),

            // Indicador de carga cuando se traza la ruta
            if (viewModel.cargando)
              const Center(child: CircularProgressIndicator()),

            // Botón para cancelar la ruta activa
            if (viewModel.sitioSeleccionado != null)
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton.extended(
                  onPressed: () => viewModel.limpiarRuta(),
                  label: const Text("Limpiar Ruta"),
                  icon: const Icon(Icons.close),
                  backgroundColor: Colors.redAccent,
                ),
              ),
          ],
        );
      },
    );
  }

  void _mostrarDetalleSitio(BuildContext context, TurismoViewModel vm, dynamic sitio) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(sitio.nombre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(sitio.descripcion, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Text("Distancia: ${vm.formatearDistancia(vm.obtenerDistancia(sitio))}", 
                 style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                vm.trazarRuta(sitio);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.directions),
              label: const Text("VER RUTA EN EL MAPA"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
