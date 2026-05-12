import 'package:flutter/material.dart';
import '../atomos/label_app.dart';
import '../atomos/checkbox_app.dart';

class OpcionesAdicionales extends StatelessWidget {
  final bool aplicaRecargo;
  final bool aplicaServicioAdicional;
  final ValueChanged<bool?> onRecargoChanged;
  final ValueChanged<bool?> onServicioAdicionalChanged;

  const OpcionesAdicionales({
    super.key,
    required this.aplicaRecargo,
    required this.aplicaServicioAdicional,
    required this.onRecargoChanged,
    required this.onServicioAdicionalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelApp(
          'Opciones adicionales',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        CheckboxApp(
          texto: 'Aplicar recargo',
          valor: aplicaRecargo,
          onChanged: onRecargoChanged,
        ),
        CheckboxApp(
          texto: 'Aplicar servicio adicional',
          valor: aplicaServicioAdicional,
          onChanged: onServicioAdicionalChanged,
        ),
      ],
    );
  }
}