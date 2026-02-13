enum MedicationType {
  pills,
  capsules,
  drops,
  spray,
  ointment,
  other;

  String get getLabel {
    switch (this) {
      case MedicationType.pills:
        return "Tabletės";
      case MedicationType.capsules:
        return "Kapsulės";
      case MedicationType.drops:
        return "Lašai";
      case MedicationType.spray:
        return "Purškalas";
      case MedicationType.ointment:
        return "Tepalas";
      default:
        return "Kita";
    }
  }

  String get getDoseLabel {
    switch (this) {
      case MedicationType.pills:
        return "Tablečių skaičius: ";
      case MedicationType.capsules:
        return "Kapsulių skaičius: ";
      case MedicationType.drops:
        return "Lašų skaičius: ";
      case MedicationType.spray:
        return "Purškimo kartai: ";
      case MedicationType.ointment:
        return "Tepimo kartai: ";
      default:
        return "Naudojimo kartai: ";
    }
  }

  String get getUnit {
    switch (this) {
      case MedicationType.pills:
        return "vnt.";
      case MedicationType.capsules:
        return "vnt.";
      case MedicationType.drops:
        return "ml";
      case MedicationType.spray:
        return "ml";
      case MedicationType.ointment:
        return "g";
      default:
        return "";
    }
  }

  bool get consumedAmoutIsInteger {
    switch (this) {
      case MedicationType.pills:
        return true;
      case MedicationType.capsules:
        return true;
      default:
        return false;
    }
  }
}
