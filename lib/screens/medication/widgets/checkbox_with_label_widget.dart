import 'package:flutter/material.dart';

class CheckboxWithLabelWidget extends StatelessWidget {
  const CheckboxWithLabelWidget({
    super.key,
    required this.label,
    required this.isChecked,
    required this.onChanged,
  });

  final String label;
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Checkbox(value: isChecked, onChanged: onChanged),
            Text(label, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
