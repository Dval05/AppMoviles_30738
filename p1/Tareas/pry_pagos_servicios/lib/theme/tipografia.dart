import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TipografiaApp {
  static const TextTheme texto = TextTheme( 
    headlineLarge: TextStyle( 
      fontSize: 28, 
      fontWeight: FontWeight.bold, 
      color: ColoresApp.textoOscuro,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoOscuro,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: ColoresApp.textoOscuro,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: ColoresApp.textoOscuro,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: ColoresApp.textoOscuro,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: ColoresApp.textoSecundario,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: ColoresApp.textoClaro,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: ColoresApp.textoOscuro,
    ),
    
  );
}