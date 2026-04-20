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

  test('addMedication calls service', () async {
    final med = UserMedication();

    when(() => service.addMedication(med, 'uid1')).thenAnswer((_) async {});

    await provider.addMedication(med, 'uid1');

    verify(() => service.addMedication(med, 'uid1')).called(1);
  });

  test('removeMedication calls service', () async {
    when(
      () => service.removeMedication('med1', 'uid1'),
    ).thenAnswer((_) async {});

    await provider.removeMedication('med1', 'uid1');

    verify(() => service.removeMedication('med1', 'uid1')).called(1);
  });
}
