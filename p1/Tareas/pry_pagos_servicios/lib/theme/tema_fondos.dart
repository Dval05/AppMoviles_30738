import 'package:flutter/material.dart';
import 'esquema_color.dart';

class TemaFondos {
  static const BoxDecoration fondoPrincipal = BoxDecoration(
    color: ColoresApp.fondoPrincipal,
  );
  static const BoxDecoration degradadoPrincipal = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        ColoresApp.primario,
        ColoresApp.secundario,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );
  static const BoxDecoration fondoCardSuave = BoxDecoration(
    color: ColoresApp.fondoSuave,
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );
}