enum MedicationRecordState {
  taken,
  missed,
  pending;

  String get getLabel => switch (this) {
    taken => "Suvartota",
    missed => "Praleista",
    pending => "Laukiama",
  };
}
