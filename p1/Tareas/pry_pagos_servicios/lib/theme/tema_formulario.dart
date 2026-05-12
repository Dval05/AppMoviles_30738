import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaFormulario {
  static final InputDecorationTheme campoTexto = InputDecorationTheme(
    filled: true,
    fillColor: ColoresApp.fondoCard,
    labelStyle: const TextStyle(
      color: ColoresApp.textoSecundario,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    hintStyle: const TextStyle(
      color: ColoresApp.textoSecundario,
      fontSize: 14,
    ),
    prefixIconColor: ColoresApp.primario,
    suffixIconColor: ColoresApp.secundario,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ColoresApp.borde,
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ColoresApp.acento,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ColoresApp.error,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder( 
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ColoresApp.error,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
  );
  
}