import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ontrack/constants/app.dart';
import 'package:ontrack/extensions/navigator_extension.dart';
import 'package:ontrack/models/storage/boxes.dart';
import 'package:ontrack/pages/edit_goals_page.dart';
import 'package:ontrack/pages/settings/widgets/settings_section.dart';
import 'package:ontrack/pages/widgets/nav_bar.dart';
import 'package:ontrack/provider/goal_provider.dart';
import 'package:ontrack/provider/settings_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr("settings")),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const NavBar(currentPage: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            SettingsSection(
              title: tr("goals"),
              children: [
                ListTile(
                  title: Text(tr("edit_goals")),
                  leading: const Icon(Icons.subdirectory_arrow_right_rounded),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    context.push(const EditGoalsPage());
                  },
                ),
              ],
            ),
            SettingsSection(
              title: tr("look"),
              children: [
                ListTile(
                  title: Text(tr("presentation")),
                  leading: Icon(
                    settingsProvider.themeMode == ThemeMode.light
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(tr("presentation")),
                          content: Text(tr("change_presentation")),
                          actions: [
                            ThemeMode.light,
                            ThemeMode.dark,
                            ThemeMode.system,
                          ].map(
                            (currentTheme) {
                              String text = "";

                              switch (currentTheme) {
                                case ThemeMode.light:
                                  text = tr("light");
                                  break;
                                case ThemeMode.dark:
                                  text = tr("dark");
                                  break;
                                case ThemeMode.system:
                                  text = tr("system");
                                  break;
                              }

                              return RadioListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(
                                      currentTheme == ThemeMode.light ? 15 : 5,
                                    ),
                                    bottom: Radius.circular(
                                      currentTheme == ThemeMode.system ? 15 : 5,
                                    ),
                                  ),
                                ),
                                value: currentTheme,
                                groupValue: settingsProvider.themeMode,
                                onChanged: (newThemeMode) async {
                                  await settingsProvider.setThemeMode(
                                    newThemeMode ?? ThemeMode.system,
                                  );

                                  if (context.mounted) {
                                    context.pop();
                                  }
                                },
                                title: Text(text),
                              );
                            },
                          ).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: "Language",
              children: [
                ListTile(
                  title: Text(tr("change_language")),
                  leading: const Icon(Icons.language_rounded),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(tr("change_language")),
                          actions: [
                            RadioListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                  bottom: Radius.circular(5),
                                ),
                              ),
                              value: const Locale("de"),
                              groupValue: context.locale,
                              onChanged: (_) async {
                                await context.setLocale(const Locale("de"));

                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                              title: Text(tr("german")),
                            ),
                            RadioListTile(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(5),
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              value: const Locale("en"),
                              groupValue: context.locale,
                              onChanged: (_) async {
                                await context.setLocale(const Locale("en"));

                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                              title: Text(tr("english")),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: tr("memory"),
              children: [
                ListTile(
                  title: Text(tr("delete_all_data")),
                  leading: const Icon(Icons.delete_forever_rounded),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(tr("are_you_sure")),
                          content: Text(
                            tr("sure_to_delete_all_data"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: Text(tr("cancel")),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Boxes.allGoalsBox.clear();
                                await Boxes.daysBox.clear();

                                if (context.mounted) {
                                  context.read<GoalProvider>().reset();

                                  context.showSnackBar(tr("all_data_deleted"));
                                  context.pop();
                                }
                              },
                              child: Text(tr("delete_all_data")),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              title: "Über",
              children: [
                AboutListTile(
                  icon: const Icon(Icons.info_outline_rounded),
                  applicationVersion: App.appVersion,
                  applicationName: App.appName,
                  applicationIcon: ClipOval(
                    child: Image.asset(
                      App.appIcon,
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
