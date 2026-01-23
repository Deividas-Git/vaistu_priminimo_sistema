import 'package:flutter/material.dart';

class ThemedTextWidget extends StatelessWidget {
  const ThemedTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
  });
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: ColorScheme.of(context).primary,
        fontSize: fontSize,
      ),
    );
  }
}
