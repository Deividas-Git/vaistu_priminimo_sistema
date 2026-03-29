class MedicationProgress {
  final DateTime startDate;
  final DateTime endDate;
  final int timesTaken;
  final int timesDelayed;
  final int timesSkipped;
  final int timesMissed;
  final double adherenceRate;
  final int deviation;

  MedicationProgress({
    required this.startDate,
    required this.endDate,
    required this.timesTaken,
    required this.timesDelayed,
    required this.timesSkipped,
    required this.timesMissed,
    required this.adherenceRate,
    required this.deviation,
  });

  @override
  String toString() {
    return "Taken: $timesTaken; delayed: $timesDelayed; skipped: $timesSkipped; missed: $timesMissed; adherence $adherenceRate";
  }
}
