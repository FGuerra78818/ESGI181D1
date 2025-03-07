import 'package:challenge1/classes/option.dart';
import 'package:challenge1/classes/param.dart';
import 'package:challenge1/services/file_manager.dart';
import 'package:decimal/decimal.dart';
import 'package:pair/pair.dart';

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
    configManager.createOptions();
    return configManager;
  }
  
  Future<bool> loadConfig() async {
    try {
      Joptions = await loadConfigFile("options.json");
      JneededValues = await loadConfigFile("neededValues.json");
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
    for (var entry in Joptions["OPTIONS"][type]["CHECKBOX"]){
      var res = getNeededValues(entry);
      Map<String, List<String>> values = {};
      var values1 = res["Sim"];
      List<Param> params = [Param.createParam("", values, 0), Param.createParam("Sim", values1!, 1)];
      Option option = Option(name: entry, params: params, isCheckbox: true, selected: 0);
      options.add(option);
    }

    return true;
  }

  Map<String, Map<String, List<String>>> getNeededValues(String option) {
    Map<String, Map<String, List<String>>> res = {};
    try {
      // First, cast the retrieved value as Map<String, dynamic>
      final dynamic rawData = JneededValues["NEEDEDVALUES"][type][option];
      // Now convert rawData into the desired type:
      res = (rawData as Map<String, dynamic>).map((outerKey, outerValue) {
        // Each outerValue should itself be a Map; cast it accordingly.
        final innerMap = (outerValue as Map<String, dynamic>).map((innerKey, innerValue) {
          // Convert the innerValue (expected List<dynamic>) into List<String>
          return MapEntry(innerKey, List<String>.from(innerValue));
        });
        return MapEntry(outerKey, innerMap);
      });
    } catch (e) {
      print(e);
    }
    return res;
  }


  void handleSelectedChange(String optname, int paramId){
    for (Option option in options){
      if (option.name == optname){
        option.selected = paramId;
      }
    }
  }

  Map<String, List<Pair<String, Decimal>>> aggregateNeededValues() {
    Map<String, List<Pair<String, Decimal>>> aggregated = {};

    for (final option in options) {
      final neededValues = option.getNeededValues();

      neededValues.forEach((category, parameters) {
        aggregated.update(
          category,
              (existing) => existing..addAll(parameters),
          ifAbsent: () => List.from(parameters),
        );
      });
    }
    return aggregated;
  }

  void updateValue(String part, String valName, Decimal value) {
    for (var option in options) {
      //var param = option.params[option.selected];
      for (var param in option.params){
        for (var values in param.values.entries){
          if (values.key == part) {
            for (int i = 0; i < values.value.length; i++) {
              if (values.value[i].key == valName) {
                values.value[i] = Pair(valName, value);
              }
            }
          }
        }
      }
    }
  }
  int findParamId(String optName, String paramName){
    for (var opt in options){
      if (opt.name == optName){
        int paramId = opt.getParamId(paramName);
        if (paramId == -1){
          break;
        }
        return paramId;
      }
    }
    return -1;
  }

  Decimal getValue(String paramName, String partName){
    for (var opt in options){
      for (var param in opt.params){
        Decimal res = param.getValue(paramName, partName);
        if (res != Decimal.fromInt(-1)){
          return res;
        }
      }
    }
    return Decimal.parse('-1');
  }

  Map<String, dynamic> getJsonEncoding(){
    Map<String, dynamic> res = {};
    res["Options"] = {};
    res["Values"] = {};
    for (final opt in options){
      if (opt.isCheckbox){
        if (opt.selected == 0){
          continue;
        }
      }
      res["Options"].addAll(opt.getOptionJsonFormat());
      res["Values"].addAll(opt.getValuesJsonFormat());
    }
    return res;
  }

  bool isSelected(String optName, String paramName){
    for (var opt in options){
      if (opt.name == optName){
        if (opt.params[opt.selected].name == paramName) return true;
      }
    }
    return false;
  }


}