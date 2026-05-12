import 'package:flutter/material.dart';

class CheckboxApp extends StatelessWidget {
  final String texto;
  final bool valor;
  final ValueChanged<bool?> onChanged;

  const CheckboxApp({
    super.key,
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: valor,
      onChanged: onChanged,
      title: Text(texto),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}