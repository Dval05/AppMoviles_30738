import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mapa_view.dart';
import 'lista_sitios_view.dart';
import 'brujula_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _indiceActual = 0;

  final List<Widget> _vistas = [
    const MapaView(),
    const ListaSitiosView(),
    const BrujulaView(),
  ];

  final List<IconData> _iconos = [
    Icons.map,
    Icons.list_alt_rounded,
    Icons.explore_rounded,
  ];

  final List<String> _etiquetas = [
    'Mapa',
    'Sitios',
    'Brújula',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Turismo Local',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: _vistas[_indiceActual],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceActual,
          onTap: (index) {
            setState(() {
              _indiceActual = index;
            });
          },
          items: List.generate(
            _vistas.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(
                _iconos[index],
                size: 24,
              ),
              activeIcon: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D7377).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _iconos[index],
                  size: 24,
                  color: const Color(0xFF0D7377),
                ),
              ),
              label: _etiquetas[index],
            ),
          ),
        ),
      ),
    );
  }
}
