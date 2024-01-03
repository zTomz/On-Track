import 'package:planer/models/goal/goal.dart';

class Day {
  /// A day of the week.
  final DateTime day;

  /// The goals of this day.
  final List<Goal> goals;

  Day({
    required this.day,
    required this.goals,
  });
}
