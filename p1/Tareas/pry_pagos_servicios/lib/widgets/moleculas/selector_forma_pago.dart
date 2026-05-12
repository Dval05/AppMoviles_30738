import 'package:flutter/material.dart';
import '../atomos/label_app.dart';
import '../atomos/radio_opcion_app.dart';

class SelectorFormaPago extends StatelessWidget {
  final String formaPago;
  final ValueChanged<String?> onChanged;

  const SelectorFormaPago({
    super.key,
    required this.formaPago,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LabelApp(
          'Forma de pago',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 8),
        RadioOpcionApp(
          titulo: 'Efectivo',
          valor: 'Efectivo',
          grupoValor: formaPago,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'Transferencia',
          valor: 'Transferencia',
          grupoValor: formaPago,
          onChanged: onChanged,
        ),
        RadioOpcionApp(
          titulo: 'Tarjeta',
          valor: 'Tarjeta',
          grupoValor: formaPago,
          onChanged: onChanged,
        ),
      ],
    );
  }
}