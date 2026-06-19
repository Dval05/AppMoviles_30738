// ============================================================
// VIEW - Capa de presentación con Atomic Design
// Ejercicios 5, 6, 8, 9 y 10
// Estilo básico y sencillo
// ============================================================

import 'package:flutter/material.dart';
import '../controller/controller_tarea.dart';
import '../model/model_tarea.dart';

// ==================== ÁTOMOS ====================

/// Átomo: Etiqueta de texto
class LabelText extends StatelessWidget {
  final String texto;
  final double fontSize;

  const LabelText(this.texto, {super.key, this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
    );
  }
}

/// Átomo: Campo de texto numérico
class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const NumberField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}

/// Átomo: Botón básico
class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData? icon;
  final Color? color;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}

/// Átomo: Texto de resultado
class ResultadoTexto extends StatelessWidget {
  final String texto;

  const ResultadoTexto({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        texto,
        style: const TextStyle(fontSize: 15, height: 1.5),
      ),
    );
  }
}

// ==================== MOLÉCULAS ====================

/// Molécula: Input con etiqueta
class InputConEtiqueta extends StatelessWidget {
  final String etiqueta;
  final TextEditingController controller;
  final String hint;

  const InputConEtiqueta({
    super.key,
    required this.etiqueta,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(etiqueta, fontSize: 15),
        const SizedBox(height: 6),
        NumberField(controller: controller, hintText: hint),
      ],
    );
  }
}

// ==================== ORGANISMOS ====================

/// Organismo: Card del Ejercicio 5 - Conversor de Longitud
class Ejercicio5Card extends StatefulWidget {
  const Ejercicio5Card({super.key});

  @override
  State<Ejercicio5Card> createState() => _Ejercicio5CardState();
}

class _Ejercicio5CardState extends State<Ejercicio5Card> {
  final TextEditingController controllerMetros = TextEditingController();
  final ConversionLongitudController controller =
      ConversionLongitudController();
  String resultado = '';

  void calcular() {
    setState(() {
      resultado = controller.convertir(controllerMetros.text);
    });
  }

  void limpiar() {
    setState(() {
      controllerMetros.clear();
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LabelText('Conversor de Unidades de Longitud', fontSize: 20),
            const SizedBox(height: 6),
            const Text(
              'Convierte metros a yardas, pies, centímetros y pulgadas',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            InputConEtiqueta(
              etiqueta: 'Medida en metros:',
              controller: controllerMetros,
              hint: 'Ej: 5.5',
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: calcular,
                  text: 'Convertir',
                  icon: Icons.swap_horiz,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: limpiar,
                  text: 'Limpiar',
                  icon: Icons.refresh,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (resultado.isNotEmpty) ResultadoTexto(texto: resultado),
          ],
        ),
      ),
    );
  }
}

/// Organismo: Card del Ejercicio 6 - Capacidad de Disco
class Ejercicio6Card extends StatefulWidget {
  const Ejercicio6Card({super.key});

  @override
  State<Ejercicio6Card> createState() => _Ejercicio6CardState();
}

class _Ejercicio6CardState extends State<Ejercicio6Card> {
  final TextEditingController controllerGB = TextEditingController();
  final CapacidadDiscoController controller = CapacidadDiscoController();
  String resultado = '';

  void calcular() {
    setState(() {
      resultado = controller.convertir(controllerGB.text);
    });
  }

  void limpiar() {
    setState(() {
      controllerGB.clear();
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LabelText('Capacidad de Disco Duro', fontSize: 20),
            const SizedBox(height: 6),
            const Text(
              'Convierte Gigabytes a Megabytes, Kilobytes y Bytes',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            InputConEtiqueta(
              etiqueta: 'Capacidad en Gigabytes (GB):',
              controller: controllerGB,
              hint: 'Ej: 500',
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: calcular,
                  text: 'Convertir',
                  icon: Icons.storage,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: limpiar,
                  text: 'Limpiar',
                  icon: Icons.refresh,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (resultado.isNotEmpty) ResultadoTexto(texto: resultado),
          ],
        ),
      ),
    );
  }
}

/// Organismo: Card del Ejercicio 8 - Cuota de Finanza
class Ejercicio8Card extends StatefulWidget {
  const Ejercicio8Card({super.key});

  @override
  State<Ejercicio8Card> createState() => _Ejercicio8CardState();
}

class _Ejercicio8CardState extends State<Ejercicio8Card> {
  final TextEditingController controllerMonto = TextEditingController();
  final CuotaFinanzaController controller = CuotaFinanzaController();
  String resultado = '';

  void calcular() {
    setState(() {
      resultado = controller.calcular(controllerMonto.text);
    });
  }

