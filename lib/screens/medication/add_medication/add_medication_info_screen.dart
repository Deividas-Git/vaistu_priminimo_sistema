import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_type_selection_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/dropdown_menu_widget.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';

class AddMedicationInfoScreen extends StatefulWidget {
  const AddMedicationInfoScreen({super.key, this.prefilledMedication});
  final UserMedication? prefilledMedication;

  @override
  State<AddMedicationInfoScreen> createState() =>
      _AddMedicationInfoScreenState();
}

class _AddMedicationInfoScreenState extends State<AddMedicationInfoScreen> {
  final TextEditingController _medicationNameController =
      TextEditingController();
  final List<DropdownMenuEntry<MedicationType>> _medicationTypes =
      MedicationType.values
          .map((type) => DropdownMenuEntry(value: type, label: type.getLabel))
          .toList();
  final List<DropdownMenuEntry<MedicationMealTiming>> _medicationMealtTimings =
      MedicationMealTiming.values
          .map(
            (mealTiming) => DropdownMenuEntry(
              value: mealTiming,
              label: mealTiming.getLabel,
            ),
          )
          .toList();
  DateTime? _expirationDate;
  MedicationType? _medicationType;
  MedicationMealTiming? _medicationMealTiming;

  void _onExpirationDatePicked(DateTime? date) {
    _expirationDate = date;
  }

  void _onMedicationTypeSelected(MedicationType? medicationType) {
    _medicationType = medicationType;
  }

  void _onMedicationMealTimingSelected(MedicationMealTiming? mealTiming) {
    _medicationMealTiming = mealTiming;
  }

  void _onContinuePressed() {
    final UserMedication medication =
        (widget.prefilledMedication ?? UserMedication.empty()).copyWith(
          name: _medicationNameController.text.trim(),
          expirationDate: _expirationDate,
          medicationMealTiming: _medicationMealTiming,
          medicationType: _medicationType,
        );

    debugPrint("APIE VAISTA: ${medication.toString()}");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (contex) => AddTypeSelectionScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _medicationType =
        widget.prefilledMedication?.medicationType ?? MedicationType.other;
    _medicationMealTiming =
        widget.prefilledMedication?.medicationMealTiming ??
        MedicationMealTiming.unspecified;
    _medicationNameController.text = widget.prefilledMedication?.name ?? "";
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
                  SectionTextWidget(
                    label: "Pasirinkite kada bus vartojamas vaistas",
                  ),
                  DropdownMenuWidget<MedicationMealTiming?>(
                    initialSelection: _medicationMealTiming,
                    entries: _medicationMealtTimings,
                    onEntrySelected: _onMedicationMealTimingSelected,
                  ),
                  const SizedBox(height: 10),
                  SectionTextWidget(label: "Pasirinkite vaisto tipą"),
                  DropdownMenuWidget<MedicationType?>(
                    initialSelection: _medicationType,
                    entries: _medicationTypes,
                    onEntrySelected: _onMedicationTypeSelected,
                  ),
                  //Checkbox(value: _medication.currentQuantity == null ? false : true, onChanged: onChanged)
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
