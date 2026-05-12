import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../atomos/custom_text_field.dart';
import '../atomos/custom_checkbox.dart';
import '../atomos/custom_radio_button.dart';
import '../moleculas/daily_hours_input.dart';

class DriverForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final List<TextEditingController> hoursControllers;
  final TextEditingController wageController;
  final bool isActive;
  final bool receivesBonus;
  final String driverType;
  final ValueChanged<bool?> onActiveChanged;
  final ValueChanged<bool?> onBonusChanged;
  final ValueChanged<String?> onTypeChanged;

  const DriverForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.hoursControllers,
    required this.wageController,
    required this.isActive,
    required this.receivesBonus,
    required this.driverType,
    required this.onActiveChanged,
    required this.onBonusChanged,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              label: 'Nombre del Chofer',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]')),
              ],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingrese un nombre';
                if (v.trim().length < 3) return 'Nombre demasiado corto';
                // Adicional: verificar que no contenga números (aunque el formatter ya lo previene)
                if (RegExp(r'[0-9]').hasMatch(v)) return 'No se permiten números';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DailyHoursInput(controllers: hoursControllers),
            const SizedBox(height: 16),
            CustomTextField(
              controller: wageController,
              label: 'Sueldo por hora',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingrese sueldo';
                final val = double.tryParse(v);
                if (val == null) return 'Número inválido';
                if (val <= 0) return 'Debe ser un valor positivo';
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomCheckbox(
                    label: 'Activo',
                    value: isActive,
                    onChanged: onActiveChanged,
                  ),
                ),
                Expanded(
                  child: CustomCheckbox(
                    label: 'Bono',
                    value: receivesBonus,
                    onChanged: onBonusChanged,
                  ),
                ),
              ],
            ),
            const Divider(),
            const Text("Tipo de Jornada:", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: CustomRadioButton<String>(
                    label: 'Tiempo Completo',
                    value: 'Full-time',
                    groupValue: driverType,
                    onChanged: onTypeChanged,
                  ),
                ),
                Expanded(
                  child: CustomRadioButton<String>(
                    label: 'Medio Tiempo',
                    value: 'Part-time',
                    groupValue: driverType,
                    onChanged: onTypeChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
