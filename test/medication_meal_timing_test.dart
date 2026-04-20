import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';

void main() {
  group('MedicationMealTiming', () {
    test('beforeMeal has correct label', () {
      expect(MedicationMealTiming.beforeMeal.getLabel, 'Prieš valgį');
    });

    test('duringMeal has correct label', () {
      expect(MedicationMealTiming.duringMeal.getLabel, 'Valgio metu');
    });

    test('afterMeal has correct label', () {
      expect(MedicationMealTiming.afterMeal.getLabel, 'Po valgio');
    });

    test('unspecified has correct label', () {
      expect(MedicationMealTiming.unspecified.getLabel, 'Nenurodyta');
    });
  });
}
