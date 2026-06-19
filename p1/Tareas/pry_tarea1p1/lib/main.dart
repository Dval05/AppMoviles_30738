// ============================================================
// MAIN - Punto de entrada con Menú Lateral (Drawer)
// Tarea 1: Ejercicios 5, 6, 8, 9 y 10
// Patrón MVC + Atomic Design
// ============================================================

import 'package:flutter/material.dart';
import 'view/view_tarea.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 1 - Ejercicios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
    );
  }
}

/// Página principal con el Drawer (Menú Lateral)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MENÚ LATERAL'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      drawer: const MenuLateral(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.apps_rounded, size: 70, color: Colors.blue),
              const SizedBox(height: 20),
              const Text(
                'Tarea 1',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Seleccione un ejercicio desde\nel menú lateral',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              _buildExerciseItem(context, '5', 'Conversor de Longitud',
                  Icons.straighten),
              const SizedBox(height: 6),
              _buildExerciseItem(context, '6', 'Capacidad de Disco',
                  Icons.storage),
              const SizedBox(height: 6),
              _buildExerciseItem(context, '8', 'Compañía de Seguros',
                  Icons.account_balance),
              const SizedBox(height: 6),
              _buildExerciseItem(context, '9', 'Producción Semanal',
                  Icons.factory),
              const SizedBox(height: 6),
              _buildExerciseItem(context, '10', 'Promoción Supermercado',
                  Icons.local_offer),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseItem(
      BuildContext context, String number, String title, IconData icon) {
    return InkWell(
      onTap: () {
        Widget page;
        switch (number) {
          case '5':
            page = const Ejercicio5Page();
            break;
          case '6':
            page = const Ejercicio6Page();
            break;
          case '8':
            page = const Ejercicio8Page();
            break;
          case '9':
            page = const Ejercicio9Page();
            break;
          case '10':
            page = const Ejercicio10Page();
            break;
          default:
            return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 22),
            const SizedBox(width: 10),
            Text('Ej. $number - $title',
                style: const TextStyle(fontSize: 15)),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}

/// Menú Lateral (Drawer) corregido y funcional
class MenuLateral extends StatelessWidget {
  const MenuLateral({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Encabezado del Drawer
          const UserAccountsDrawerHeader(
            accountName: Text(
              'TAREA 1 - APP MÓVILES',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),

          // Opción: Inicio
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
                (route) => false,
              );
            },
          ),

          const Divider(),

          // Ejercicio 5
          _buildDrawerItem(
            context,
            icon: Icons.straighten,
            title: 'Ej. 5 - Conversor de Longitud',
            page: const Ejercicio5Page(),
          ),

          // Ejercicio 6
          _buildDrawerItem(
            context,
            icon: Icons.storage,
            title: 'Ej. 6 - Capacidad de Disco',
            page: const Ejercicio6Page(),
          ),

          // Ejercicio 8
          _buildDrawerItem(
            context,
            icon: Icons.account_balance,
            title: 'Ej. 8 - Compañía de Seguros',
            page: const Ejercicio8Page(),
          ),

          // Ejercicio 9
          _buildDrawerItem(
            context,
            icon: Icons.factory,
            title: 'Ej. 9 - Producción Semanal',
            page: const Ejercicio9Page(),
          ),

          // Ejercicio 10
          _buildDrawerItem(
            context,
            icon: Icons.local_offer,
            title: 'Ej. 10 - Promoción Supermercado',
            page: const Ejercicio10Page(),
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Tarea 1 - Parcial 1\nApp Móviles - ESPE',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios,
          color: Colors.grey, size: 14),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}