import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class ScheduleTileWidget extends StatelessWidget {
  const ScheduleTileWidget({
    super.key,
    required this.medicationForm,
    required this.schedule,
    this.onEditPressed,
    this.onDeletePressed,
  });

  final MedicationForm medicationForm;
  final MedicationSchedule schedule;
  final Function(MedicationSchedule)? onEditPressed;
  final Function(MedicationSchedule)? onDeletePressed;

  void _onEditSchedule() {
    onEditPressed!(schedule);
  }

  void _onDeleteSchedule() {
    onDeletePressed!(schedule);
  }

  String _durationText() {
    String text;
    final String startDate =
        "${schedule.startDate.year}-${schedule.startDate.month.toString().padLeft(2, '0')}-${schedule.startDate.day.toString().padLeft(2, '0')}";
    text = "Vartojama nuo $startDate iki";
    if (schedule.endDate == null) {
      text = "$text neribotai";
    } else {
      final String endDate =
          "${schedule.endDate!.year}-${schedule.endDate!.month.toString().padLeft(2, '0')}-${schedule.endDate!.day.toString().padLeft(2, '0')}";
      text = "$text $endDate";
    }

    return text;
  }

  String _consumptionFrequencyText() {
    String text =
        "Dažnumas - ${schedule.medicationFrequencyType.getLabel.toLowerCase()}:";
    if (schedule.medicationFrequencyType ==
        MedicationFrequencyType.constantIntervals) {
      text =
          "$text ${MedicationFrequencyType.intervalDaysLabels[schedule.intervalsDays! - 1].toLowerCase()}";
    } else {
      for (Weekday day in schedule.weekdays!) {
        text = "$text ${day.getLabel.toLowerCase()},";
      }
      text = text.substring(0, text.length - 1);
    }
    return text;
  }

  String _consumptionTimeAndAmountText(MedicationConsumptionTimeWithAmount e) {
    final String hour = e.time.hour.toString().padLeft(2, "0");
    final String min = e.time.minute.toString().padLeft(2, "0");
    final String text =
        "Laikas: $hour:$min, ${medicationForm.getDoseLabel.toLowerCase()} ${e.consumptionAmount}";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPreview = onEditPressed == null && onDeletePressed == null;

    return Column(
      children: [
        ThemedContainerWidget(
          doesHeightExpand: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: isPreview
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isPreview)
                    IconButton(
                      onPressed: _onEditSchedule,
                      icon: Icon(Icons.edit),
                    ),
                  Expanded(
                    child: Text(
                      schedule.name!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: ColorScheme.of(context).secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isPreview)
                    IconButton(
                      onPressed: _onDeleteSchedule,
                      icon: Icon(
                        Icons.delete,
                        //color: const Color.fromARGB(255, 196, 49, 38),
                      ),
                    ),
                ],
              ),
              Divider(thickness: 1, color: ColorScheme.of(context).secondary),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      _durationText(),
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorScheme.of(context).secondary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      _consumptionFrequencyText(),
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorScheme.of(context).secondary,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1, color: ColorScheme.of(context).secondary),
              Column(
                children: [
                  Text(
                    "Vartojimo laikai ir kiekiai",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorScheme.of(context).secondary,
                    ),
                  ),
                  SizedBox(height: 5),
                  ...schedule.consumptionTimesWithAmount!.map(
                    (e) => SizedBox(
                      width: double.infinity,
                      child: Text(
                        _consumptionTimeAndAmountText(e),
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorScheme.of(context).secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(thickness: 2),
      ],
    );
  }
}
