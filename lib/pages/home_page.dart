import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/extensions/navigator_extension.dart';
import 'package:ontrack/extensions/theme_extension.dart';
import 'package:ontrack/models/goal/goal.dart';
import 'package:ontrack/pages/edit_goals_page.dart';
import 'package:ontrack/pages/widgets/day_app_bar.dart';
import 'package:ontrack/pages/widgets/nav_bar.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    return Scaffold(
      appBar: const DayAppBar(),
      bottomNavigationBar: const NavBar(currentPage: 1),
      floatingActionButton: goalProvider.goalsOfDay.isEmpty
          ? FloatingActionButton.large(
              onPressed: () {
                context.push(const EditGoalsPage());
              },
              tooltip: tr("create_a_goal"),
              child: const Icon(Icons.add_rounded),
            )
          : FloatingActionButton(
              onPressed: () {
                context.push(const EditGoalsPage());
              },
              tooltip: tr("create_a_goal"),
              child: const Icon(Icons.add_rounded),
            ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: goalProvider.goalsOfDay.length,
              itemBuilder: (context, index) {
                final currentGoal = goalProvider.goalsOfDay[index];
                final isTileExpanded = goalProvider.expandedIndexes.contains(
                  index,
                );

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
                                      goalProvider.toggleExpansion(index);
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
                                  tr("value_has_to_be_a_number"),
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
                                  tr("value_saved"),
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
                                  ? "${tr("value")}: ${currentGoal.value.toString()}"
                                  : "${tr("value")} - ${currentGoal.valueType == GoalValueType.number ? "Zahl" : "Text"}",
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
