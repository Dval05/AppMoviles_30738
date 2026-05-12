import 'package:flutter/material.dart';
import '../controllers/payroll_controller.dart';
import '../widgets/atomos/custom_label.dart';

class PayrollReportView extends StatelessWidget {
  final PayrollController controller;

  const PayrollReportView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Nómina'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomLabel(
              text: 'Resumen General', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total General a Pagar:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('\$${controller.calculateTotalGeneral().toStringAsFixed(2)}', 
                          style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Más horas el Lunes:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(controller.getDriverWithMostMondayHours(), 
                          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const CustomLabel(text: 'Detalle por Chofer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: controller.drivers.length,
                itemBuilder: (context, index) {
                  final driver = controller.drivers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(driver.name[0].toUpperCase()),
                      ),
                      title: Text(driver.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jornada: ${driver.driverType == "Full-time" ? "Tiempo Completo" : "Medio Tiempo"}'),
                          Text('Horas Semanales: ${driver.totalWeeklyHours.toStringAsFixed(1)} h'),
                          Text('Sueldo Semanal: \$${driver.weeklySalary.toStringAsFixed(2)}'),
                          Row(
                            children: [
                              Icon(Icons.circle, size: 12, color: driver.isActive ? Colors.green : Colors.red),
                              Text(driver.isActive ? " Activo" : " Inactivo"),
                              const SizedBox(width: 15),
                              Icon(Icons.star, size: 12, color: driver.receivesBonus ? Colors.amber : Colors.grey),
                              Text(driver.receivesBonus ? " Con Bono" : " Sin Bono"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver al Registro'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
