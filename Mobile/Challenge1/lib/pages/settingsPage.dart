import 'dart:convert';
import 'dart:io';

import 'package:challenge1/services/optionState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:challenge1/partials/app_bar.dart';
import 'package:challenge1/services/file_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  // Stub: Replace these with your file manager service calls
  Future<void> _exportPresets() async {
    if (Provider
        .of<OptionsState>(context, listen: false)
        .hasBeenLoaded) {
      bool exported = await Provider
          .of<OptionsState>(context, listen: false)
          .pres
          .exportPresets();

      if (exported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Presets exportados com sucesso!')),
        );
        return;
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Falha ao exportar os presets.')),
    );
  }


  Future<void> _importPresets() async {
    bool imported = await Provider
        .of<OptionsState>(context, listen: false)
        .pres
        .importPresets();

    if (imported) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presets importados com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao importar os presets.')),
      );
    }
  }

  Future<void> _clearPresets() async {
    try {
      if (!Provider
          .of<OptionsState>(context, listen: false)
          .hasBeenLoaded) {
        throw('tenta novamente');
      }
      Provider
          .of<OptionsState>(context, listen: false)
          .pres
          .deleteDirFile();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presets limpos com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao limpar os presets: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the custom AppBar with the same background color.
      appBar: buildAppBar(context),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Presets"),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.upload_file),
                title: const Text("Partilhar presets"),
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
              SettingsTile.navigation(
                leading: const Icon(Icons.brightness_6),
                title: const Text("Tema"),
                value: Text(_getThemeModeName(context)),
                onPressed: (BuildContext context) => _showThemeModeDialog(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getThemeModeName(BuildContext context) {
    final themeMode = Provider.of<OptionsState>(context).themeMode;
    switch (themeMode) {
      case ThemeMode.system:
        return 'Sistema';
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
    }
  }

  void _showThemeModeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione o tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Sistema'),
                onTap: () => _setThemeMode(context, ThemeMode.system),
              ),
              ListTile(
                title: const Text('Claro'),
                onTap: () => _setThemeMode(context, ThemeMode.light),
              ),
              ListTile(
                title: const Text('Escuro'),
                onTap: () => _setThemeMode(context, ThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }
  void _setThemeMode(BuildContext context, ThemeMode mode) {
    Provider.of<OptionsState>(context, listen: false).setThemeMode(mode);
    Navigator.of(context).pop();
  }

}


