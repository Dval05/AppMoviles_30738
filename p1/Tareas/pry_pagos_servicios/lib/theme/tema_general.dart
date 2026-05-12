import 'package:flutter/material.dart';
import 'esquema_color.dart';
import 'tipografia.dart';
import 'tema_appbar.dart';
import 'tema_botones.dart';
import 'tema_formulario.dart';
import 'tema_cards.dart';

class TemaGeneral {
  static final ThemeData claro = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: ColoresApp.fondoPrincipal,

    colorScheme: const ColorScheme.light(
      primary: ColoresApp.primario,
      secondary: ColoresApp.secundario,
      surface: ColoresApp.fondoCard,
      error: ColoresApp.error,
      onPrimary: ColoresApp.textoClaro,
      onSecondary: ColoresApp.textoClaro,
      onSurface: ColoresApp.textoOscuro,
      onError: ColoresApp.textoClaro,
    ),

    textTheme: TipografiaApp.texto,
    appBarTheme: TemaAppbar.estilo,
    elevatedButtonTheme: TemaBotones.botonPrincipal,
    outlinedButtonTheme: TemaBotones.botonSecundario,
    textButtonTheme: TemaBotones.botonTexto,
    inputDecorationTheme: TemaFormulario.campoTexto,
    cardTheme: TemaCards.estilo,

  );
}