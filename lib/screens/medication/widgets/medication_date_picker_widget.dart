import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class MedicationDatePickerWidget extends StatefulWidget {
  const MedicationDatePickerWidget({
    super.key,
    required this.label,
    required this.onDatePicked,
  });

  final String label;
  final ValueChanged<DateTime?> onDatePicked;

  @override
  State<MedicationDatePickerWidget> createState() =>
      _MedicationDatePickerWidgetState();
}

class _MedicationDatePickerWidgetState
    extends State<MedicationDatePickerWidget> {
  DateTime? _expirationDate;

  @override
  Widget build(BuildContext context) {
    return ThemedContainerWidget(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorScheme.of(context).scrim,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                _expirationDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 30),
                );
                setState(() {
                  widget.onDatePicked(_expirationDate);
                });
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: ColorScheme.of(context).primary),
                minimumSize: const Size(170, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(5.0),
                ),
                backgroundColor: ColorScheme.of(context).primary,
              ),
              child: Text(
                _expirationDate == null
                    ? "Nepasirinkta"
                    : _expirationDate.toString().split(" ")[0],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
