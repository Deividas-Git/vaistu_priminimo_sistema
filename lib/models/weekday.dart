enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get getLabel {
    switch (this) {
      case Weekday.monday:
        return "Pir";
      case Weekday.tuesday:
        return "Ant";
      case Weekday.wednesday:
        return "Tre";
      case Weekday.thursday:
        return "Ket";
      case Weekday.friday:
        return "Pen";
      case Weekday.saturday:
        return "Šeš";
      case Weekday.sunday:
        return "Sek";
    }
  }
}
