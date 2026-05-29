import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaistu_priminimo_sistema/helpers/date_helper.dart';
import 'package:vaistu_priminimo_sistema/models/medication/active_ingredient.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_consumption_time_with_amount.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_form.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_frequency_type.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_meal_timing.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_schedule.dart';
import 'package:vaistu_priminimo_sistema/models/medication/user_medication.dart';
import 'package:vaistu_priminimo_sistema/services/agenda_service.dart';

void main() {
  late DateTime testDate;
  late UserMedication testMedication;
  late MedicationSchedule testSchedule;
  late MedicationConsumptionTimeWithAmount testTimeWithAmount;
  late Map<String, MedicationRecord> testRecordsMap;

  setUp(() {
    testDate = DateTime(2023, 10, 10); // A Tuesday
    testTimeWithAmount = MedicationConsumptionTimeWithAmount(
      id: 'time1',
      time: const TimeOfDay(hour: 8, minute: 0),
      consumptionAmount: 1,
    );
    testSchedule = MedicationSchedule(
      startDate: DateTime(2023, 10, 1),
      medicationFrequencyType: MedicationFrequencyType.constantIntervals,
      intervalsDays: 1,
      consumptionTimesWithAmount: [testTimeWithAmount],
      name: 'Daily Schedule',
    );
    testMedication = UserMedication(
      id: 'med1',
      name: 'Test Med',
      medicationForm: MedicationForm.pills,
      activeIngredient: ActiveIngredient.ibuprofen,
      medicationMealTiming: MedicationMealTiming.beforeMeal,
      medicationSchedules: [testSchedule],
    );
    testRecordsMap = {};
  });

  group('AgendaService Constructor', () {
    test('initializes agendaDate correctly', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      expect(service.agendaDate, DateHelper.normalizedDate(testDate));
    });

    test('generates agenda correctly for daily schedule', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      expect(service.agenda.length, 1);
      expect(service.agenda[0].medicationId, 'med1');
      expect(service.agenda[0].scheduledDate, DateTime(2023, 10, 10, 8, 0));
      expect(service.agenda[0].state, MedicationRecordState.missed);
    });

    test('handles past dates with missed state', () {
      final pastDate = DateTime(2023, 10, 9, 10, 0); // Past time
      final service = AgendaService(
        date: pastDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      expect(service.agenda[0].state, MedicationRecordState.missed);
    });
  });

  group('getMedicationFromId', () {
    test('returns correct medication', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final med = service.getMedicationFromId('med1');

      expect(med.id, 'med1');
    });

    test('throws when medication not found', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      expect(
        () => service.getMedicationFromId('nonexistent'),
        throwsStateError,
      );
    });
  });

  group('getUpcomingIntakeForMedication', () {
    test('returns next intake time', () {
      final now = DateTime(2023, 10, 10, 7, 0); // Before 8:00
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final nextIntake = service.getUpcomingIntakeForMedication(
        testMedication,
        now,
      );

      expect(nextIntake, DateTime(2023, 10, 10, 8, 0));
    });

    test('returns null if no schedules', () {
      final medWithoutSchedule = UserMedication(
        id: 'med2',
        name: 'No Schedule Med',
        medicationForm: MedicationForm.pills,
        activeIngredient: ActiveIngredient.statin,
        medicationMealTiming: MedicationMealTiming.beforeMeal,
      );
      final service = AgendaService(
        date: testDate,
        medications: [medWithoutSchedule],
        recordsMap: testRecordsMap,
      );

      final nextIntake = service.getUpcomingIntakeForMedication(
        medWithoutSchedule,
        DateTime.now(),
      );

      expect(nextIntake, isNull);
    });
  });

  group('getNextIntakeAfterDate', () {
    test('returns next intake after given item', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final item = service.agenda[0];
      final nextIntake = service.getNextIntakeAfterDate(item);

      expect(nextIntake, DateTime(2023, 10, 11, 8, 0)); // Next day
    });
  });

  group('getGroupedAgendaForUI', () {
    test('groups agenda items by time', () {
      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final groups = service.getGroupedAgendaForUI();

      expect(groups.length, 1);
      expect(groups[0].time, const TimeOfDay(hour: 8, minute: 0));
      expect(groups[0].items.length, 1);
    });
  });

  group('getGroupedAgendaForNotifications', () {
    test('groups only pending and delayed items', () {
      final record = MedicationRecord(
        id: 'record1',
        medicationId: 'med1',
        scheduledDate: DateTime(2023, 10, 10, 8, 0),
        takenDate: DateTime(2023, 10, 10, 8, 5),
        delayedUntil: null,
        state: MedicationRecordState.taken,
      );
      testRecordsMap[record.id] = record;

      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final groups = service.getGroupedAgendaForNotifications();

      expect(groups.length, 0); // Since the item is taken, not included
    });

    test('includes delayed items', () {
      final String id = MedicationRecord.buildId(
        medicationId: testMedication.id!,
        timeId: testMedication
            .medicationSchedules!
            .first
            .consumptionTimesWithAmount!
            .first
            .id,
        date: testDate,
      );
      final delayedRecord = MedicationRecord(
        id: id,
        medicationId: 'med1',
        scheduledDate: DateTime(2023, 10, 10, 8, 0),
        takenDate: null,
        delayedUntil: DateTime(2023, 10, 10, 9, 0),
        state: MedicationRecordState.delayed,
      );
      testRecordsMap[delayedRecord.id] = delayedRecord;

      final service = AgendaService(
        date: testDate,
        medications: [testMedication],
        recordsMap: testRecordsMap,
      );

      final groups = service.getGroupedAgendaForNotifications();

      expect(groups.length, 1);
      expect(
        groups[0].items[0].delayedUntil,
        testDate.add(Duration(hours: 9)),
      ); // Delayed time
    });
  });
}
