import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/themed_container_widget.dart';

class AddMedicationInfoScreen extends StatefulWidget {
  const AddMedicationInfoScreen({super.key});

  @override
  State<AddMedicationInfoScreen> createState() =>
      _AddMedicationInfoScreenState();
}

class _AddMedicationInfoScreenState extends State<AddMedicationInfoScreen> {
  final TextEditingController _medicationNameController =
      TextEditingController();
  final UserMedication medication = UserMedication();
  DateTime? _selectedDate;

  void _onContinuePressed() {
    //jei viskas jau pachekinta ir ok
    medication.name = _medicationNameController.text.trim();
    medication.expirationDate = _selectedDate;
    debugPrint(medication.toString());
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
                  SizedBox(height: 10),
                  ThemedContainerWidget(
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(
                          "Vaistas galioja iki:",
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorScheme.of(context).scrim,
                          ),
                        ),
                        SizedBox(width: 50),
                        OutlinedButton(
                          onPressed: () async {
                            _selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(DateTime.now().year + 30),
                            );
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: ColorScheme.of(context).primary,
                            ),
                            minimumSize: Size(170, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(5.0),
                            ),
                            backgroundColor: ColorScheme.of(context).primary,
                          ),
                          child: Text(
                            _selectedDate == null
                                ? "Nepasirinkta"
                                : _selectedDate.toString().split(" ")[0],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
