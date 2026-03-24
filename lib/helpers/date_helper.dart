class DateHelper {
  static String getFormattedDateTime(DateTime date) {
    String label = date.year.toString().padLeft(4, '0');
    label = "$label-${date.month.toString().padLeft(2, '0')}";
    label = "$label-${date.day.toString().padLeft(2, '0')}";
    label = "$label ${date.hour.toString().padLeft(2, '0')}";
    label = "$label:${date.minute.toString().padLeft(2, '0')}";
    return label;
  }
}
