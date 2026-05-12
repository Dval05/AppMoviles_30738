import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaTextos {
  static const TextStyle tituloPrincipal = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ColoresApp.textoOscuro,
  );

  static const TextStyle tituloSeccion = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: ColoresApp.textoOscuro,
  );

  static const TextStyle subtitulo = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: ColoresApp.textoSecundario,
  );

  static const TextStyle textoNormal = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: ColoresApp.textoOscuro,
  );

  static const TextStyle textoResultado = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: ColoresApp.exito,
  );

  static const TextStyle textoError = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ColoresApp.error,
  );

  static const TextStyle textoBotonClaro = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ColoresApp.textoClaro,
  );

  static const TextStyle textoDestacado = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: ColoresApp.acento,
  );
}