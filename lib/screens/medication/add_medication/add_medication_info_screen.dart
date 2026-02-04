import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_medication_schedules_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_type_selection_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_quantity_widget.dart';
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
  double? _currentQuantity;

  void _onExpirationDatePicked(DateTime? date) {
    _expirationDate = date;
  }

  void _onMedicationTypeSelected(MedicationType? medicationType) {
    setState(() {
      _medicationType = medicationType;
      if (_currentQuantity != null) _currentQuantity = 0;
    });
  }

  void _onMedicationMealTimingSelected(MedicationMealTiming? mealTiming) {
    _medicationMealTiming = mealTiming;
  }

  void _onQuantityCheckboxChecked(bool? isChecked) {
    if (isChecked == null) return;
    setState(() {
      _currentQuantity = isChecked ? _currentQuantity = 0 : null;
    });
  }

  void _onCurrentQuantityChanged(double? quantity) {
    _currentQuantity = quantity;
  }

  void _onContinuePressed() {
    final UserMedication medication =
        (widget.prefilledMedication ?? UserMedication.empty()).copyWith(
          name: _medicationNameController.text.trim(),
          expirationDate: _expirationDate,
          medicationMealTiming: _medicationMealTiming,
          medicationType: _medicationType,
          currentQuantity: _currentQuantity,
        );

    debugPrint("APIE VAISTA: ${medication.toString()}");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contex) =>
            AddMedicationSchedulesScreen(prefilledMedication: medication),
      ),
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
          padding: const EdgeInsets.all(20.0),
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
                SizedBox(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _currentQuantity == null ? false : true,
                          onChanged: _onQuantityCheckboxChecked,
                        ),
                        const Text(
                          "Pridėti vaisto likutį",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_currentQuantity != null)
                  MedicationQuantityWidget(
                    medicationType: _medicationType!,
                    onQuantityChanged: _onCurrentQuantityChanged,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ContinueButton(
        label: "Toliau",
        onContinuePressed: _onContinuePressed,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
