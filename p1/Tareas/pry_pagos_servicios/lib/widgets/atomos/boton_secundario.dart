import 'package:flutter/material.dart';

class BotonSecundario extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonSecundario({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(texto),
    );
  }
}