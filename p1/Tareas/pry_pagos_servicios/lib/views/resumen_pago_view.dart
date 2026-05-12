import 'package:flutter/material.dart';
import '../widgets/atomos/boton_principal.dart';
import '../widgets/atomos/label_app.dart';

class ResumenPagoView extends StatelessWidget {
  final String resumen;

  const ResumenPagoView({
    super.key,
    this.resumen = '',
  });

  @override
  Widget build(BuildContext context) {
    final String resumenFinal =
        resumen.isNotEmpty ? resumen : (ModalRoute.of(context)?.settings.arguments as String? ?? 'No existe resumen para mostrar');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen del Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const LabelApp(
                  'Resumen generado',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        resumenFinal,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                BotonPrincipal(
                  texto: 'Volver',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}