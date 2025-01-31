import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
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

  Future<Bool> doesPresetAlreadyExist(String name){
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
}