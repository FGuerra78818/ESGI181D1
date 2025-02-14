import 'package:flutter/material.dart';
import 'package:challenge1/pages/settingsPage.dart';

AppBar buildAppBar(BuildContext context) {
  // Determine if the current page is the Settings page.
  // Adjust the '/settings' string to match your routing.
  bool isSettingsPage = ModalRoute.of(context)?.settings.name == '/settings';

  return AppBar(
    title: const Text(
      'Cubicagem',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800,
      ),
    ),
    centerTitle: true,
    backgroundColor: const Color(0xFFFFF0C2),
    actions: isSettingsPage
        ? null // Hide actions if on the settings page
        : [
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.black),
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

