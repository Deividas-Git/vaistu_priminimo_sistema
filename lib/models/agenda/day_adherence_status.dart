import 'package:flutter/material.dart';
import 'package:vaistu_priminimo_sistema/models/agenda/agenda_item.dart';
import 'package:vaistu_priminimo_sistema/models/medication/medication_record_state.dart';

enum DayAdherenceStatus {
  completed,
  unfinished,
  missed,
  empty;

  static DayAdherenceStatus getStatus({required List<AgendaItem> items}) {
    if (items.isEmpty ||
        (items
                .where((item) => item.state == MedicationRecordState.pending)
                .length ==
            items.length)) {
      return empty;
    }
    if (items
            .where(
              (item) =>
                  item.state == MedicationRecordState.missed ||
                  item.state == MedicationRecordState.skipped,
            )
            .length ==
        items.length) {
      return missed;
    }
    if (items
            .where((item) => item.state == MedicationRecordState.taken)
            .length ==
        items.length) {
      return completed;
    }
    return unfinished;
  }

  Color get getColorForStateLabel {
    return switch (this) {
      completed => const Color.fromARGB(255, 55, 133, 56),
      missed => const Color.fromARGB(255, 180, 10, 10),
      unfinished => const Color.fromARGB(255, 198, 150, 4),
      empty => Colors.transparent,
    };
  }
}
