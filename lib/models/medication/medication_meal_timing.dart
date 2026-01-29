enum MedicationMealTiming {
  beforeMeal,
  duringMeal,
  afterMeal,
  unspecified;

  String get getLabel {
    switch (this) {
      case MedicationMealTiming.beforeMeal:
        return "Prieš valgį";
      case MedicationMealTiming.duringMeal:
        return "Valgio metu";
      case MedicationMealTiming.afterMeal:
        return "Po valgio";
      default:
        return "Nenurodyta";
    }
  }
}
