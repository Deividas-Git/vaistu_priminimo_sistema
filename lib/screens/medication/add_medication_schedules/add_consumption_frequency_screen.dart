import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';

class AddConsumptionFrequencyScreen extends StatelessWidget {
  const AddConsumptionFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vartojimo dažnumas"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(child: Column()),
        ),
      ),
    );
  }
}
