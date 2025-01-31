import 'dart:convert';
import 'dart:io';
import 'package:challenge1/classes/option.dart';
import 'package:challenge1/services/file_manager.dart';
import 'package:path_provider/path_provider.dart';

class ConfigManager {
  final manager = FileManager();
  late Map<String, dynamic> Joptions;
  late Map<String, dynamic> JneededValues;
  List<Option> options = [];
  final type = "VAT";
  
  ConfigManager(this.Joptions, this.JneededValues);

  static Future<ConfigManager> create() async {
    ConfigManager configManager = ConfigManager({}, {});
    await configManager.loadConfig();
    return configManager;
  }
  
  Future<bool> loadConfig() async {
    try {
      Joptions = await loadConfigFile("options.json");
      JneededValues = await loadConfigFile("neededvalues.json");
      return true;
    } catch (e) {
      return false;
    }
  }
  
  Future<Map<String,dynamic>> loadConfigFile(String name) {
    return manager.readJsonFile(name);
  }
  
  List<Option> getOptions() {
    return options;
  }
  
  bool createOptions () {
    for (var entry in Joptions["OPTIONS"][type]["RADIAL"].entries) {
      var key = entry.key;
      var res = (JneededValues["NEEDEDVALUES"][type][key]);
      if (res == null){
        Map<String, Map<String, List<String>>> tempMap = {};
        for (var opts in entry.value){
          tempMap[opts] = {};
        }
        options.add(Option.createOption(key, tempMap));
      } else {
        options.add(Option.createOption(key, getNeededValues(key)));
      }
    }
    return true;
  }

  Map<String, Map<String,List<String>>> getNeededValues(String option){
    return JneededValues["NEEDEDVALUES"][type][option];
  }
}