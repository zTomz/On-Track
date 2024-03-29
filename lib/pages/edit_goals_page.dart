import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ontrack/constants/colors.dart';
import 'package:ontrack/extensions/navigator_extension.dart';
import 'package:ontrack/extensions/theme_extension.dart';
import 'package:ontrack/models/goal/goal.dart';
import 'package:ontrack/models/weekday.dart';
import 'package:ontrack/pages/home_page.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class EditGoalsPage extends StatefulHookWidget {
  const EditGoalsPage({Key? key}) : super(key: key);

  @override
  EditGoalsPageState createState() => EditGoalsPageState();
}

class EditGoalsPageState extends State<EditGoalsPage> {
  bool daySelectorOpened = false;
  List<int> selectedWeekdays = [1, 2, 3, 4, 5, 6, 7];
  GoalValueType valueType = GoalValueType.bool;

  List<Goal> goals = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    final weekdayController = usePageController(
      viewportFraction: 0.55,
    );
    final taskTextController = useTextEditingController();
    final descriptionTextController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          goalProvider.allGoals.isEmpty ? tr("create_goal") : tr("edit_goal"),
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: MediaQuery.of(context).viewInsets.bottom > 0
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                if (goalProvider.allGoals.isEmpty) {
                  context.showSnackBar(tr("please_enter_at_least_one_number"));
                  return;
                }

                context.push(const HomePage());
              },
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(tr("save")),
            ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr("please_enter_a_title");
                            }

                            return null;
                          },
                          controller: taskTextController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            labelText: tr("new_goal"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Tooltip(
                      message: tr("show_hide_days"),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            daySelectorOpened = !daySelectorOpened;
                          });
                        },
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(19),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.colorScheme.outline,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            ),
                          ),
                          child: Icon(
                            Icons.schedule_rounded,
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionTextController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(5),
                        bottom: Radius.circular(15),
                      ),
                    ),
                    labelText: tr("description"),
                  ),
                ),
              ],
            ),
          ),
          if (daySelectorOpened)
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 15),
              child: PageView.builder(
                controller: weekdayController,
                scrollDirection: Axis.horizontal,
                itemCount: Weekday.daysPerWeek,
                itemBuilder: (context, index) {
                  final dayIsSelected = selectedWeekdays.contains(index + 1);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedWeekdays.contains(index + 1)) {
                            selectedWeekdays.remove(index + 1);
                          } else {
                            selectedWeekdays.add(index + 1);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius:
                              dayIsSelected ? BorderRadius.circular(15) : null,
                          color: dayIsSelected ? AppColors.primary : null,
                        ),
                        child: Text(
                          Weekday.weekdays[index + 1] ?? "",
                          style: context.textTheme.headlineSmall,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tr("value"),
                    style: context.textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<GoalValueType>(
                          segments: [
                            ButtonSegment(
                              value: GoalValueType.text,
                              label: Text(tr("text")),
                            ),
                            ButtonSegment(
                              value: GoalValueType.number,
                              label: Text(tr("number")),
                            ),
                            ButtonSegment(
                              value: GoalValueType.bool,
                              label: Text(tr("bool")),
                            ),
                          ],
                          selected: {
                            valueType
                          },
                          onSelectionChanged: (value) {
                            setState(() {
                              valueType = value.first;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          await goalProvider.putGoal(
                            Goal.create(
                              taskTextController.text,
                              descriptionTextController.text,
                              valueType,
                              selectedWeekdays,
                            ),
                          );

                          goalProvider.resetExpandedTiles();

                          setState(() {
                            // Reset the selected data
                            selectedWeekdays = [1, 2, 3, 4, 5, 6, 7];
                            daySelectorOpened = false;
                            taskTextController.clear();
                            descriptionTextController.clear();
                          });
                        },
                        icon: const Icon(Icons.add_rounded),
                        label: Text(
                          tr("add_goal"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      tr("goals"),
                      style: context.textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: goalProvider.allGoals.length,
                      itemBuilder: (context, index) {
                        final currentGoal = goalProvider.allGoals[index];

                        return ListTile(
                          title: Text(
                            currentGoal.task,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: currentGoal.description.isNotEmpty
                              ? Text(
                                  currentGoal.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(tr("delete_goal")),
                                    content: Text(
                                      tr("sure_to_delete_goal"),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(tr("cancel")),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await goalProvider.removeGoal(
                                            currentGoal,
                                          );

                                          if (context.mounted) {
                                            context.pop();
                                          }
                                        },
                                        child: Text(tr("delete")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            tooltip: tr("delete"),
                            icon: const Icon(Icons.delete_rounded),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
