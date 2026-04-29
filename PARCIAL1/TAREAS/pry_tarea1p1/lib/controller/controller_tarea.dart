// ============================================================
// CONTROLLER - Capa de validación y coordinación
// Ejercicios 5, 6, 8, 9 y 10
// ============================================================

import '../model/model_tarea.dart';

// ----- Ejercicio 5: Controller Conversor de Longitud -----
class ConversionLongitudController {
  final ConversionLongitudModel model = ConversionLongitudModel();

  /// Valida que el texto sea un número positivo
  String validarMetros(String texto) {
    if (texto.isEmpty) {
      return 'Error: Ingrese un valor en metros.';
    }
    double? valor = double.tryParse(texto);
    if (valor == null) {
      return 'Error: Ingrese un número válido.';
    }
    if (valor < 0) {
      return 'Error: El valor debe ser mayor o igual a 0.';
    }
    return '';
  }

  /// Realiza la conversión y devuelve el resultado formateado
  String convertir(String texto) {
    String error = validarMetros(texto);
    if (error.isNotEmpty) return error;

    double valor = double.parse(texto);
    model.convertir(valor);

    return 'Resultado de la conversión:\n\n'
        '${model.metros.toStringAsFixed(4)} metros\n'
        '${model.yardas.toStringAsFixed(4)} yardas\n'
        '${model.pies.toStringAsFixed(4)} pies\n'
        '${model.centimetros.toStringAsFixed(4)} centímetros\n'
        '${model.pulgadas.toStringAsFixed(4)} pulgadas';
  }
}

// ----- Ejercicio 6: Controller Capacidad de Disco -----
class CapacidadDiscoController {
  final CapacidadDiscoModel model = CapacidadDiscoModel();

  /// Valida que el texto sea un número positivo
  String validarGB(String texto) {
    if (texto.isEmpty) {
      return 'Error: Ingrese la capacidad en Gigabytes.';
    }
    double? valor = double.tryParse(texto);
    if (valor == null) {
      return 'Error: Ingrese un número válido.';
    }
    if (valor <= 0) {
      return 'Error: La capacidad debe ser mayor a 0.';
    }
    return '';
  }

  /// Realiza la conversión y devuelve resultado formateado
  String convertir(String texto) {
    String error = validarGB(texto);
    if (error.isNotEmpty) return error;

    double valor = double.parse(texto);
    model.convertir(valor);

    return 'Capacidad del disco:\n\n'
        '${model.gigabytes.toStringAsFixed(2)} GB\n'
        '${model.megabytes.toStringAsFixed(2)} MB\n'
        '${model.kilobytes.toStringAsFixed(2)} KB\n'
        '${model.bytes.toStringAsFixed(0)} Bytes';
  }
}

// ----- Ejercicio 8: Controller Cuota de Finanza -----
class CuotaFinanzaController {
  final CuotaFinanzaModel model = CuotaFinanzaModel();

  /// Valida que el monto sea un número positivo
  String validarMonto(String texto) {
    if (texto.isEmpty) {
      return 'Error: Ingrese el monto de la finanza.';
    }
    double? valor = double.tryParse(texto);
    if (valor == null) {
      return 'Error: Ingrese un número válido.';
    }
    if (valor <= 0) {
      return 'Error: El monto debe ser mayor a 0.';
    }
    return '';
  }

  /// Calcula la cuota y devuelve resultado formateado
  String calcular(String texto) {
    String error = validarMonto(texto);
    if (error.isNotEmpty) return error;

    double valor = double.parse(texto);
    model.calcularCuota(valor);

    return 'Resultado del cálculo:\n\n'
        'Monto: \$${model.monto.toStringAsFixed(2)}\n'
        'Porcentaje aplicado: ${model.porcentaje.toStringAsFixed(0)}%\n'
        'Cuota a pagar: \$${model.cuota.toStringAsFixed(2)}\n\n'
        '${model.monto < 50000 ? "Monto menor a \$50,000 -> se aplica 3%" : "Monto mayor o igual a \$50,000 -> se aplica 2%"}';
  }
}

// ----- Ejercicio 9: Controller Producción Semanal -----
class ProduccionSemanalController {
  final ProduccionSemanalModel model = ProduccionSemanalModel();

  /// Valida un valor de producción diaria
  String validarProduccion(String texto, String dia) {
    if (texto.isEmpty) {
      return 'Error: Ingrese la producción del $dia.';
    }
    int? valor = int.tryParse(texto);
    if (valor == null) {
      return 'Error: Ingrese un número entero válido para $dia.';
    }
    if (valor < 0) {
      return 'Error: La producción de $dia no puede ser negativa.';
    }
    return '';
  }

  /// Valida todos los días y calcula
  String calcular(List<String> textos) {
    List<int> valores = [];

    for (int i = 0; i < 6; i++) {
      String dia = ProduccionSemanalModel.diasSemana[i];
      String error = validarProduccion(textos[i], dia);
      if (error.isNotEmpty) return error;
      valores.add(int.parse(textos[i]));
    }

    model.calcular(valores);

    String detalle = '';
    for (int i = 0; i < 6; i++) {
      detalle +=
          '  ${ProduccionSemanalModel.diasSemana[i]}: ${model.produccionDiaria[i]} unidades\n';
    }

    return 'Producción semanal:\n\n'
        '$detalle\n'
        'Total: ${model.totalUnidades} unidades\n'
        'Promedio: ${model.promedio.toStringAsFixed(2)} unidades/día\n\n'
        '${model.recibeIncentivo ? "El operario SI recibe incentivos (promedio >= 100)" : "El operario NO recibe incentivos (promedio < 100)"}';
  }
}

// ----- Ejercicio 10: Controller Promoción Supermercado -----
class PromocionSupermercadoController {
  final PromocionSupermercadoModel model = PromocionSupermercadoModel();

  /// Valida el total de compra
  String validarCompra(String texto) {
    if (texto.isEmpty) {
      return 'Error: Ingrese el total de la compra.';
    }
    double? valor = double.tryParse(texto);
    if (valor == null) {
      return 'Error: Ingrese un número válido.';
    }
    if (valor <= 0) {
      return 'Error: El total de la compra debe ser mayor a 0.';
    }
    return '';
  }

  /// Calcula el descuento y devuelve resultado
  String calcular(String texto) {
    String error = validarCompra(texto);
    if (error.isNotEmpty) return error;

    double valor = double.parse(texto);
    model.calcularDescuento(valor);

    return 'Resultado de la promoción:\n\n'
        'Número aleatorio: ${model.numeroAleatorio}\n'
        'Total compra: \$${model.totalCompra.toStringAsFixed(2)}\n'
        'Descuento: ${model.porcentajeDescuento.toStringAsFixed(0)}%\n'
        'Monto descontado: \$${model.montoDescuento.toStringAsFixed(2)}\n'
        'Total a pagar: \$${model.totalFinal.toStringAsFixed(2)}\n\n'
        '${model.numeroAleatorio < 74 ? "Número < 74 -> descuento del 15%" : "Número >= 74 -> descuento del 20%"}';
  }
}