  void limpiar() {
    setState(() {
      controllerMonto.clear();
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LabelText('Compañía de Seguros', fontSize: 20),
            const SizedBox(height: 6),
            const Text(
              'Calcula la cuota según el monto de la finanza\n'
              '< \$50,000 → 3%  |  ≥ \$50,000 → 2%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            InputConEtiqueta(
              etiqueta: 'Monto de la finanza (\$):',
              controller: controllerMonto,
              hint: 'Ej: 75000',
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: calcular,
                  text: 'Calcular',
                  icon: Icons.calculate,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: limpiar,
                  text: 'Limpiar',
                  icon: Icons.refresh,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (resultado.isNotEmpty) ResultadoTexto(texto: resultado),
          ],
        ),
      ),
    );
  }
}

/// Organismo: Card del Ejercicio 9 - Producción Semanal
class Ejercicio9Card extends StatefulWidget {
  const Ejercicio9Card({super.key});

  @override
  State<Ejercicio9Card> createState() => _Ejercicio9CardState();
}

class _Ejercicio9CardState extends State<Ejercicio9Card> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final ProduccionSemanalController controller =
      ProduccionSemanalController();
  String resultado = '';

  void calcular() {
    setState(() {
      List<String> textos = controllers.map((c) => c.text).toList();
      resultado = controller.calcular(textos);
    });
  }

  void limpiar() {
    setState(() {
      for (var c in controllers) {
        c.clear();
      }
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LabelText('Producción Semanal', fontSize: 20),
            const SizedBox(height: 6),
            const Text(
              'Registra la producción diaria (Lun-Sáb)\n'
              'Promedio mínimo para incentivo: 100 unidades',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < 6; i++) ...[
              InputConEtiqueta(
                etiqueta: '${ProduccionSemanalModel.diasSemana[i]}:',
                controller: controllers[i],
                hint: 'Unidades producidas',
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: calcular,
                  text: 'Calcular',
                  icon: Icons.analytics,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: limpiar,
                  text: 'Limpiar',
                  icon: Icons.refresh,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (resultado.isNotEmpty) ResultadoTexto(texto: resultado),
          ],
        ),
      ),
    );
  }
}

/// Organismo: Card del Ejercicio 10 - Promoción Supermercado
class Ejercicio10Card extends StatefulWidget {
  const Ejercicio10Card({super.key});

  @override
  State<Ejercicio10Card> createState() => _Ejercicio10CardState();
}

class _Ejercicio10CardState extends State<Ejercicio10Card> {
  final TextEditingController controllerCompra = TextEditingController();
  final PromocionSupermercadoController controller =
      PromocionSupermercadoController();
  String resultado = '';

  void calcular() {
    setState(() {
      resultado = controller.calcular(controllerCompra.text);
    });
  }

  void limpiar() {
    setState(() {
      controllerCompra.clear();
      resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const LabelText('Promoción Supermercado', fontSize: 20),
            const SizedBox(height: 6),
            const Text(
              'Se genera un número al azar para el descuento\n'
              '< 74 → 15%  |  ≥ 74 → 20%',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            InputConEtiqueta(
              etiqueta: 'Total de la compra (\$):',
              controller: controllerCompra,
              hint: 'Ej: 250.50',
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: calcular,
                  text: 'Calcule Descuento',
                  icon: Icons.local_offer,
                ),
                const SizedBox(width: 10),
                StyledButton(
                  onPressed: limpiar,
                  text: 'Limpiar',
                  icon: Icons.refresh,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (resultado.isNotEmpty) ResultadoTexto(texto: resultado),
          ],
        ),
      ),
    );
  }
}

// ==================== PÁGINAS ====================

/// Página del Ejercicio 5
class Ejercicio5Page extends StatelessWidget {
  const Ejercicio5Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 5 - Conversor'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Ejercicio5Card(),
      ),
    );
  }
}

/// Página del Ejercicio 6
class Ejercicio6Page extends StatelessWidget {
  const Ejercicio6Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 6 - Disco Duro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Ejercicio6Card(),
      ),
    );
  }
}

/// Página del Ejercicio 8
class Ejercicio8Page extends StatelessWidget {
  const Ejercicio8Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 8 - Seguros'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Ejercicio8Card(),
      ),
    );
  }
}

/// Página del Ejercicio 9
class Ejercicio9Page extends StatelessWidget {
  const Ejercicio9Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 9 - Producción'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Ejercicio9Card(),
      ),
    );
  }
}

/// Página del Ejercicio 10
class Ejercicio10Page extends StatelessWidget {
  const Ejercicio10Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicio 10 - Promoción'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Ejercicio10Card(),
      ),
    );
  }
}
