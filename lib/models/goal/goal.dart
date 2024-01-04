import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'goal.g.dart';

@HiveType(typeId: 0)
class Goal {
  /// The task field stores the name of the goal.
  @HiveField(0)
  final String task;

  /// The description field stores a longer description of the goal.
  @HiveField(1)
  final String description;

  /// The value field stores a numeric value associated with the goal.
  @HiveField(2)
  final Object? value;

  /// The valueType field indicates whether the value is a duration, count, etc.
  @HiveField(3)
  final GoalValueType valueType;

  /// The weekdays field stores which days of the week the goal applies to.
  @HiveField(4)
  final List<int> weekdays;

  /// The from field stores when the goal was created.
  @HiveField(5)
  final DateTime from;

  /// The uuid field stores a unique ID for the goal.
  @HiveField(6)
  final String uuid;

  Goal({
    required this.task,
    required this.description,
    required this.value,
    required this.valueType,
    required this.weekdays,
    required this.from,
    required this.uuid,
  });

  Goal.create(String task, String description, GoalValueType valueType,
      List<int> weekdays)
      : this(
          task: task,
          description: description,
          value: null,
          valueType: valueType,
          weekdays: weekdays,
          from: DateTime.now(),
          uuid: const Uuid().v4(),
        );

  Goal copyWith({
    String? task,
    String? description,
    Object? value,
    GoalValueType? valueType,
    List<int>? weekdays,
    DateTime? from,
    String? uuid,
  }) {
    return Goal(
      task: task ?? this.task,
      description: description ?? this.description,
      value: value ?? this.value,
      valueType: valueType ?? this.valueType,
      weekdays: weekdays ?? this.weekdays,
      from: from ?? this.from,
      uuid: uuid ?? this.uuid,
    );
  }

  @override
  String toString() {
    return 'Goal(task: $task, description: $description, value: $value, valueType: $valueType, weekdays: $weekdays, from: $from, uuid: $uuid)';
  }
}

@HiveType(typeId: 1)
enum GoalValueType {
  @HiveField(0)
  text,
  @HiveField(1)
  number,
  @HiveField(2)
  bool,
}
