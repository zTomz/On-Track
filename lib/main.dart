import 'package:flutter/material.dart';
import 'package:planer/constants/colors.dart';
import 'package:planer/models/goal/goal.dart';
import 'package:planer/pages/home_page.dart';
import 'package:planer/provider/goal_provider.dart';
import 'package:planer/provider/settings_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoalProvider(
            goals: [
              Goal.create(
                "Test 1",
                "",
                GoalValueType.number,
                [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                ],
              ),
              Goal.create(
                "Test 2",
                "",
                GoalValueType.bool,
                [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                ],
              ),
              Goal.create(
                "Test 3",
                "",
                GoalValueType.text,
                [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                ],
              ),
            ],
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return MaterialApp(
      title: 'Planer',
      theme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: settingsProvider.themeMode,
      home: const HomePage(),
    );
  }
}
