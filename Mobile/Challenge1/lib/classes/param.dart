import 'package:decimal/decimal.dart';
import 'package:pair/pair.dart';

class Param {
  final String name;
  Map<String, List<Pair<String,Decimal>>> values = {};
  int id;

  // Constructor
  Param(this.name, this.values, this.id);

  // Factory constructor to create a Param instance
  factory Param.createParam(String aname, Map<String, List<String>> names, id) {
    Map<String, List<Pair<String,Decimal>>> values = {};
    for (var entry in names.entries) {
      List<Pair<String, Decimal>> tempList = [];
      for (var names1 in entry.value){
        tempList.add(Pair(names1, Decimal.zero));
      }
      values[entry.key] = tempList;
    }
    return Param(aname, values, id);
  }

  String getName() {
    return name;
  }

  Map<String, List<Pair<String,Decimal>>> getValues() {
    return values;
  }

  Decimal getValue(String valName, String valPart){
    for (var entry in values.entries){
      if (valPart == entry.key){
        for (var entry2 in entry.value){
          if (entry2.key == valName){
            return entry2.value;
          }
        }
      }
    }
    return Decimal.parse('-1');
  }

  // Override toString() to provide a readable representation of the object
  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Param($name)');
    buffer.writeln('Values:');
    values.forEach((key, pairList) {
      buffer.writeln('  $key:');
      for (var pair in pairList) {
        buffer.writeln('    $pair');
      }
    });
    return buffer.toString();
  }
}