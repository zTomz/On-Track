import 'package:flutter/material.dart';
import 'package:planer/extensions/navigator_extension.dart';
import 'package:planer/pages/edit_goals_page.dart';
import 'package:planer/pages/settings/widgets/settings_section.dart';
import 'package:planer/pages/widgets/nav_bar.dart';
import 'package:planer/provider/settings_provider.dart';
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
        title: const Text("Einstellungen"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const NavBar(currentPage: 2),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            SettingsSection(
              title: "Ziele",
              children: [
                ListTile(
                  title: const Text("Ziele ändern"),
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
              title: "Aussehen",
              children: [
                ListTile(
                  title: const Text("Darstellung"),
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
                          title: const Text("Darstellung"),
                          content:
                              const Text("Darstellung der Anwendung ändern."),
                          actions: [
                            ThemeMode.light,
                            ThemeMode.dark,
                            ThemeMode.system,
                          ].map(
                            (e) {
                              String text = "";

                              switch (e) {
                                case ThemeMode.light:
                                  text = "Hell";
                                  break;
                                case ThemeMode.dark:
                                  text = "Dunkel";
                                  break;
                                case ThemeMode.system:
                                  text = "System";
                                  break;
                              }

                              return Row(
                                children: [
                                  Radio(
                                    value: e,
                                    groupValue: settingsProvider.themeMode,
                                    onChanged: (newThemeMode) {
                                      settingsProvider.setThemeMode(
                                        newThemeMode ?? ThemeMode.system,
                                      );
                                    },
                                  ),
                                  Text(text),
                                ],
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
          ],
        ),
      ),
    );
  }
}
