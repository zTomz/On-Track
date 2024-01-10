import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ontrack/constants/colors.dart';
import 'package:ontrack/models/goal/goal.dart';
import 'package:ontrack/pages/edit_goals_page.dart';
import 'package:ontrack/pages/home_page.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:ontrack/provider/settings_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(GoalAdapter(), override: true);
  Hive.registerAdapter(GoalValueTypeAdapter(), override: true);

  await Hive.openBox<List>("daysBox");
  await Hive.openBox<Goal>("allGoalsBox");
  await Hive.openBox("settingsBox");

  // Init localization
  await EasyLocalization.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GoalProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('de'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final allGoals = context.read<GoalProvider>().allGoals;

    return MaterialApp(
      title: 'Ontrack',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
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
      home: allGoals.isEmpty ? const EditGoalsPage() : const HomePage(),
    );
  }
}
