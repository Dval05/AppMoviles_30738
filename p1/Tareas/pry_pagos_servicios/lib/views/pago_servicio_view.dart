import 'package:flutter/material.dart';
import '../controllers/pago_servicio_controller.dart';
import '../widgets/atomos/boton_principal.dart';
import '../widgets/atomos/boton_secundario.dart';
import '../widgets/atomos/label_app.dart';
import '../widgets/moleculas/datos_cliente_form.dart';
import '../widgets/moleculas/opciones_adicionales.dart';
import '../widgets/moleculas/selector_forma_pago.dart';
import '../widgets/moleculas/selector_servicio.dart';
import 'resumen_pago_view.dart';

class PagoServicioView extends StatefulWidget {
  const PagoServicioView({super.key});

  @override
  State<PagoServicioView> createState() => _PagoServicioViewState();
}

class _PagoServicioViewState extends State<PagoServicioView> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController valorBaseController = TextEditingController();

  final PagoServicioController controller = PagoServicioController();

  String tipoServicio = '';
  String formaPago = '';
  bool aplicaRecargo = false;
  bool aplicaServicioAdicional = false;
  String resultado = '';

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
      resultado = '';
    });
  }

  void irResumenConPush() {
    calcularPago();

    if (resultado == 'Todos los campos son obligatorios' ||
        resultado == 'Ingrese un valor base válido' ||
        resultado == 'El valor base debe ser mayor que 0') {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResumenPagoView(resumen: resultado),
      ),
    );
  }

  void irResumenConPushNamed() {
    calcularPago();

    if (resultado == 'Todos los campos son obligatorios' ||
        resultado == 'Ingrese un valor base válido' ||
        resultado == 'El valor base debe ser mayor que 0') {
      return;
    }

    Navigator.pushNamed(context, '/resumen', arguments: resultado);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Pago de Servicios')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelApp(
                    'Registro de pago',
                    fontSize: 24,
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
                        BotonPrincipal(
                          texto: 'Calcular',
                          onPressed: calcularPago,
                        ),
                        BotonSecundario(
                          texto: 'Limpiar',
                          onPressed: limpiarCampos,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        BotonPrincipal(
                          texto: 'Resumen push',
                          onPressed: irResumenConPush,
                        ),
                        BotonSecundario(
                          texto: 'Resumen pushNamed',
                          onPressed: irResumenConPushNamed,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const LabelApp(
                    'Resultado actual',
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
                    child: Text(
                      resultado.isEmpty
                          ? 'Aquí se mostrará el resumen del pago'
                          : resultado,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Regresar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
