import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomLabel({super.key, required this.text, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
