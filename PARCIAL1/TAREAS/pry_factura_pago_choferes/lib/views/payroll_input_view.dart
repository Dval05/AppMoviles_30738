import 'package:flutter/material.dart';
import '../models/driver_model.dart';
import '../controllers/payroll_controller.dart';
import '../widgets/organismos/driver_form.dart';
import '../widgets/atomos/custom_button.dart';

class PayrollInputView extends StatefulWidget {
  final PayrollController controller;
  const PayrollInputView({super.key, required this.controller});

  @override
  State<PayrollInputView> createState() => _PayrollInputViewState();
}

class _PayrollInputViewState extends State<PayrollInputView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _wageController = TextEditingController();
  final List<TextEditingController> _hoursControllers = List.generate(6, (_) => TextEditingController());

  bool _isActive = true;
  bool _receivesBonus = false;
  String _driverType = 'Full-time';

  void _registerDriver() {
    if (_formKey.currentState!.validate()) {
      if (widget.controller.drivers.length >= 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ya se han registrado los 5 choferes máximo.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final driver = Driver(
        name: _nameController.text.trim(),
        dailyHours: _hoursControllers.map((c) => double.parse(c.text)).toList(),
        hourlyWage: double.parse(_wageController.text),
        isActive: _isActive,
        receivesBonus: _receivesBonus,
        driverType: _driverType,
      );

      setState(() {
        widget.controller.addDriver(driver);
      });

      _clearFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chofer ${driver.name} registrado con éxito (${widget.controller.drivers.length}/5)'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _wageController.clear();
    for (var c in _hoursControllers) {
      c.clear();
    }
    setState(() {
      _isActive = true;
      _receivesBonus = false;
      _driverType = 'Full-time';
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Nómina - Choferes'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: DriverForm(
                formKey: _formKey,
                nameController: _nameController,
                hoursControllers: _hoursControllers,
                wageController: _wageController,
                isActive: _isActive,
                receivesBonus: _receivesBonus,
                driverType: _driverType,
                onActiveChanged: (v) => setState(() => _isActive = v ?? true),
                onBonusChanged: (v) => setState(() => _receivesBonus = v ?? false),
                onTypeChanged: (v) => setState(() => _driverType = v ?? 'Full-time'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: 'Registrar',
                  onPressed: _registerDriver,
                  color: Colors.blue,
                ),
                CustomButton(
                  label: 'Limpiar',
                  onPressed: _clearFields,
                  color: Colors.orange,
                ),
                CustomButton(
                  label: 'Reporte',
                  onPressed: () {
                    if (widget.controller.drivers.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Debe registrar al menos un chofer para ver el reporte.')),
                      );
                    } else {
                      Navigator.pushNamed(context, '/report');
                    }
                  },
                  color: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Choferes registrados: ${widget.controller.drivers.length} / 5',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
