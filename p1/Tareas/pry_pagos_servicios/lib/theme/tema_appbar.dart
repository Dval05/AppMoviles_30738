import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaAppbar {
  static const AppBarTheme estilo = AppBarTheme(
    backgroundColor: ColoresApp.primario,
    foregroundColor: ColoresApp.textoClaro,
    centerTitle: true,
    elevation: 4,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ColoresApp.textoClaro,
    ),
    iconTheme: IconThemeData(
      color: ColoresApp.acento,
      size: 24,
    ),
  );
}