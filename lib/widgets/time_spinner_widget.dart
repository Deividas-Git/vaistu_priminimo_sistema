import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/widgets/spinner_widget.dart';

class TimeSpinnerWidget extends StatelessWidget {
  TimeSpinnerWidget({
    super.key,
    required this.onHourSelected,
    required this.onMinSelected,
    required this.initialHour,
    required this.initialMin,
  });

  final List<String> hours = List.generate(
    24,
    (index) => index.toString().padLeft(2, '0'),
  );
  final List<String> mins = List.generate(
    60,
    (index) => index.toString().padLeft(2, '0'),
  );
  final int initialHour;
  final int initialMin;
  final Function(int) onHourSelected;
  final Function(int) onMinSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SpinnerWidget(
            initialIndex: initialHour,
            items: hours,
            onSelectedItemChanged: onHourSelected,
          ),
        ),
        Text(":", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Expanded(
          child: SpinnerWidget(
            initialIndex: initialMin,
            items: mins,
            onSelectedItemChanged: onMinSelected,
          ),
        ),
      ],
    );
  }
}
