import 'package:flutter/material.dart';
import '../../controllers/pago_servicio_controller.dart';
import '../atomos/boton_principal.dart';
import '../atomos/boton_secundario.dart';
import '../atomos/label_app.dart';
import '../moleculas/datos_cliente_form.dart';
import '../moleculas/selector_servicio.dart';
import '../moleculas/selector_forma_pago.dart';
import '../moleculas/opciones_adicionales.dart';

class FormularioPagoServicio extends StatefulWidget {
  const FormularioPagoServicio({super.key});

  @override
  State<FormularioPagoServicio> createState() => _FormularioPagoServicioState();
}

class _FormularioPagoServicioState extends State<FormularioPagoServicio> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController valorBaseController = TextEditingController();

  final PagoServicioController controller = PagoServicioController();

  String tipoServicio = '';
  String formaPago = '';
  bool aplicaRecargo = false;
  bool aplicaServicioAdicional = false;
  String resultado = 'Aquí se mostrará el resumen del pago';

  void calcularPago() {
    setState(() {
      resultado = controller.procesarPago(
        nombreCliente: nombreController.text,
        cedulaCliente: cedulaController.text,
        tipoServicio: tipoServicio,
        formaPago: formaPago,
        valorBaseTexto: valorBaseController.text,
        aplicaRecargo: aplicaRecargo,
        aplicaServicioAdicional: aplicaServicioAdicional,
      );
    });
  }

  void limpiarCampos() {
    setState(() {
      nombreController.clear();
      cedulaController.clear();
      valorBaseController.clear();
      tipoServicio = '';
      formaPago = '';
      aplicaRecargo = false;
      aplicaServicioAdicional = false;
      resultado = 'Aquí se mostrará el resumen del pago';
    });
  }

  @override
  void dispose() {
    nombreController.dispose();
    cedulaController.dispose();
    valorBaseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LabelApp(
                'Registro de pago de servicios',
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              DatosClienteForm(
                nombreController: nombreController,
                cedulaController: cedulaController,
                valorBaseController: valorBaseController,
              ),
              const SizedBox(height: 20),

              SelectorServicio(
                tipoServicio: tipoServicio,
                onChanged: (value) {
                  setState(() {
                    tipoServicio = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              SelectorFormaPago(
                formaPago: formaPago,
                onChanged: (value) {
                  setState(() {
                    formaPago = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 20),

              OpcionesAdicionales(
                aplicaRecargo: aplicaRecargo,
                aplicaServicioAdicional: aplicaServicioAdicional,
                onRecargoChanged: (value) {
                  setState(() {
                    aplicaRecargo = value ?? false;
                  });
                },
                onServicioAdicionalChanged: (value) {
                  setState(() {
                    aplicaServicioAdicional = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    BotonPrincipal(texto: 'Calcular', onPressed: calcularPago),
                    BotonSecundario(texto: 'Limpiar', onPressed: limpiarCampos),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const LabelApp(
                'Resultado',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(resultado),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
