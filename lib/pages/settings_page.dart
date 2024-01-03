import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:planer/extensions/navigator_extension.dart';
import 'package:planer/pages/edit_goals_page.dart';
import 'package:planer/pages/widgets/nav_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(currentPage: 2),
      body: SafeArea(
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text("Ziele"),
              tiles: [
                SettingsTile(
                  title: const Text("Ziele ändern"),
                  leading: const Icon(Icons.subdirectory_arrow_right_rounded),
                  onPressed: (context) {
                    context.push(
                      const EditGoalsPage(),
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
