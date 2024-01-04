import 'package:flutter/material.dart';
import 'package:planer/extensions/navigator_extension.dart';
import 'package:planer/extensions/theme_extension.dart';
import 'package:planer/models/goal/goal.dart';
import 'package:planer/pages/widgets/nav_bar.dart';
import 'package:planer/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> expandedIndexes = [];

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(goalProvider.extractDay(goalProvider.selectedDay)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            DateTime newDay;

            if (goalProvider.selectedDay.day - 1 < 1) {
              if (goalProvider.selectedDay.month == 1) {
                newDay = DateTime(
                  goalProvider.selectedDay.year - 1,
                  goalProvider.selectedDay.month,
                  goalProvider.selectedDay.day,
                );
              } else {
                newDay = DateTime(
                  goalProvider.selectedDay.year,
                  goalProvider.selectedDay.month - 1,
                  goalProvider.selectedDay.day,
                );
              }
            } else {
              newDay = DateTime(
                goalProvider.selectedDay.year,
                goalProvider.selectedDay.month,
                goalProvider.selectedDay.day - 1,
              );
            }

            if (goalProvider.dayExists(newDay)) {
              goalProvider.selectedDay = newDay;
            }
          },
          tooltip: "Vorheriger Tag",
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              DateTime newDay;

              if (goalProvider.selectedDay.day + 1 > 31) {
                if (goalProvider.selectedDay.month == 12) {
                  newDay = DateTime(
                    goalProvider.selectedDay.year + 1,
                    goalProvider.selectedDay.month,
                    goalProvider.selectedDay.day,
                  );
                } else {
                  newDay = DateTime(
                    goalProvider.selectedDay.year,
                    goalProvider.selectedDay.month + 1,
                    goalProvider.selectedDay.day,
                  );
                }
              } else {
                newDay = DateTime(
                  goalProvider.selectedDay.year,
                  goalProvider.selectedDay.month,
                  goalProvider.selectedDay.day + 1,
                );
              }

              if (goalProvider.dayExists(newDay)) {
                goalProvider.selectedDay = newDay;
              }
            },
            tooltip: "Nächster Tag",
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentPage: 1),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: goalProvider.goalsOfDay.length,
              itemBuilder: (context, index) {
                final currentGoal = goalProvider.goalsOfDay[index];
                final isTileExpanded = expandedIndexes.contains(index);

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: index == 0
                          ? const Radius.circular(20)
                          : const Radius.circular(12),
                      bottom: index == goalProvider.goalsOfDay.length - 1
                          ? const Radius.circular(20)
                          : const Radius.circular(12),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentGoal.task,
                                    style: context.textTheme.bodyLarge,
                                  ),
                                  if (currentGoal.description.isNotEmpty)
                                    Text(
                                      currentGoal.description,
                                      style: context.textTheme.bodySmall,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                            currentGoal.valueType != GoalValueType.bool
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isTileExpanded) {
                                          expandedIndexes.remove(index);
                                        } else {
                                          expandedIndexes.add(index);
                                        }
                                      });
                                    },
                                    icon: AnimatedRotation(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      turns: isTileExpanded ? 0.5 : 1,
                                      child: const Icon(
                                        Icons.expand_circle_down_rounded,
                                      ),
                                    ),
                                  )
                                : Checkbox(
                                    value: currentGoal.value as bool? ?? false,
                                    onChanged: (value) async {
                                      await goalProvider.updateGoal(
                                        goalProvider.selectedDay,
                                        currentGoal.copyWith(
                                          value: value ?? false,
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                        if (isTileExpanded) ...[
                          const SizedBox(height: 15),
                          TextField(
                            onSubmitted: (value) async {
                              if (double.tryParse(value) == null &&
                                  currentGoal.valueType ==
                                      GoalValueType.number) {
                                context.showSnackBar(
                                  "Der Wert muss eine Zahl sein",
                                );

                                return;
                              }

                              if (currentGoal.valueType ==
                                  GoalValueType.number) {
                                await goalProvider.updateGoal(
                                  goalProvider.selectedDay,
                                  currentGoal.copyWith(
                                    value: double.parse(value),
                                  ),
                                );
                              } else {
                                await goalProvider.updateGoal(
                                  goalProvider.selectedDay,
                                  currentGoal.copyWith(
                                    value: value,
                                  ),
                                );
                              }

                              if (context.mounted) {
                                context.showSnackBar(
                                  "Wert gespeichert",
                                );
                              }
                            },
                            keyboardType:
                                currentGoal.valueType == GoalValueType.number
                                    ? TextInputType.number
                                    : TextInputType.text,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: currentGoal.value != null &&
                                      currentGoal.value.toString().isNotEmpty
                                  ? "Wert: ${currentGoal.value.toString()}"
                                  : "Wert - ${currentGoal.valueType == GoalValueType.number ? "Zahl" : "Text"}",
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
