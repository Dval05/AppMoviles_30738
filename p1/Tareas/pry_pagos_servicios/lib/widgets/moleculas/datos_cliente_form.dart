import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../atomos/campo_texto_app.dart';
import '../atomos/label_app.dart';

class DatosClienteForm extends StatelessWidget {
  final TextEditingController nombreController;
  final TextEditingController cedulaController;
  final TextEditingController valorBaseController;

  const DatosClienteForm({
    super.key,
    required this.nombreController,
    required this.cedulaController,
    required this.valorBaseController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelApp(
          'Datos del cliente',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 12),
        CampoTextoApp(
          controller: nombreController,
          label: 'Nombre del cliente',
        ),
        const SizedBox(height: 12),
        CampoTextoApp(
          controller: cedulaController,
          label: 'Cédula del cliente',
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        const SizedBox(height: 12),
        CampoTextoApp(
          controller: valorBaseController,
          label: 'Consumo o valor base',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
