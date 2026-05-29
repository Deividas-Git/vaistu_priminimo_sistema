enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static Weekday getWeekdayFromNumber(int num) {
    if (num > 7 || num < 1) {
      throw Exception("Klaida gaunant savaitės dieną $num");
    }
    return Weekday.values[num - 1];
  }

  String get getLabel => switch (this) {
    monday => "Pir",
    tuesday => "Ant",
    wednesday => "Tre",
    thursday => "Ket",
    friday => "Pen",
    saturday => "Šeš",
    sunday => "Sek",
  };
}
