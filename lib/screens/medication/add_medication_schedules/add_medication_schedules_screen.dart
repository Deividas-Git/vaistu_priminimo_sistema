import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/dialogs/consumption_time_with_amount_dialog.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/models/weekday.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_consumption_frequency_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_information_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddMedicationSchedulesScreen extends StatefulWidget {
  const AddMedicationSchedulesScreen({
    super.key,
    required this.prefilledMedication,
  });
  final UserMedication prefilledMedication;

  @override
  State<AddMedicationSchedulesScreen> createState() =>
      _AddMedicationSchedulesScreenState();
}

class _AddMedicationSchedulesScreenState
    extends State<AddMedicationSchedulesScreen> {
  late List<MedicationSchedule> _medicationSchedules;
  int? indexOfEditedSchedule;

  void _onAddEditSchedule([MedicationSchedule? scheduleToEdit]) {
    if (scheduleToEdit != null) {
      indexOfEditedSchedule = _medicationSchedules.indexOf(scheduleToEdit);
    } else {
      indexOfEditedSchedule = null;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddConsumptionFrequencyScreen(
          prefilledMedicationSchedule: scheduleToEdit,
          medicationType: widget.prefilledMedication.medicationType!,
          onScheduleAdded: _onScheduleAdded,
        ),
      ),
    );
  }

  void _onDeleteSchedule(MedicationSchedule medicationSchedule) {
    setState(() {
      _medicationSchedules.remove(medicationSchedule);
    });
  }

  void _onScheduleAdded(MedicationSchedule medicationSchedule) {
    setState(() {
      //TODO SU TUO PACIU PAVADINIMU TRINAM, pirma alert dialogas

      // for (final MedicationSchedule schedule in _medicationSchedules) {
      //   if(schedule.name == medicationSchedule.name){
      //   }
      // }

      if (indexOfEditedSchedule == null) {
        _medicationSchedules.add(medicationSchedule);
      } else {
        _medicationSchedules[indexOfEditedSchedule!] = medicationSchedule;
        indexOfEditedSchedule = null;
      }
    });
  }

  void _onContinuePressed() {
    final UserMedication medication = widget.prefilledMedication.copyWith(
      medicationSchedules: _medicationSchedules,
    );
    //TODO medication service ir irasom duomenis i db
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  void initState() {
    super.initState();
    _medicationSchedules = widget.prefilledMedication.medicationSchedules ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vartojimo tvarkaraščiai"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SectionTextWidget(
                    label: "Sukurkite vaistų vartojimo tvarkaraščius",
                  ),
                  ..._medicationSchedules.map(
                    (schedule) => _ScheduleTileWidget(
                      medicationType:
                          widget.prefilledMedication.medicationType!,
                      schedule: schedule,
                      onEditPressed: _onAddEditSchedule,
                      onDeletePressed: _onDeleteSchedule,
                    ),
                  ),
                  AddInformationWidget(
                    label: "Pridėti tvarkaraštį",
                    onStartAddingInfo: _onAddEditSchedule,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        label: _medicationSchedules.isEmpty ? "Praleisti ir baigti" : "Baigti",
        onContinuePressed: _onContinuePressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _ScheduleTileWidget extends StatelessWidget {
  const _ScheduleTileWidget({
    required this.medicationType,
    required this.schedule,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  final MedicationType medicationType;
  final MedicationSchedule schedule;
  final Function(MedicationSchedule) onEditPressed;
  final Function(MedicationSchedule) onDeletePressed;

  void _onEditSchedule() {
    onEditPressed(schedule);
  }

  void _onDeleteSchedule() {
    onDeletePressed(schedule);
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
      debugPrint("INTERVALAI: ${schedule.intervalsDays}");
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
        "Laikas: $hour:$min, ${medicationType.getDoseLabel.toLowerCase()} ${e.consumptionAmount}";
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ThemedContainerWidget(
          //height: 150,
          doesHeightExpand: true,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _onEditSchedule,
                    icon: Icon(Icons.edit),
                  ),
                  Text(
                    schedule.name!,
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorScheme.of(context).secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _onDeleteSchedule,
                    icon: Icon(
                      Icons.delete,
                      color: const Color.fromARGB(255, 196, 49, 38),
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
