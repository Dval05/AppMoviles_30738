import 'package:flutter/material.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String text;
  final ValueChanged<T?> onChanged;

  const CustomRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(text),
    );
  }
}