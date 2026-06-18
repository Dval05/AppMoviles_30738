import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/turismo_viewmodel.dart';

class BrujulaView extends StatelessWidget {
  const BrujulaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurismoViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.cargando) {
          return const Center(child: CircularProgressIndicator());
        }

        double direccion = viewModel.rumbo ?? 0;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${direccion.toStringAsFixed(0)}°',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.rotate(
                    angle: (direccion * (math.pi / 180) * -1),
                    child: Image.network(
                      'https://cdn-icons-png.flaticon.com/512/149/149455.png', // Imagen de brújula
                      width: 300,
                      height: 300,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.explore, size: 300, color: Colors.teal),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_upward,
                    size: 50,
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Apunta tu dispositivo para orientarte',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
