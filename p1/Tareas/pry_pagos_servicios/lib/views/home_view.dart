import 'package:flutter/material.dart';
import '../widgets/atomos/boton_principal.dart';
import '../widgets/atomos/label_app.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.payments_outlined,
                    size: 90,
                  ),
                  const SizedBox(height: 20),
                  const LabelApp(
                    'Aplicación 1',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const LabelApp(
                    'Sistema de pagos de servicios básicos',
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  BotonPrincipal(
                    texto: 'Iniciar registro',
                    onPressed: () {
                      Navigator.pushNamed(context, '/pago');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}