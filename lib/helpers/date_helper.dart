class DateHelper {
  static String getFormattedDateTime(DateTime date) {
    String label = getFormattedDate(date);
    label = "$label ${getFormattedTime(date)}";
    return label;
  }

  static String getFormattedTime(DateTime date) {
    String label = date.hour.toString().padLeft(2, '0');
    label = "$label:${date.minute.toString().padLeft(2, '0')}";
    return label;
  }

  static String getFormattedDate(DateTime date) {
    String label = date.year.toString().padLeft(4, '0');
    label = "$label-${date.month.toString().padLeft(2, '0')}";
    label = "$label-${date.day.toString().padLeft(2, '0')}";
    return label;
  }

  static DateTime? normalizedDate(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }

  // static DateTime shiftDay(DateTime date, int offset) {
  //   return DateTime(date.year, date.month, date.day + offset);
  // }

  static String getConsumptioDeviationTime(int minutes) {
    final duration = Duration(minutes: minutes);
    String label = "";
    if (duration.inHours > 0) {
      label = " ${duration.inHours} val.";
    }
    label = "$label ${minutes % 60} min.";
    return label;
  }
}
