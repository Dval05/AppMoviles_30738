import 'package:flutter/material.dart';

class RadioOpcionApp extends StatelessWidget {
  final String titulo;
  final String valor;
  final String grupoValor;
  final ValueChanged<String?> onChanged;

  const RadioOpcionApp({
    super.key,
    required this.titulo,
    required this.valor,
    required this.grupoValor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      title: Text(titulo),
      value: valor,
      groupValue: grupoValor,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}