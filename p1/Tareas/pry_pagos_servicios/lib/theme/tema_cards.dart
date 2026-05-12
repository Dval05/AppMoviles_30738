import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaCards {
  static final  CardThemeData estilo = CardThemeData(
    color: ColoresApp.fondoCard,
    elevation: 4,
    shadowColor: ColoresApp.sombra,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(
        color: ColoresApp.borde,
        width: 1,
      ),
    ),
  );
}