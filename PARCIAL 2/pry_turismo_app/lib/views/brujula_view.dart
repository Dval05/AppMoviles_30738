import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../viewmodels/turismo_viewmodel.dart';

class BrujulaView extends StatelessWidget {
  const BrujulaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.cargando) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D7377)),
            ),
          );
        }

        double direccion = viewModel.rumbo ?? 0;
        bool tieneSitioSeleccionado = viewModel.sitioSeleccionado != null;
        double? azimutHacia = viewModel.azimutHaciaSitio;

        return Container(
          color: const Color(0xFFFAFAFA),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Información del sitio seleccionado
                    if (tieneSitioSeleccionado) ...[
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF0D7377).withOpacity(0.05),
                                const Color(0xFF0D7377).withOpacity(0.02),
                              ],
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Navegando hacia',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                viewModel.sitioSeleccionado!.nombre,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D7377),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: const Color(0xFF0D7377),
                                        size: 28,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Distancia',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        viewModel.formatearDistancia(
                                          viewModel.obtenerDistancia(
                                            viewModel.sitioSeleccionado!,
                                          ),
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0D7377),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.compass_calibration,
                                        color: const Color(0xFFFFA500),
                                        size: 28,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Dirección',
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        viewModel.obtenerDireccionCardinal(
                                          viewModel.sitioSeleccionado!,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFFFA500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Selecciona un sitio para navegar',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Información del rumbo actual
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tu orientación',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${direccion.toStringAsFixed(1)}°',
                            style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0D7377),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _obtenerDireccionDesdeRumbo(direccion),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFFA500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Brújula visual
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.rotate(
                          angle: (direccion * (math.pi / 180) * -1),
                          child: Container(
                            width: 280,
                            height: 280,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: const Color(0xFF0D7377),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0D7377)
                                      .withOpacity(0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Marcas de dirección
                                Positioned(
                                  top: 20,
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.arrow_upward,
                                        color: Color(0xFF0D7377),
                                        size: 32,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'N',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0D7377),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Brújula visual
                                Image.network(
                                  'https://cdn-icons-png.flaticon.com/512/149/149455.png',
                                  width: 240,
                                  height: 240,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Flecha central
                        const Icon(
                          Icons.arrow_upward,
                          size: 50,
                          color: Color(0xFFFFA500),
                        ),
                        // Flecha hacia el sitio si está seleccionado
                        if (tieneSitioSeleccionado && azimutHacia != null)
                          Transform.rotate(
                            angle:
                                ((azimutHacia! - direccion) * (math.pi / 180) *
                                    -1),
                            child: Container(
                              width: 4,
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.4),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(top: 70),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    Text(
                      tieneSitioSeleccionado
                          ? 'La flecha roja apunta a tu destino'
                          : 'Apunta tu dispositivo para orientarte',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    if (tieneSitioSeleccionado) ...[
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => viewModel.limpiarRuta(),
                          icon: const Icon(Icons.close),
                          label: const Text('Cancelar navegación'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _obtenerDireccionDesdeRumbo(double rumbo) {
    if (rumbo >= 337.5 || rumbo < 22.5) return "NORTE";
    if (rumbo >= 22.5 && rumbo < 67.5) return "NORESTE";
    if (rumbo >= 67.5 && rumbo < 112.5) return "ESTE";
    if (rumbo >= 112.5 && rumbo < 157.5) return "SURESTE";
    if (rumbo >= 157.5 && rumbo < 202.5) return "SUR";
    if (rumbo >= 202.5 && rumbo < 247.5) return "SUROESTE";
    if (rumbo >= 247.5 && rumbo < 292.5) return "OESTE";
    if (rumbo >= 292.5 && rumbo < 337.5) return "NOROESTE";
    return "NORTE";
  }
}
