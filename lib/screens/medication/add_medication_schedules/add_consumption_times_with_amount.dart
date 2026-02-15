import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/consumption_time_with_amount_dialog.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_information_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddConsumptionTimesWithAmount extends StatefulWidget {
  const AddConsumptionTimesWithAmount({
    super.key,
    required this.medicationType,
    required this.prefilledMedicationSchedule,
    required this.onScheduleAdded,
  });
  final MedicationType medicationType;
  final MedicationSchedule prefilledMedicationSchedule;
  final Function(MedicationSchedule) onScheduleAdded;

  @override
  State<AddConsumptionTimesWithAmount> createState() =>
      _AddConsumptionTimesWithAmountState();
}

class _AddConsumptionTimesWithAmountState
    extends State<AddConsumptionTimesWithAmount> {
  final List<MedicationConsumptionTimeWithAmount> _consumptionTimesWithAmount =
      [];

  void _onDialogConfirmed(
    MedicationConsumptionTimeWithAmount newConsumptionTimeWithAmount,
    MedicationConsumptionTimeWithAmount? oldConsumptionTimeWithAmount,
  ) {
    //TODO tikrinti ar nera jau sukurta tam paciam laikui
    setState(() {
      if (oldConsumptionTimeWithAmount == null) {
        _consumptionTimesWithAmount.add(newConsumptionTimeWithAmount);
      } else {
        final int currentIndex = _consumptionTimesWithAmount.indexOf(
          oldConsumptionTimeWithAmount,
        );
        if (currentIndex < 0) return;
        _consumptionTimesWithAmount[currentIndex] =
            newConsumptionTimeWithAmount;
      }
    });
  }

  void _onAddEditConsumptionTimeAndAmount([
    MedicationConsumptionTimeWithAmount? medicationConsumptionTimeWithAmount,
  ]) {
    showDialog(
      context: context,
      builder: (context) => ConsumptionTimeWithAmountDialog(
        prefilledMedicationConsumptionTimeWithAmount:
            medicationConsumptionTimeWithAmount,
        medicationType: widget.medicationType,
        onDialogConfirmed: _onDialogConfirmed,
      ),
    );
  }

  void _onDeleteConsumptionTimeAndAmount(
    MedicationConsumptionTimeWithAmount medicationConsumptionTimeWithAmount,
  ) {
    setState(() {
      _consumptionTimesWithAmount.remove(medicationConsumptionTimeWithAmount);
    });
  }

  void _onCompletePressed() {
    final MedicationSchedule medicationSchedule = widget
        .prefilledMedicationSchedule
        .copyWith(consumptionTimesWithAmount: _consumptionTimesWithAmount);
    widget.onScheduleAdded(medicationSchedule);
    Navigator.pop(context);
    Navigator.pop(context);
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
              ..._consumptionTimesWithAmount.map(
                (e) => _ScheduledMedicationTimeAndAmountTileWidget(
                  medicationConsumptionTimeWithAmount: e,
                  medicationType: widget.medicationType,
                  onEditPressed: _onAddEditConsumptionTimeAndAmount,
                  onDeletePressed: _onDeleteConsumptionTimeAndAmount,
                ),
              ),
              AddInformationWidget(
                label: "Pridėti laiką ir kiekį",
                onStartAddingInfo: _onAddEditConsumptionTimeAndAmount,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        label: "Pridėti",
        onContinuePressed: _consumptionTimesWithAmount.isNotEmpty
            ? _onCompletePressed
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ScheduledMedicationTimeAndAmountTileWidget extends StatelessWidget {
  const _ScheduledMedicationTimeAndAmountTileWidget({
    required this.medicationConsumptionTimeWithAmount,
    required this.medicationType,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final MedicationConsumptionTimeWithAmount medicationConsumptionTimeWithAmount;
  final MedicationType medicationType;
  final Function(MedicationConsumptionTimeWithAmount) onEditPressed;
  final Function(MedicationConsumptionTimeWithAmount) onDeletePressed;

  void _onEditPressed() {
    onEditPressed(medicationConsumptionTimeWithAmount);
  }

  void _onDeletePressed() {
    onDeletePressed(medicationConsumptionTimeWithAmount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedContainerWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(onPressed: _onEditPressed, icon: Icon(Icons.edit)),
              SizedBox(
                height: 50,
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorScheme.of(
                      context,
                    ).primary.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Text(
                      "${(medicationConsumptionTimeWithAmount.time.hour).toString().padLeft(2, '0')}:${(medicationConsumptionTimeWithAmount.time.minute).toString().padLeft(2, '0')}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "${medicationType.getDoseLabel} ${medicationConsumptionTimeWithAmount.consumptionAmount}",
                style: TextStyle(
                  fontSize: 16,
                  color: ColorScheme.of(context).secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _onDeletePressed,
                icon: Icon(
                  Icons.delete,
                  color: const Color.fromARGB(255, 196, 49, 38),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 2),
      ],
    );
  }
}
