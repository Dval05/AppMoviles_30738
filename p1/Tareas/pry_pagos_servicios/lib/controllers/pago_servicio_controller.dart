import '../models/pago_servicio_model.dart';
class PagoServicioController {
  String procesarPago({
    required String nombreCliente,
    required String cedulaCliente,
    required String tipoServicio,
    required String formaPago,
    required String valorBaseTexto,
    required bool aplicaRecargo,
    required bool aplicaServicioAdicional,
  }) {
    if (nombreCliente.isEmpty || cedulaCliente.isEmpty || tipoServicio.isEmpty||
        formaPago.isEmpty || valorBaseTexto.isEmpty) {
      return 'Todos los campos son obligatorios';
    }

    final valorBase = double.tryParse(valorBaseTexto);

    if (valorBase == null) {
      return 'Ingrese un valor base válido';
    }

    if (valorBase <= 0) {
      return 'El valor base debe ser mayor que 0';
    }

    final pago = PagoServicioModel(
      nombreCliente: nombreCliente, 
      cedulaCliente: cedulaCliente, 
      tipoServicio: tipoServicio,
      formaPago: formaPago,
      valorBase: valorBase, 
      aplicaRecargo: aplicaRecargo, 
      aplicaServicioAdicional: aplicaServicioAdicional
    );

    pago.calcularPago();
    return pago.generarResumen();
  }
}
