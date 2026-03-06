import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/time_spinner_widget.dart';

class ConsumptionTimeWithAmountDialog extends StatefulWidget {
  const ConsumptionTimeWithAmountDialog({
    super.key,
    this.prefilledMedicationConsumptionTimeWithAmount,
    required this.medicationType,
    required this.onDialogConfirmed,
  });
  final MedicationConsumptionTimeWithAmount?
  prefilledMedicationConsumptionTimeWithAmount;
  final MedicationType medicationType;
  final Function(
    MedicationConsumptionTimeWithAmount,
    MedicationConsumptionTimeWithAmount?,
  )
  onDialogConfirmed;

  @override
  State<ConsumptionTimeWithAmountDialog> createState() =>
      _ConsumptionTimeWithAmountDialogState();
}

class _ConsumptionTimeWithAmountDialogState
    extends State<ConsumptionTimeWithAmountDialog> {
  int _amount = 1;
  int _hour = TimeOfDay.now().hour;
  int _minute = TimeOfDay.now().minute;

  void _onHourSelected(int index) {
    _hour = index;
  }

  void _onMinSelected(int index) {
    _minute = index;
  }

  void _onAmountAdd() {
    setState(() {
      _amount += 1;
    });
  }

  void _onAmountDecline() {
    if (_amount == 1) return;
    setState(() {
      _amount -= 1;
    });
  }

  void _onDialogCanceled() {
    Navigator.pop(context);
  }

  void _onDialogConfirmed() {
    final time = TimeOfDay(hour: _hour, minute: _minute);
    final MedicationConsumptionTimeWithAmount
    medicationConsumptionTimeWithAmount = MedicationConsumptionTimeWithAmount(
      time: time,
      consumptionAmount: _amount,
    );
    widget.onDialogConfirmed(
      medicationConsumptionTimeWithAmount,
      widget.prefilledMedicationConsumptionTimeWithAmount,
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefilledMedicationConsumptionTimeWithAmount != null) {
      _amount = widget
          .prefilledMedicationConsumptionTimeWithAmount!
          .consumptionAmount;
      _hour = widget.prefilledMedicationConsumptionTimeWithAmount!.time.hour;
      _minute =
          widget.prefilledMedicationConsumptionTimeWithAmount!.time.minute;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceBetween,
      title: Text(textAlign: TextAlign.center, "Priskirti laiką ir kiekį"),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SectionTextWidget(label: "Kiekis:"),
            ThemedContainerWidget(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          widget.medicationType.getDoseLabel,
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorScheme.of(context).secondary,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            _amount.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: ColorScheme.of(context).secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      _AmountButtonWidget(
                        icon: Icon(Icons.remove, color: Colors.white),
                        onTap: _onAmountDecline,
                      ),
                      SizedBox(width: 5),
                      _AmountButtonWidget(
                        icon: Icon(Icons.add, color: Colors.white),
                        onTap: _onAmountAdd,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: 2),
            SectionTextWidget(label: "Laikas:"),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: TimeSpinnerWidget(
                initialHour: _hour,
                initialMin: _minute,
                onHourSelected: _onHourSelected,
                onMinSelected: _onMinSelected,
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _onDialogCanceled,
          child: const Text("Atšaukti"),
        ),
        //SizedBox(width: 10),
        ElevatedButton(
          onPressed: _onDialogConfirmed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: Text(
            widget.prefilledMedicationConsumptionTimeWithAmount == null
                ? "Pridėti"
                : "Redaguoti",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _AmountButtonWidget extends StatelessWidget {
  const _AmountButtonWidget({required this.icon, required this.onTap});

  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: ColorScheme.of(context).primary.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(5),
        highlightColor: ColorScheme.of(
          context,
        ).secondary.withValues(alpha: 0.35),
        onTap: onTap,
        child: Ink(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ColorScheme.of(context).primary.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: icon,
        ),
      ),
    );
  }
}
