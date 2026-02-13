import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_information_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/spinner_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddConsumptionTimesWithAmount extends StatefulWidget {
  const AddConsumptionTimesWithAmount({
    super.key,
    required this.medicationType,
    required this.prefilledMedicationSchedule,
  });
  final MedicationType medicationType;
  final MedicationSchedule prefilledMedicationSchedule;

  @override
  State<AddConsumptionTimesWithAmount> createState() =>
      _AddConsumptionTimesWithAmountState();
}

class _AddConsumptionTimesWithAmountState
    extends State<AddConsumptionTimesWithAmount> {
  final List<MedicationConsumptionTimeWithAmount> _consumptionTimesWithAmount =
      [];

  void _onDialogConfirmed(
    MedicationConsumptionTimeWithAmount consumptionTimeWithAmount,
  ) {
    setState(() {
      _consumptionTimesWithAmount.add(consumptionTimeWithAmount);
    });
  }

  void _onAddConsumptionTimeAndAmount() {
    showDialog(
      context: context,
      builder: (context) => ConsumptionTimeWithAmountDialog(
        medicationType: widget.medicationType,
        onDialogConfirmed: _onDialogConfirmed,
      ),
    );
  }

  void _onCompletePressed() {
    //Navigator.popUntil(context, (route) => route.settings.name == "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Laiko ir kiekio pridėjimas"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SectionTextWidget(
                label: "Nustatykite vartojimui laikus ir kiekį",
              ),
              AddInformationWidget(
                label: "Pridėti laiką ir kiekį",
                onStartAddingInfo: _onAddConsumptionTimeAndAmount,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        label: "Baigti",
        onContinuePressed: _consumptionTimesWithAmount.isNotEmpty
            ? _onCompletePressed
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ConsumptionTimeWithAmountDialog extends StatefulWidget {
  const ConsumptionTimeWithAmountDialog({
    super.key,
    required this.medicationType,
    required this.onDialogConfirmed,
  });
  final MedicationType medicationType;
  final Function(MedicationConsumptionTimeWithAmount) onDialogConfirmed;

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
    widget.onDialogConfirmed(medicationConsumptionTimeWithAmount);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SectionTextWidget(label: "Kiekis:"),
            ThemedContainerWidget(
              child: Row(
                children: [
                  Text(
                    "${widget.medicationType.getDoseLabel} $_amount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(width: 10),
                  AmountButtonWidget(
                    icon: Icon(Icons.remove, color: Colors.white),
                    onTap: _onAmountDecline,
                  ),
                  SizedBox(width: 5),
                  AmountButtonWidget(
                    icon: Icon(Icons.add, color: Colors.white),
                    onTap: _onAmountAdd,
                  ),
                ],
              ),
            ),
            Divider(thickness: 2),
            SectionTextWidget(label: "Laikas:"),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: TimeSpinner(
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
        ElevatedButton(
          onPressed: _onDialogConfirmed,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorScheme.of(context).primary,
          ),
          child: const Text("Pridėti", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class AmountButtonWidget extends StatelessWidget {
  const AmountButtonWidget({
    super.key,
    required this.icon,
    required this.onTap,
  });

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
            color: ColorScheme.of(context).primary.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: icon,
        ),
      ),
    );
  }
}

class TimeSpinner extends StatelessWidget {
  TimeSpinner({
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
