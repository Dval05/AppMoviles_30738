import 'package:flutter/material.dart';
import '../themes/app_styles.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: style ?? AppStyles.body,
    );
  }
}