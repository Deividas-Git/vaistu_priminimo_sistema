import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';

class AddMedicationInfoScreen extends StatefulWidget {
  const AddMedicationInfoScreen({super.key});

  @override
  State<AddMedicationInfoScreen> createState() =>
      _AddMedicationInfoScreenState();
}

class _AddMedicationInfoScreenState extends State<AddMedicationInfoScreen> {
  final TextEditingController _medicationNameController =
      TextEditingController();
  final UserMedication _medication = UserMedication();
  final List<DropdownMenuEntry<MedicationType>> _medicationTypes =
      MedicationType.values
          .map((type) => DropdownMenuEntry(value: type, label: type.getLabel))
          .toList();
  DateTime? _expirationDate;
  MedicationType _medicationType = MedicationType.other;
  MedicationMealTiming _medicationMealTiming = MedicationMealTiming.unspecified;

  void _onExpirationDatePicked(DateTime? date) {
    _expirationDate = date;
  }

  void _onMedicationTypeSelected(dynamic medicationType) {
    _medicationType = medicationType;
  }

  void _onContinuePressed() {
    //jei viskas jau pachekinta ir ok
    _medication.name = _medicationNameController.text.trim();
    _medication.expirationDate = _expirationDate;
    _medication.medicationType = _medicationType;
    _medication.medicationMealTiming = _medicationMealTiming;
    debugPrint(_medication.toString());
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vaisto informacija"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  TextField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      labelText: "Vaisto pavadinimas",
                      hintText: "Įveskite vaisto pavadinimą",
                    ),
                  ),
                  const SizedBox(height: 10),
                  MedicationDatePickerWidget(
                    label: "Vaistas galioja iki:",
                    onDatePicked: _onExpirationDatePicked,
                  ),
                  const SizedBox(height: 10),
                  DropdownMenuWidget(
                    initialSelection: MedicationType.other,
                    entries: _medicationTypes,
                    onEntrySelected: _onMedicationTypeSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        onContinuePressed: _onContinuePressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
