import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoTextoApp extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;

  const CampoTextoApp({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(labelText: label),
    );
  }
}
