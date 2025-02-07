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
    int id = 0;
    for (var entry in paramss.entries){
      params2.add(Param.createParam(entry.key, entry.value, id));
      id++;
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

  Map<String, Map<String, String>> getValuesJsonFormat () {
    Map<String, Map<String, String>> res = {};
    Param selectedParam = params[selected];


    Map<String, List<Pair<String,Decimal>>> paramValue = selectedParam.getValues();

    for (var entry in paramValue.entries){
      if (entry == {}) {continue;}
      Map<String, String> innermap = {};
      for (Pair<String, Decimal> pp in entry.value) {
        innermap[pp.key] = pp.value.toString();
      }
      res[entry.key] = innermap;
    }

    return res;
  }
  // Override toString() to provide a readable representation of the object
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Option(name: $name)');
    buffer.writeln('Is Checkbox: $isCheckbox');
    buffer.writeln('Selected: $selected');
    buffer.writeln('Params:');
    for (var param in params) {
      buffer.writeln('  $param');
    }
    return buffer.toString();
  }

}
