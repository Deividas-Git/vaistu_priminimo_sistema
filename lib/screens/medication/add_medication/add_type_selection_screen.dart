import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';

class AddTypeSelectionScreen extends StatelessWidget {
  const AddTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vaisto pridėjimas"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              children: [
                MedicationAddOptionButton(label: "Pasirinkimas"),
                MedicationAddOptionButton(label: "Pasirinkimas"),
                MedicationAddOptionButton(label: "Pasirinkimas"),
                MedicationAddOptionButton(label: "Pasirinkimas"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MedicationAddOptionButton extends StatelessWidget {
  const MedicationAddOptionButton({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        side: BorderSide(color: ColorScheme.of(context).primary),
        minimumSize: Size(250, 40),
      ),
      child: Text("Pasirinkimas"),
    );
  }
}
