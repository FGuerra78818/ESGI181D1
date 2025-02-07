import 'dart:async';
import 'package:challenge1/services/file_manager.dart';

class PresetManager {

  final manager = FileManager();
  late Map<String, dynamic> presets;

  PresetManager._(this.presets);

  // Async factory constructor
  static Future<PresetManager> create() async {
    final manager = FileManager();

    // Create an instance of PresetManager with default presets
    PresetManager presetManager = PresetManager._({"PRESETS": {}});

    // Use loadPresets to load or initialize presets
    await presetManager.loadPresets();

    return presetManager;
  }

  Future<Map<String, dynamic>> loadPresets() async{
    if(!await manager.doesFileExist("presets.json")) {
      Map<String, dynamic> defaultPreset = {"PRESETS" : {}};
      await manager.initializeJsonFile("presets.json", defaultPreset);
    }
    Map<String, dynamic> preset = await manager.readJsonFile("presets.json");
    return preset;
  }

  Future<bool> doesPresetAlreadyExist(String name){
    return presets["PRESETS"].containsKey(name);
  }

  Future<bool> savePreset(String name, Map<String, dynamic> presetData) async{
    if (presets["PRESETS"] == null) {
      presets["PRESETS"] = {};
    }

    presets["PRESETS"][name] = presetData;

    await manager.writeJsonFile("presets.json", presets);
    return true;
  }

  Future<Map<String, dynamic>> getPreset(String name){
    return presets["PRESETS"][name];
  }

  bool createNewPreset(String name, Map<String,dynamic> options, Map<String,dynamic> values) {
      Map<String,dynamic> newPreset = {};
      newPreset["OPTIONS"] = options;
      newPreset["VALUES"] = values;
      savePreset(name, newPreset);
      return true;
  }
}