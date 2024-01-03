import 'package:flutter/material.dart';
import 'package:planer/extensions/navigator_extension.dart';
import 'package:planer/pages/data_page.dart';
import 'package:planer/pages/home_page.dart';
import 'package:planer/pages/settings_page.dart';

class NavBar extends StatelessWidget {
  final int currentPage;

  const NavBar({
    super.key,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentPage,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.bar_chart_rounded),
          label: "Daten",
        ),
        NavigationDestination(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_rounded),
          label: "Einstellungen",
        ),
      ],
      onDestinationSelected: (value) {
        if (value == currentPage) return;

        switch (value) {
          case 0:
            context.push(
              const DataPage(),
              withAnimation: false,
            );
            break;
          case 1:
            context.push(
              const HomePage(),
              withAnimation: false,
            );
            break;
          case 2:
            context.push(
              const SettingsPage(),
              withAnimation: false,
            );
            break;
        }
      },
    );
  }
}
