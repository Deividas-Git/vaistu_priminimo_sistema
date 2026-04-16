enum MedicationForm {
  pills,
  capsules,
  drops,
  spray,
  ointment,
  other;

  String get getLabel {
    switch (this) {
      case MedicationForm.pills:
        return "Tabletės";
      case MedicationForm.capsules:
        return "Kapsulės";
      case MedicationForm.drops:
        return "Lašai";
      case MedicationForm.spray:
        return "Purškalas";
      case MedicationForm.ointment:
        return "Tepalas";
      default:
        return "Kita";
    }
  }

  String get getDoseLabel {
    switch (this) {
      case MedicationForm.pills:
        return "Tablečių skaičius:";
      case MedicationForm.capsules:
        return "Kapsulių skaičius:";
      case MedicationForm.drops:
        return "Lašų skaičius:";
      case MedicationForm.spray:
        return "Purškimo kartai:";
      case MedicationForm.ointment:
        return "Tepimo kartai:";
      default:
        return "Naudojimo skaičius:";
    }
  }

  String get getUnit {
    switch (this) {
      case MedicationForm.pills:
        return "vnt.";
      case MedicationForm.capsules:
        return "vnt.";
      case MedicationForm.drops:
        return "ml";
      case MedicationForm.spray:
        return "ml";
      case MedicationForm.ointment:
        return "g";
      default:
        return "";
    }
  }

  bool get consumedAmoutIsInteger {
    switch (this) {
      case MedicationForm.pills:
        return true;
      case MedicationForm.capsules:
        return true;
      default:
        return false;
    }
  }

  double get getQuantitySubtract => switch (this) {
    pills => 1.0,
    capsules => 1.0,
    drops => 0.05,
    spray => 0.1,
    ointment => 0.5,
    other => 1.0,
  };
}
