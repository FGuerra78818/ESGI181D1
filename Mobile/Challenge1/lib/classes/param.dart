import 'package:decimal/decimal.dart';
import 'package:pair/pair.dart';

class Param {
  final String name;
  Map<String, List<Pair<String,Decimal>>> values = {};

  // Constructor
  Param(this.name, this.values);

  // Factory constructor to create a Param instance
  factory Param.createParam(String aname, Map<String, List<String>> names) {
    Map<String, List<Pair<String,Decimal>>> values = {};
    for (var entry in names.entries) {
      List<Pair<String, Decimal>> tempList = [];
      for (var names1 in entry.value){
        tempList.add(Pair(names1, Decimal.zero));
      }
      values[entry.key] = tempList;
    }
    return Param(aname, values);
  }

  String getName() {
    return name;
  }

  Map<String, List<Pair<String,Decimal>>> getValues() {
    return values;
  }
}