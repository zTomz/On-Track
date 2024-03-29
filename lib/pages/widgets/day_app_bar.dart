import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class DayAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DayAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    return AppBar(
      title: Text(
        goalProvider.extractDay(goalProvider.selectedDay),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: goalProvider.dayBeforeDayExists(goalProvider.selectedDay)
            ? () {
                goalProvider.dayBack();
                goalProvider.resetExpandedTiles();
              }
            : null,
        color: goalProvider.dayAfterDayExists(goalProvider.selectedDay)
            ? null
            : Colors.grey,
        tooltip: tr("previous_day"),
        icon: const Icon(Icons.arrow_back_ios_rounded),
      ),
      actions: [
        IconButton(
          onPressed: goalProvider.dayExists(
                  goalProvider.selectedDay.add(const Duration(days: 1)))
              ? () {
                  goalProvider.dayForward();
                  goalProvider.resetExpandedTiles();
                }
              : null,
          tooltip: tr("next_day"),
          color: goalProvider.dayExists(
                  goalProvider.selectedDay.add(const Duration(days: 1)))
              ? null
              : Colors.grey,
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ],
    );
  }
}
