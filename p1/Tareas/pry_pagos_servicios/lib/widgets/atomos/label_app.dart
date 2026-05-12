import 'package:flutter/material.dart';

class LabelApp extends StatelessWidget {
  final String texto;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final Color? color;

  const LabelApp(
    this.texto, {
    super.key,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.textAlign = TextAlign.left,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}