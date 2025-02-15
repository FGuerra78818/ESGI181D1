import 'package:flutter/material.dart';
import 'package:challenge1/pages/settingsPage.dart';

import 'package:challenge1/pages/previewpage.dart';

AppBar buildAppBar(BuildContext context) {
  // Determine if the current page is the Settings page.
  // Adjust the '/settings' string to match your routing.
  bool isSettingsPage = ModalRoute.of(context)?.settings.name == '/settings';

  return AppBar(
    title: const Text(
      'Cubicagem',
      style: TextStyle(
        fontWeight: FontWeight.w800,
      ),
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.primary,
    actions: isSettingsPage
        ? null // Hide actions if on the settings page
        : [
        IconButton(
          icon: const Icon(Icons.show_chart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PreviewPage()),
            );
          },
        ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            // Option 1: Use a named route if you have defined one.
            // builder: (context) => const SettingsPage(),
            // Option 2: Provide a route name to SettingsPage
            settings: const RouteSettings(name: '/settings'),
            builder: (context) => const SettingsPage(),
          ));
        },
      ),

    ],
  );
}

