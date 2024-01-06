import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/extensions/theme_extension.dart';
import 'package:ontrack/pages/widgets/nav_bar.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:provider/provider.dart';

class DataPage extends StatelessWidget {
  const DataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();

    final lineChartData = goalProvider.getLineChartDataForWeek(
      goalProvider.selectedWeek,
    );
    final boolDataForMonth = goalProvider.getBoolDataForWeek(
      goalProvider.selectedWeek,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${goalProvider.extractDay(goalProvider.selectedWeek)} - ${goalProvider.extractDay(goalProvider.selectedWeek.add(const Duration(days: 6)))}"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            goalProvider.changeSelectedWeek(-1);
          },
          tooltip: "Vorheriger Woche",
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        actions: [
          IconButton(
            onPressed: () {
              goalProvider.changeSelectedWeek(1);
            },
            tooltip: "Nächster Woche",
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentPage: 0),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(top: 80, right: 20, left: 16),
              child: LineChart(
                LineChartData(
                  showingTooltipIndicators: [],
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: buildBottomTiles,
                        interval: 1,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: const Color(0xff37434d)),
                  ),
                  lineBarsData: lineChartData.keys
                      .map(
                        (group) => LineChartBarData(
                          color: Colors.primaries[Random().nextInt(
                            Colors.primaries.length,
                          )],
                          barWidth: 6,
                          isStrokeCapRound: true,
                          isStrokeJoinRound: true,
                          spots: lineChartData[group]!,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: boolDataForMonth.values.length,
              itemBuilder: (context, index) {
                final title = boolDataForMonth.keys.toList().elementAt(index);
                final values = boolDataForMonth.values.elementAt(index);

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // The width of side titles [42] - padding [8]
                          const SizedBox(width: 34),
                          ...values
                              .map(
                                (value) => Expanded(
                                  child: Icon(
                                    value
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.highlight_off_rounded,
                                    color: value ? Colors.green : Colors.red,
                                  ),
                                ),
                              )
                              .toList()
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomTiles(double value, TitleMeta meta) {
    if (meta.max > 16) {
      if (value % 2 != 0) {
        return Text(
          value.toStringAsFixed(0),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return Text(
      value.toStringAsFixed(0),
    );
  }
}
