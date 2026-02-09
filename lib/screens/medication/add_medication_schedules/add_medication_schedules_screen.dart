import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_consumption_frequency_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_information_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
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
  final List<MedicationSchedule> _medicationSchedules = [];

  void _onStartAddingSchedule() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddConsumptionFrequencyScreen(onScheduleAdded: _onScheduleAdded),
      ),
    );
  }

  void _onScheduleAdded(MedicationSchedule medicationSchedule) {
    setState(() {
      _medicationSchedules.add(medicationSchedule);
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
                  AddInformationWidget(
                    label: "Pridėti tvarkaraštį",
                    onStartAddingInfo: _onStartAddingSchedule,
                  ),
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
