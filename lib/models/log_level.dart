enum LogLevel {
  info,
  warning,
  error,
  debug,
  critical;

  String get getLabel => name.toUpperCase();
}
