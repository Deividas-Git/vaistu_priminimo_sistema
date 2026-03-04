import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/add_medication/add_medication_info_screen.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/add_medication_app_bar.dart';
import 'package:vaistu_priminimo_sistema/screens/medication/widgets/continue_button.dart';
import 'package:vaistu_priminimo_sistema/widgets/section_text_widget.dart';

enum SelectedOptionToAddMedication {
  manual,
  scan,
  import;

  String get getLabel {
    switch (this) {
      case manual:
        return "Pridėti pačiam";
      case scan:
        return "Skenuoti vaisto kodą";
      case import:
        return "Įtraukti iš e. sveikatos";
    }
  }

  //TODO atnaujinti su kitais langais
  Widget get getScreen {
    switch (this) {
      case manual:
        return AddMedicationInfoScreen();
      case scan:
        return AddMedicationInfoScreen();
      case import:
        return AddMedicationInfoScreen();
    }
  }
}

class AddTypeSelectionScreen extends StatefulWidget {
  const AddTypeSelectionScreen({super.key});

  @override
  State<AddTypeSelectionScreen> createState() => _AddTypeSelectionScreenState();
}

class _AddTypeSelectionScreenState extends State<AddTypeSelectionScreen> {
  SelectedOptionToAddMedication _selectedOptionToAddMedication =
      SelectedOptionToAddMedication.manual;

  void _onOptionSelected(SelectedOptionToAddMedication optionToAddMedication) {
    setState(() {
      _selectedOptionToAddMedication = optionToAddMedication;
    });
  }

  void _onContinuePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _selectedOptionToAddMedication.getScreen,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedOptionToAddMedication = SelectedOptionToAddMedication.manual;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddMedicationAppBar(title: "Vaisto pridėjimas"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Center(
            child: Column(
              children: [
                SectionTextWidget(label: "Kaip norėtumėte pridėti vaistą?"),
                ...SelectedOptionToAddMedication.values.map(
                  (option) => Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: MedicationAddOptionButton(
                      selection: _selectedOptionToAddMedication,
                      optionToAddMedication: option,
                      onOptionSelected: _onOptionSelected,
                    ),
                  ),
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

class MedicationAddOptionButton extends StatefulWidget {
  const MedicationAddOptionButton({
    super.key,
    required this.selection,
    required this.optionToAddMedication,
    required this.onOptionSelected,
  });

  final SelectedOptionToAddMedication selection;
  final SelectedOptionToAddMedication optionToAddMedication;
  final void Function(SelectedOptionToAddMedication) onOptionSelected;

  @override
  State<MedicationAddOptionButton> createState() =>
      _MedicationAddOptionButtonState();
}

class _MedicationAddOptionButtonState extends State<MedicationAddOptionButton> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () => widget.onOptionSelected(widget.optionToAddMedication),
        child: Ink(
          height: 55,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.selection == widget.optionToAddMedication
                ? colorScheme.primary
                : Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: colorScheme.secondary),
          ),
          child: Center(
            child: Text(
              widget.optionToAddMedication.getLabel,
              style: TextStyle(
                fontSize: 16,
                color: widget.selection == widget.optionToAddMedication
                    ? Colors.white
                    : colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
