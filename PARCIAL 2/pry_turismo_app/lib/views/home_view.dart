import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turismo Local'),
      ),
      body: _vistas[_indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceActual,
        onTap: (index) {
          setState(() {
            _indiceActual = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Sitios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Brújula',
          ),
        ],
      ),
    );
  }
}
