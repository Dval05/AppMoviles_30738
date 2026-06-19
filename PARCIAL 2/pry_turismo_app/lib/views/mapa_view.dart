import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../viewmodels/turismo_viewmodel.dart';

class MapaView extends StatelessWidget {
  const MapaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.posicionActual == null) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D7377)),
            ),
          );
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
                // Capa de Mapa
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.pry_turismo_app',
                ),
                
                // Capa de la Ruta
                if (viewModel.puntosRuta.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: viewModel.puntosRuta,
                        color: const Color(0xFF0D7377),
                        strokeWidth: 5.0,
                        borderStrokeWidth: 2.0,
                        borderColor: Colors.white,
                      ),
                    ],
                  ),

                // Capa de Marcadores
                MarkerLayer(
                  markers: [
                    // Marcador del Usuario
                    Marker(
                      point: miPosicion,
                      width: 45,
                      height: 45,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 45,
                        ),
                      ),
                    ),
                    // Marcadores de Sitios
                    ...viewModel.sitiosCercanos.map((sitio) {
                      final esSitioSeleccionado =
                          viewModel.sitioSeleccionado?.nombre == sitio.nombre;
                      return Marker(
                        point: LatLng(sitio.latitud, sitio.longitud),
                        width: esSitioSeleccionado ? 60 : 50,
                        height: esSitioSeleccionado ? 60 : 50,
                        child: GestureDetector(
                          onTap: () => _mostrarDetalleSitio(
                            context,
                            viewModel,
                            sitio,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (esSitioSeleccionado)
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.yellow,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withOpacity(0.4),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              Icon(
                                Icons.location_on,
                                color: esSitioSeleccionado
                                    ? Colors.orange
                                    : Colors.red,
                                size: esSitioSeleccionado ? 45 : 35,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),

            // Indicador de carga
            if (viewModel.cargando)
              const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF0D7377)),
                ),
              ),

            // Información superior
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lugares cercanos',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${viewModel.sitiosCercanos.length} sitios',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D7377),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF0D7377),
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),

            // Botón para limpiar ruta
            if (viewModel.sitioSeleccionado != null)
              Positioned(
                bottom: 20,
                right: 140,
                child: FloatingActionButton.extended(
                  onPressed: () => viewModel.limpiarRuta(),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.close),
                  label: const Text('Limpiar'),
                ),
              ),

            // Brújula como overlay en esquina inferior derecha
            _construirBrujulaOverlay(viewModel),

            // Indicador de sitio seleccionado
            if (viewModel.sitioSeleccionado != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 80,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D7377),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Navegando hacia:',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        viewModel.sitioSeleccionado!.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// Construye la brújula como overlay en la esquina inferior derecha
  Widget _construirBrujulaOverlay(TurismoViewModel viewModel) {
    // Definimos valores seguros por si vienen nulos de tu ViewModel
    final double rumboSeguro = viewModel.rumbo ?? 0.0;
    final double azimutSeguro = viewModel.azimutHaciaSitio ?? 0.0;

    return Positioned(
      bottom: 20,
      right: 20,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF0D7377),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Brújula de referencia (rotada según el dispositivo)
            Transform.rotate(
              angle: (rumboSeguro * math.pi / 180), // <- Cambiado a rumboSeguro
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Marcadores de direcciones cardinales (N)
                    Positioned(
                      top: 8,
                      child: Container(
                        width: 8,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D7377),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Flecha central
                    const Icon(
                      Icons.arrow_upward,
                      color: Color(0xFFFFA500),
                      size: 32,
                    ),
                  ],
                ),
              ),
            ),
            // Flecha roja hacia el destino si hay sitio seleccionado
            if (viewModel.sitioSeleccionado != null)
              Transform.rotate(
                angle: (azimutSeguro * math.pi / 180) -
                    (rumboSeguro * math.pi / 180), // <- Usando variables seguras
                child: Container(
                  width: 3,
                  height: 40,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalleSitio(
    BuildContext context,
    TurismoViewModel vm,
    dynamic sitio,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nombre
              Text(
                sitio.nombre,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D7377),
                ),
              ),
              const SizedBox(height: 12),
              // Descripción
              Text(
                sitio.descripcion,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              // Información en dos columnas
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Distancia',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D7377).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            vm.formatearDistancia(vm.obtenerDistancia(sitio)),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D7377),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dirección',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFA500).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            vm.obtenerDireccionCardinal(sitio),
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFA500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Botón de navegación
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    vm.trazarRuta(sitio);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.directions),
                  label: const Text('Navegar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D7377),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
