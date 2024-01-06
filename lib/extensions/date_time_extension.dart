extension DateTimeExtension on DateTime {
  bool get nextMonthIsAvailable =>
      DateTime.now().month <= month && DateTime.now().year <= year;
}
