import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class MedicationDatePickerWidget extends StatelessWidget {
  const MedicationDatePickerWidget({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDatePicked,
    this.linesDevided,
  });

  final String label;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?>? onDatePicked;
  final bool? linesDevided;

  @override
  Widget build(BuildContext context) {
    final bool isPreview = onDatePicked == null;
    final List<Widget> children = [
      Row(
        mainAxisAlignment: linesDevided == true
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: ColorScheme.of(context).scrim,
            ),
          ),
        ],
      ),

      OutlinedButton(
        onPressed: isPreview
            ? null
            : () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 30),
                );
                onDatePicked!(date);
              },
        style: OutlinedButton.styleFrom(
          //side: BorderSide(color: ColorScheme.of(context).primary),
          //maximumSize: const Size(150, 40),
          //minimumSize: const Size(170, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(5.0),
          ),
          backgroundColor: isPreview
              ? ColorScheme.of(context).secondary
              : ColorScheme.of(context).primary,
        ),
        child: Text(
          selectedDate == null
              ? "Nepasirinkta"
              : selectedDate.toString().split(" ")[0],
          style: TextStyle(
            color: isPreview
                ? ColorScheme.of(context).onSecondary.withValues(alpha: 0.5)
                : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return ThemedContainerWidget(
      doesHeightExpand: linesDevided == true,
      child: linesDevided != true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children,
            )
          : Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: children,
            ),
    );
  }
}
