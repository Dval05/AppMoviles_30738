// ============================================================
// MODEL - Capa de datos y lógica de negocio
// Ejercicios 5, 6, 8, 9 y 10
// ============================================================

import 'dart:math';

// ----- Ejercicio 5: Conversor de Unidades de Longitud -----
class ConversionLongitudModel {
  double metros;
  double yardas;
  double pies;
  double centimetros;
  double pulgadas;

  ConversionLongitudModel({
    this.metros = 0,
    this.yardas = 0,
    this.pies = 0,
    this.centimetros = 0,
    this.pulgadas = 0,
  });

  /// Convierte metros a todas las unidades
  void convertir(double valorMetros) {
    metros = valorMetros;
    // 1 metro = 100 cm
    centimetros = metros * 100;
    // 1 pulgada = 2.54 cm  =>  cm / 2.54
    pulgadas = centimetros / 2.54;
    // 1 pie = 12 pulgadas  =>  pulgadas / 12
    pies = pulgadas / 12;
    // 1 yarda = 3 pies  =>  pies / 3
    yardas = pies / 3;
  }
}

// ----- Ejercicio 6: Capacidad de Disco Duro -----
class CapacidadDiscoModel {
  double gigabytes;
  double megabytes;
  double kilobytes;
  double bytes;

  CapacidadDiscoModel({
    this.gigabytes = 0,
    this.megabytes = 0,
    this.kilobytes = 0,
    this.bytes = 0,
  });

  /// Convierte GB a MB, KB y Bytes
  void convertir(double valorGB) {
    gigabytes = valorGB;
    // 1 GB = 1024 MB
    megabytes = gigabytes * 1024;
    // 1 MB = 1024 KB
    kilobytes = megabytes * 1024;
    // 1 KB = 1024 Bytes
    bytes = kilobytes * 1024;
  }
}

// ----- Ejercicio 8: Compañía de Seguros - Cuota de Finanza -----
class CuotaFinanzaModel {
  double monto;
  double porcentaje;
  double cuota;

  CuotaFinanzaModel({
    this.monto = 0,
    this.porcentaje = 0,
    this.cuota = 0,
  });

  /// Calcula la cuota según el monto:
  /// monto < 50000 => 3%
  /// monto >= 50000 => 2%
  void calcularCuota(double valorMonto) {
    monto = valorMonto;
    if (monto < 50000) {
      porcentaje = 3;
      cuota = monto * 0.03;
    } else {
      porcentaje = 2;
      cuota = monto * 0.02;
    }
  }
}

// ----- Ejercicio 9: Producción Semanal del Operario -----
class ProduccionSemanalModel {
  // Producción de lunes a sábado (6 días)
  List<int> produccionDiaria;
  double promedio;
  int totalUnidades;
  bool recibeIncentivo;

  static const List<String> diasSemana = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
  ];

  ProduccionSemanalModel({
    List<int>? produccionDiaria,
    this.promedio = 0,
    this.totalUnidades = 0,
    this.recibeIncentivo = false,
  }) : produccionDiaria = produccionDiaria ?? [];

  /// Calcula el promedio y determina si recibe incentivo
  /// Promedio mínimo para incentivo: 100 unidades semanales
  void calcular(List<int> valores) {
    produccionDiaria = List.from(valores);
    totalUnidades = produccionDiaria.fold(0, (sum, val) => sum + val);
    promedio = totalUnidades / produccionDiaria.length;
    recibeIncentivo = promedio >= 100;
  }
}

// ----- Ejercicio 10: Promoción de Supermercado -----
class PromocionSupermercadoModel {
  double totalCompra;
  int numeroAleatorio;
  double porcentajeDescuento;
  double montoDescuento;
  double totalFinal;

  PromocionSupermercadoModel({
    this.totalCompra = 0,
    this.numeroAleatorio = 0,
    this.porcentajeDescuento = 0,
    this.montoDescuento = 0,
    this.totalFinal = 0,
  });

  /// Calcula el descuento según número aleatorio:
  /// número < 74 => 15% de descuento
  /// número >= 74 => 20% de descuento
  void calcularDescuento(double compra) {
    totalCompra = compra;
    // Genera número aleatorio entre 1 y 100
    numeroAleatorio = Random().nextInt(100) + 1;

    if (numeroAleatorio < 74) {
      porcentajeDescuento = 15;
      montoDescuento = totalCompra * 0.15;
    } else {
      porcentajeDescuento = 20;
      montoDescuento = totalCompra * 0.20;
    }
    totalFinal = totalCompra - montoDescuento;
  }
}
