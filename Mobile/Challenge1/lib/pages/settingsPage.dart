import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:challenge1/partials/app_bar.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkModeEnabled = false;

  // Stub: Replace these with your file manager service calls
  Future<void> _exportPresets() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A Exportar os presets...')),
    );
  }

  Future<void> _importPresets() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A Importar os presets.json...')),
    );
  }

  Future<void> _clearPresets() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A Limpar os presets...')),
    );
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      darkModeEnabled = value;
    });
    // Optionally, notify your theme management service here.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the custom AppBar with the same background color.
      appBar: buildAppBar(context),
      backgroundColor: const Color(0xFFFFF0C2),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Presets"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.upload_file),
                title: const Text("Exportar presets.json"),
                onPressed: (context) => _exportPresets(),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.download),
                title: const Text("Importar presets.json"),
                onPressed: (context) => _importPresets(),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.delete),
                title: const Text("Limpar presets.json"),
                onPressed: (context) => _clearPresets(),
              ),
            ],
          ),
          SettingsSection(
            title: const Text("Aparência"),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                initialValue: darkModeEnabled,
                onToggle: _toggleDarkMode,
                leading: const Icon(Icons.dark_mode),
                title: const Text("Modo Escuro"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
