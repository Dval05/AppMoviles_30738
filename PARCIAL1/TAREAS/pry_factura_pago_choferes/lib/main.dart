import 'package:flutter/material.dart';
import 'controllers/payroll_controller.dart';
import 'views/payroll_input_view.dart';
import 'views/payroll_report_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Inicializamos el controlador aquí para compartirlo entre rutas
  final PayrollController _payrollController = PayrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nómina de Choferes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Definición de Rutas
      initialRoute: '/',
      routes: {
        '/': (context) => PayrollInputView(controller: _payrollController),
        '/report': (context) => PayrollReportView(controller: _payrollController),
      },
    );
  }
}
