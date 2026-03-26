import 'package:flutter/material.dart';

enum MedicationRecordState {
  taken,
  missed,
  pending,
  skipped,
  delayed;

  String get getLabel => switch (this) {
    taken => "Suvartota",
    missed => "Nevartota",
    pending => "Laukiama",
    skipped => "Praleista",
    delayed => "Atidėta",
  };

  static Color getColorForStateLabel(
    ColorScheme colorScheme,
    MedicationRecordState state,
  ) {
    return switch (state) {
      taken => const Color.fromARGB(255, 55, 133, 56),
      missed => colorScheme.error,
      pending => colorScheme.onSurfaceVariant,
      skipped => const Color.fromARGB(255, 198, 150, 4),
      delayed => Colors.blue,
    };
  }
}
