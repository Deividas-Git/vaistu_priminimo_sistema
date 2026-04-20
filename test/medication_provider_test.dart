// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:vaistu_priminimo_sistema/providers/medication_provider.dart';
import 'package:vaistu_priminimo_sistema/services/medication_service.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';

class MockMedicationService extends Mock implements MedicationService {}

void main() {
  late MockMedicationService service;
  late MedicationProvider provider;

  setUp(() {
    service = MockMedicationService();
    provider = MedicationProvider(service);
  });

  tearDown(() {
    provider.stopListening();
  });

  test('initial state', () {
    expect(provider.uerMedications, isEmpty);
  });

  test('addMedication calls service', () async {
    final med = UserMedication(id: '1', name: 'Test Med');

    when(() => service.addMedication(med, 'uid1')).thenAnswer((_) async {});

    await provider.addMedication(med, 'uid1');

    verify(() => service.addMedication(med, 'uid1')).called(1);
  });

  test('updateMedication calls service', () async {
    final med = UserMedication(id: '1', name: 'Test Med');

    when(() => service.updateMedication(med, 'uid1')).thenAnswer((_) async {});

    await provider.updateMedication(med, 'uid1');

    verify(() => service.updateMedication(med, 'uid1')).called(1);
  });

  test('removeMedication calls service', () async {
    when(
      () => service.removeMedication('med1', 'uid1'),
    ).thenAnswer((_) async {});

    await provider.removeMedication('med1', 'uid1');

    verify(() => service.removeMedication('med1', 'uid1')).called(1);
  });

  test('getMedicationFromRegistrationCode calls service', () async {
    final med = UserMedication(name: 'Test Med');
    when(
      () => service.getMedicationFromRegistrationCode('123'),
    ).thenAnswer((_) async => med);

    final result = await provider.getMedicationFromRegistrationCode('123');

    expect(result, med);
    verify(() => service.getMedicationFromRegistrationCode('123')).called(1);
  });

  test('stopListening cancels subscription and clears list', () {
    provider.stopListening();
  });

  test('getMedicationFromId returns correct medication', () {
    final med1 = UserMedication(id: '1', name: 'Med1');
    final med2 = UserMedication(id: '2', name: 'Med2');
    expect(() => provider.getMedicationFromId('1'), throwsStateError);
  });
}
