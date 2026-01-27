enum MedicationFrequencyType {
  constantIntervals,
  selectedDays;

  String get getLabel {
    switch (this) {
      case MedicationFrequencyType.constantIntervals:
        return "Pastovūs intervalai";
      case MedicationFrequencyType.selectedDays:
        return "Pasirinktomis dienomis";
    }
  }
}
