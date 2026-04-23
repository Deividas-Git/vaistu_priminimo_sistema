import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_date_picker_widget.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/medication_quantity_widget.dart';

class CholesterolDialog extends StatefulWidget {
  const CholesterolDialog({super.key});

  @override
  State<CholesterolDialog> createState() => _CholesterolDialogState();
}

class _CholesterolDialogState extends State<CholesterolDialog> {
  late final TextEditingController _textEditingController;
  DateTime? _selectedDate = DateTime.now();

  void _onDialogCanceled() {
    Navigator.pop(context);
  }

  void _onDialogConfirmed() {
    Navigator.pop(context, {
      "date": _selectedDate,
      "value": double.tryParse(
        _textEditingController.text.replaceAll(",", "."),
      ),
    });
  }

  void _onDatePicked(DateTime? date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.text = "0";
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Cholesterolio MTL kiekio pridėjimas",
        textAlign: TextAlign.center,
        style: TextStyle(color: ColorScheme.of(context).onSurfaceVariant),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MedicationQuantityWidget(
            medicationForm: MedicationForm.other,
            controller: _textEditingController,
            isNotUsedForQuantity: true,
            label: "MTL kiekis mmol/l",
            linesDevided: true,
          ),
          SizedBox(height: 5),
          MedicationDatePickerWidget(
            label: "Tyrimo data",
            selectedDate: _selectedDate,
            onDatePicked: _onDatePicked,
            linesDevided: true,
          ),
        ],
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
          child: Text(
            "Pridėti",
            style: TextStyle(color: ColorScheme.of(context).onPrimary),
          ),
        ),
      ],
    );
  }
}
