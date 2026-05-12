import 'package:flutter/material.dart';
import '../atomos/label_app.dart';
import '../atomos/radio_opcion_app.dart';

class SelectorServicio extends StatelessWidget {
  final String tipoServicio;
  final ValueChanged<String?> onChanged;

  const SelectorServicio({
    super.key,
    required this.tipoServicio,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelApp(
          'Tipo de servicio',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        RadioOpcionApp(
          titulo: 'Agua potable',
          valor: 'Agua potable',
          grupoValor: tipoServicio,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'Energía eléctrica',
          valor: 'Energía eléctrica',
          grupoValor: tipoServicio,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'Internet y telefonía',
          valor: 'Internet y telefonía',
          grupoValor: tipoServicio,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'TV por cable y streaming',
          valor: 'TV por cable y streaming',
          grupoValor: tipoServicio,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'Otros pagos frecuentes',
          valor: 'Otros pagos frecuentes',
          grupoValor: tipoServicio,
          onChanged: onChanged,
        ),
      ],
    );
  }
}