enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get getLabel {
    switch (this) {
      case Weekdays.monday:
        return "Pir";
      case Weekdays.tuesday:
        return "Ant";
      case Weekdays.wednesday:
        return "Tre";
      case Weekdays.thursday:
        return "Ket";
      case Weekdays.friday:
        return "Pen";
      case Weekdays.saturday:
        return "Šeš";
      case Weekdays.sunday:
        return "Sek";
    }
  }
}
