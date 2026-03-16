import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaistu_priminimo_sistema/dialogs/confirmation_dialog.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/providers/user_provider.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_consumption_frequency_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_information_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/schedule_tile_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';

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

  void _onDeleteSchedule(MedicationSchedule medicationSchedule) async {
    final bool? didConfirm = await showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message: "Ar tikrai norite panaikinti pasirinktą tvarkaraštį?",
        title: "Tvarkaraščio šalinimas",
        rightOptionText: "Naikinti",
        leftOptionText: "Atšaukti",
        leftSideHighlighted: true,
      ),
    );

    if (didConfirm == true) {
      setState(() {
        _medicationSchedules.remove(medicationSchedule);
      });
    }
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

  void _onSaveMedication() {
    final UserMedication medication = widget.prefilledMedication.copyWith(
      medicationSchedules: _medicationSchedules.isEmpty
          ? null
          : _medicationSchedules,
    );
    final String uid = context.read<UserProvider>().appUser!.uid;
    if (medication.id == null) {
      context.read<MedicationProvider>().addMedication(medication, uid);
    } else {
      context.read<MedicationProvider>().updateMedication(medication, uid);
    }
    debugPrint(medication.toString());
    //TODO tikrinti cia ar editinamas ar naujas
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
                    (schedule) => ScheduleTileWidget(
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
        onContinuePressed: _onSaveMedication,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
