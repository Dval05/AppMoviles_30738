class PagoServicioModel {
  String nombreCliente;
  String cedulaCliente;
  String tipoServicio;
  String formaPago;
  double valorBase;
  bool aplicaRecargo;
  bool aplicaServicioAdicional;

  double tarifa;
  double subtotal;
  double descuento;
  double recargo;
  double total;

  PagoServicioModel({
    required this.nombreCliente,
    required this.cedulaCliente,
    required this.tipoServicio,
    required this.formaPago,
    required this.valorBase,
    required this.aplicaRecargo,
    required this.aplicaServicioAdicional,
    this.tarifa = 0,
    this.subtotal = 0,
    this.descuento = 0,
    this.recargo = 0,
    this.total = 0,
  });

  double obtenerTarifa() {
    switch (tipoServicio) {
      case 'Agua potable':
        return 0.10;
      case 'Energía eléctrica':
        return 0.15;
      case 'Internet y telefonía':
        return 0.20;
      case 'TV por cable y streaming':
        return 0.18;
      case 'Otros pagos frecuentes':
        return 0.12;
      default:
        return 0;
    }
  }

  void calcularPago() {
    tarifa = obtenerTarifa();
    subtotal = valorBase * tarifa;
    descuento = 0;
    recargo = 0;

    if (formaPago == 'Efectivo') {
      descuento = subtotal * 0.10;
    }

    if (aplicaRecargo) {
      recargo += subtotal * 0.05;
    }

    if (aplicaServicioAdicional) {
      recargo += subtotal * 0.03;
    }

    total = subtotal - descuento + recargo;
  }

  String generarResumen() {
    final porcentajeTarifa = tarifa * 100;

    return '''
Cliente: $nombreCliente
Cédula: $cedulaCliente
Servicio: $tipoServicio
Forma de pago: $formaPago
Valor Base: \$${valorBase.toStringAsFixed(2)}
Tarifa aplicada: ${porcentajeTarifa.toStringAsFixed(0)}%
Subtotal: \$${subtotal.toStringAsFixed(2)}
Descuento: \$${descuento.toStringAsFixed(2)}
Recargo: \$${recargo.toStringAsFixed(2)}
Total a pagar: \$${total.toStringAsFixed(2)}
''';
  }
}
