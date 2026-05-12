import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../atomos/custom_text_field.dart';

class DailyHoursInput extends StatelessWidget {
  final List<TextEditingController> controllers;

  const DailyHoursInput({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    List<String> days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Horas trabajadas por día:", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return CustomTextField(
              controller: controllers[index],
              label: days[index],
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Obligatorio';
                final hours = double.tryParse(value);
                if (hours == null) return 'Inválido';
                if (hours < 0 || hours > 24) return '0-24 h';
                return null;
              },
            );
          },
        ),
      ],
    );
  }
}
