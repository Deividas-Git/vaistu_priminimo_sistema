enum MedicationRecordState {
  taken,
  missed,
  pending,
  skipped;

  String get getLabel => switch (this) {
    taken => "Suvartota",
    missed => "Praleista",
    pending => "Laukiama",
    skipped => "Nevartota",
  };
}
