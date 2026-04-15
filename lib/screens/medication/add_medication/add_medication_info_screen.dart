import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication_schedules/add_medication_schedules_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/checkbox_with_label_widget.dart';
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
  final TextEditingController _medicationQuantityInputController =
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
  String? _medicationNameError;
  late bool isQuantityAdded;

  void _onExpirationDatePicked(DateTime? date) {
    setState(() {
      _expirationDate = date;
    });
  }

  void _onMedicationTypeSelected(MedicationType? medicationType) {
    setState(() {
      _medicationType = medicationType;
      final String temp = _medicationQuantityInputController.text.replaceAll(
        ",",
        ".",
      );
      List<String> quantity = temp.split(".");
      if (_medicationType!.consumedAmoutIsInteger && quantity.length == 2) {
        _medicationQuantityInputController.text = quantity[0];
      }
    });
  }

  void _onMedicationMealTimingSelected(MedicationMealTiming? mealTiming) {
    _medicationMealTiming = mealTiming;
  }

  void _onQuantityCheckboxChecked(bool? isChecked) {
    if (isChecked == null) return;
    setState(() {
      isQuantityAdded = isChecked;
      _medicationQuantityInputController.text = "0";
    });
  }

  void _onContinuePressed() {
    if (_medicationNameController.text.trim().isEmpty) {
      setState(() {
        _medicationNameError = "Privalomas laukas";
      });
      return;
    }

    final UserMedication medication =
        (widget.prefilledMedication ?? UserMedication.empty()).copyWith(
          name: _medicationNameController.text.trim(),
          expirationDate: _expirationDate,
          medicationMealTiming: _medicationMealTiming,
          medicationType: _medicationType,
          currentQuantity: isQuantityAdded
              ? double.tryParse(
                  _medicationQuantityInputController.text.replaceAll(",", "."),
                )
              : null,
        );

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
    isQuantityAdded = widget.prefilledMedication?.currentQuantity != null
        ? true
        : false;
    _medicationQuantityInputController.text = isQuantityAdded
        ? widget.prefilledMedication!.medicationType!.consumedAmoutIsInteger
              ? widget.prefilledMedication!.currentQuantity.toString().split(
                  ".",
                )[0]
              : widget.prefilledMedication!.currentQuantity.toString()
        : "0";
    _expirationDate = widget.prefilledMedication?.expirationDate;
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _medicationQuantityInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vaisto informacija"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextField(
                  controller: _medicationNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Vaisto pavadinimas",
                    hintText: "Įveskite vaisto pavadinimą",
                    errorText: _medicationNameError,
                  ),
                ),
                const SizedBox(height: 10),
                MedicationDatePickerWidget(
                  label: "Galioja iki:",
                  selectedDate: _expirationDate,
                  onDatePicked: _onExpirationDatePicked,
                ),
                const SizedBox(height: 10),
                SectionTextWidget(label: "Pasirinkite vaisto tipą"),
                DropdownMenuWidget<MedicationType>(
                  initialSelection: _medicationType,
                  entries: _medicationTypes,
                  onEntrySelected: _onMedicationTypeSelected,
                ),
                const SizedBox(height: 5),
                CheckboxWithLabelWidget(
                  label: "Pridėti vaisto likutį",
                  isChecked: isQuantityAdded,
                  onChanged: _onQuantityCheckboxChecked,
                ),
                if (isQuantityAdded)
                  MedicationQuantityWidget(
                    medicationType: _medicationType!,
                    controller: _medicationQuantityInputController,
                  ),
                const Divider(thickness: 2),
                SectionTextWidget(
                  label: "Pasirinkite kada bus vartojamas vaistas",
                ),
                DropdownMenuWidget<MedicationMealTiming>(
                  initialSelection: _medicationMealTiming,
                  entries: _medicationMealtTimings,
                  onEntrySelected: _onMedicationMealTimingSelected,
                ),
                const SizedBox(height: 100),
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
