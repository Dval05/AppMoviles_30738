import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaBotones {
  static final ElevatedButtonThemeData botonPrincipal =
    ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColoresApp.primario,
        foregroundColor: ColoresApp.textoClaro,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

  static final OutlinedButtonThemeData botonSecundario =
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ColoresApp.primario,
        side: const BorderSide(
          color: ColoresApp.primario,
          width: 1.5,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    static final TextButtonThemeData botonTexto = 
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColoresApp.acento,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
  }