import 'dart:async';
import 'package:challenge1/services/config_manager.dart';
import 'package:challenge1/services/file_manager.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';

class PresetManager {

  final manager = FileManager();
  late Map<String, dynamic> presets;

  PresetManager(this.presets);

  // Async factory constructor
  static Future<PresetManager> create() async {
    final manager = FileManager();

    // Create an instance of PresetManager with default presets
    PresetManager presetManager = PresetManager({"PRESETS": {}});

    // Use loadPresets to load or initialize presets
    presetManager.presets = await presetManager.loadPresets();

    return presetManager;
  }

  Future<Map<String, dynamic>> loadPresets() async{
    if(!await manager.doesDirFileExist("presets.json")) {
      Map<String, dynamic> defaultPreset = {"PRESETS" : {}};
      await manager.initializeJsonFile("presets.json", defaultPreset);
    }
    Map<String, dynamic> preset = await manager.readDirJsonFile("presets.json");
    return preset;
  }

  bool doesPresetAlreadyExist(String name){
    return presets["PRESETS"].containsKey(name);
  }

  Future<bool> savePreset(String name, Map<String, dynamic> presetData) async{
    if (presets["PRESETS"] == null) {
      presets["PRESETS"] = {};
    }

    presets["PRESETS"][name] = presetData;
    await writePresets();
    return true;
  }

  Future<bool> writePresets() async{
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
  
  List<String> getPresetNames(){
    List<String> res = [];
    for (final name in presets["PRESETS"].entries){
      res.add(name.key);
    }
    return res;
  }


  ConfigManager loadPreset(ConfigManager conf, String pName){
    if (presets["PRESETS"][pName] == null) {
      return conf;
    }
    for (var opts in presets["PRESETS"][pName]["Options"].entries){
      int paramId = conf.findParamId(opts.key, opts.value);
      conf.handleSelectedChange(opts.key, paramId);
    }
    for (var values in presets["PRESETS"][pName]["Values"].entries){
      List<String> words = values.key.split(' '); // Split by space
      String lastWord = words.isNotEmpty ? words.last : '';
      final remainingWords = words.length > 1
          ? words.sublist(0, words.length - 1).join(' ')
          : '';

      conf.updateValue(lastWord, remainingWords, Decimal.parse((values.value)));
    }
    return conf;
  }

  void deletePreset(String pName) async{
    if (doesPresetAlreadyExist(pName)){
      presets.remove(pName);
      await writePresets();
    }
  }

}