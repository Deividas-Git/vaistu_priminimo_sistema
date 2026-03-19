enum MedicationRecordState {
  taken,
  missed,
  pending,
  skipped;

  String get getLabel => switch (this) {
    taken => "Suvartota",
    missed => "Nevartota",
    pending => "Laukiama",
    skipped => "Praleista",
  };
}
