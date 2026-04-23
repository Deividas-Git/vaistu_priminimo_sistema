import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';

void main() {
  group('MedicationForm', () {
    test('pills has correct labels and properties', () {
      expect(MedicationForm.pills.getLabel, 'Tabletės');
      expect(MedicationForm.pills.getDoseLabel, 'Tablečių skaičius:');
      expect(MedicationForm.pills.getUnit, 'vnt.');
      expect(MedicationForm.pills.consumedAmoutIsInteger, true);
      expect(MedicationForm.pills.getQuantitySubtract, 1.0);
    });

    test('capsules has correct labels and properties', () {
      expect(MedicationForm.capsules.getLabel, 'Kapsulės');
      expect(MedicationForm.capsules.getDoseLabel, 'Kapsulių skaičius:');
      expect(MedicationForm.capsules.getUnit, 'vnt.');
      expect(MedicationForm.capsules.consumedAmoutIsInteger, true);
      expect(MedicationForm.capsules.getQuantitySubtract, 1.0);
    });

    test('drops has correct labels and properties', () {
      expect(MedicationForm.drops.getLabel, 'Lašai');
      expect(MedicationForm.drops.getDoseLabel, 'Lašų skaičius:');
      expect(MedicationForm.drops.getUnit, 'ml');
      expect(MedicationForm.drops.consumedAmoutIsInteger, false);
      expect(MedicationForm.drops.getQuantitySubtract, 0.05);
    });

    test('spray has correct labels and properties', () {
      expect(MedicationForm.spray.getLabel, 'Purškalas');
      expect(MedicationForm.spray.getDoseLabel, 'Purškimo kartai:');
      expect(MedicationForm.spray.getUnit, 'ml');
      expect(MedicationForm.spray.consumedAmoutIsInteger, false);
      expect(MedicationForm.spray.getQuantitySubtract, 0.1);
    });

    test('ointment has correct labels and properties', () {
      expect(MedicationForm.ointment.getLabel, 'Tepalas');
      expect(MedicationForm.ointment.getDoseLabel, 'Tepimo kartai:');
      expect(MedicationForm.ointment.getUnit, 'g');
      expect(MedicationForm.ointment.consumedAmoutIsInteger, false);
      expect(MedicationForm.ointment.getQuantitySubtract, 0.5);
    });

    test('other has correct labels and properties', () {
      expect(MedicationForm.other.getLabel, 'Kita');
      expect(MedicationForm.other.getDoseLabel, 'Naudojimo skaičius:');
      expect(MedicationForm.other.getUnit, '');
      expect(MedicationForm.other.consumedAmoutIsInteger, false);
      expect(MedicationForm.other.getQuantitySubtract, 1.0);
    });
  });
}
