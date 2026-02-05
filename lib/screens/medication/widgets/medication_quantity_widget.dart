import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class MedicationQuantityWidget extends StatelessWidget {
  const MedicationQuantityWidget({
    super.key,
    required this.medicationType,
    required this.controller,
  });

  final MedicationType medicationType;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ThemedContainerWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.medication_outlined),
                const SizedBox(width: 10),
                Text(
                  "Vaisto likutis:",
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorScheme.of(context).scrim,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 36,
            width: 90,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              inputFormatters: [
                QuantityInputFormatter(medicationType: medicationType),
              ],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              cursorColor: ColorScheme.of(context).inversePrimary,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                filled: true,
                fillColor: Theme.of(context).colorScheme.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            medicationType.getUnit,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class QuantityInputFormatter extends TextInputFormatter {
  QuantityInputFormatter({required this.medicationType});

  final MedicationType medicationType;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '.');

    // Allow empty input
    if (text.isEmpty) {
      return newValue;
    }

    // Allow only numbers and decimal separator
    if (!RegExp(r'^(0|[1-9]\d*)(\.\d*)?$').hasMatch(text)) {
      return oldValue;
    }

    // Enforce max 2 decimal places
    if (text.contains('.')) {
      if (medicationType.consumedAmoutIsInteger) return oldValue;
      final parts = text.split('.');
      if (parts.length > 2 || parts[1].length > 2 || parts[0].length > 5) {
        return oldValue;
      }
    } else if (text.length > 5) {
      return oldValue;
    }

    return newValue;
  }
}
