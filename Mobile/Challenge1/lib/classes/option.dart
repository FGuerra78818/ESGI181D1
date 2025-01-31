import 'package:challenge1/classes/param.dart';
import 'package:decimal/decimal.dart';
import 'package:pair/pair.dart';

// For Checkbox representation params = ["","Sim"]
class Option {
  final String name;
  List<Param> params;
  bool isCheckbox = false;
  int selected = 0;

  Option({required this.name, required this.params, this.selected = 0, this.isCheckbox = false});

  factory Option.createOption(String name, Map<String, Map<String, List<String>>> paramss) {
    List<Param> params2 = [];
    for (var entry in paramss.entries){
      params2.add(Param.createParam(entry.key, entry.value));
    }
    return Option(name: name, params: params2);
  }

  void changeSelected(int param) {
    // Copy same value names
    int pselected = selected;
    selected = param;
    for (var entry in params[pselected].getValues().entries){
      for (var entry2 in params[selected].getValues().entries){
        if (entry.key == entry2.key){
          params[selected].values[entry.key] = entry.value;
        }
      }
    }
  }

  Map<String, String> getOptionJsonFormat (){
    Map<String, String> res = {name : params[selected].getName()};
    return res;
  }

  Map<String, String> getValuesJsonFormat () {

    Param selectedParams = params[selected].getValues();
    for (var entry in values.entries){
      print(entry.key);
      print(entry.value);
      res[entry.key] = entry.value.toString();
    }
    return res;
  }
}
