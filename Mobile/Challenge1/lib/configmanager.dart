/* import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:path_provider/path_provider.dart';
import 'package:decimal/decimal.dart';

class ConfigManager {
  Map<String, dynamic> _neededValues = {};
  Map<String, dynamic> _presets = {};


  /// Loads presets from the presets.json file
  Future<void> loadPresets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/presets.json';
      final file = File(filePath);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        _presets = jsonDecode(jsonString);
        print('Presets loaded successfully.');
      } else {
        print('Presets file does not exist. Initializing default presets.');
        _presets = {"PRESETS": {}};
        await savePresets(); // Save the empty presets file
      }
    } catch (e) {
      print('Error loading presets.json: $e');
    }
  }

  /// Saves the current presets to the presets.json file
  Future<void> savePresets() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/presets.json';
      final jsonString = jsonEncode(_presets);
      final file = File(filePath);

      await file.writeAsString(jsonString);
      print('Presets saved successfully.');
    } catch (e) {
      print('Error saving presets.json: $e');
    }
  }

  /// Checks if a preset with the given name already exists
  bool doesPresetAlreadyExist(String name) {
    if (_presets["PRESETS"] != null) {
      return _presets["PRESETS"].containsKey(name);
    }
    return false;
  }

  /// Loads a preset into controllers or UI state
  Map<String, String> loadPreset(String name) {
    if (_presets["PRESETS"] != null && _presets["PRESETS"].containsKey(name)) {
      return Map<String, String>.from(_presets["PRESETS"][name]["Values"]);
    } else {
      throw Exception('Preset "$name" does not exist.');
    }
  }

  /// Creates a new preset and saves it
  Future<void> createNewPreset(
      String name,
      Map<String, Decimal> valuesMapped,
      Map<String, String> encodedOptions,
      ) async {
    if (_presets["PRESETS"] == null) {
      _presets["PRESETS"] = {};
    }

    if (!_presets["PRESETS"].containsKey(name)) {
      _presets["PRESETS"][name] = {
        "Options": encodedOptions,
        "Values": valuesMapped.map((key, value) => MapEntry(key, value.toString())),
      };
      await savePresets();
      print('Preset "$name" created successfully.');
    } else {
      print('Preset "$name" already exists.');
    }
  }

  /// Decodes needed values based on the loaded JSON and type
  List<TextEditingController> decodeJson(String type, List<Pair<String, String>> encodedOptions) {
    List<TextEditingController> controllers = [];
    try {
      if (_neededValues != null && _neededValues.isNotEmpty) {
        for (Pair<String, String> pair in encodedOptions) {
          String key = pair.key;
          String value = pair.value;

          if (_neededValues["NEEDEDVALUES"][type]["RADIAL"].containsKey(key)) {
            for (String str in _neededValues["NEEDEDVALUES"][type]["RADIAL"][key][value]) {
              controllers.add(TextEditingController());
            }
          }
        }
        print('Decoded needed values for type "$type".');
      }
    } catch (e) {
      print('Error decoding needed values: $e');
    }
    return controllers;
  }

  /// Prepares data for sending by mapping values from controllers
  Map<String, Decimal> prepareSend(
      List<TextEditingController> controllers,
      List<String> neededValuesName,
      ) {
    Map<String, Decimal> valuesMapped = {};
    for (int i = 0; i < controllers.length; i++) {
      valuesMapped[neededValuesName[i]] = Decimal.parse(controllers[i].text);
    }
    return valuesMapped;
  }

  /// Getter for `_neededValues`
  Map<String, dynamic> get neededValues => _neededValues;

  /// Getter for `_presets`
  Map<String, dynamic> get presets => _presets;
}
*/