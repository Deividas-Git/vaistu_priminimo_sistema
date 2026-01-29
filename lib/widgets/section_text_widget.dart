import 'package:flutter/material.dart';

class SectionTextWidget extends StatelessWidget {
  const SectionTextWidget({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            label,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
