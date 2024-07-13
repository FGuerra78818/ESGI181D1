import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

class OptionsState extends ChangeNotifier {

  List<int> _radioOptionsSelected = [];
  List<String> _selectedOptions = [];
  List<Pair<String, String>> _encoded = [];
  bool _hasBeenLoaded = false;
  String _type = "VAT";
  Map<String,Decimal> _valuesMapped = <String,Decimal>{};
  Map<String,dynamic> _optionsJson = {};
  List<Decimal> _values = [];

  List<int> get radioOptionsSelected => _radioOptionsSelected;
  List<String> get selectedOptions => _selectedOptions;
  List<Pair<String, String>> get encoded => _encoded;
  bool get hasBeenLoaded => _hasBeenLoaded;
  String get type => _type;
  Map<String,Decimal> get valuesMapped => _valuesMapped;
  Map<String,dynamic> get optionsJson => _optionsJson;
  List<Decimal> get values => _values;

  void togglehasBeenLoaded() {
    _hasBeenLoaded = !_hasBeenLoaded;
  }
  void selORemove(String text){
    _selectedOptions.remove(text);
  }
  void selOAdd(String text){
    _selectedOptions.add(text);
  }
  void radioToggle(int i){
    _radioOptionsSelected[i] = _radioOptionsSelected[i] == 1  ? 0: 1;
  }

  void updateType(String name){
    _type = name;
  }

  void updateRadioOptionsSelected(List<int> newSelection) {
    _radioOptionsSelected = newSelection;
    notifyListeners();
  }

  void updateEncoded(List<Pair<String, String>> newEncoded) {
    _encoded = newEncoded;
    notifyListeners();
  }

  void updateSelectedOptions(List<String> newSelection) {
    _selectedOptions = newSelection;
    notifyListeners();
  }

  bool hasSelectedOption(String name){
    return _selectedOptions.contains(name);
  }
  void updateValuesMapped(Map<String,Decimal> newValuesMapped){
    _valuesMapped = newValuesMapped;
    notifyListeners();
  }
  void updateOptionsJson(Map<String,dynamic> newValuesMapped){
    _optionsJson = newValuesMapped;
    notifyListeners();
  }
  void updateValues(List<Decimal> newValuesMapped){
    _values = newValuesMapped;
    notifyListeners();
  }

  void encodeRadioSelection() {
    List<Pair<String, String>> encoded = [];
    String toEncode = "";
    if (_type == "VAT") {
      toEncode = "VAT";
    }
    else if (_type == "BARREl") {
      toEncode = "BARREL";
    }
    try {
      int i = 0;
      _optionsJson["OPTIONS"][toEncode]["RADIAL"].forEach((key,value) {
        String master = key;
        List<dynamic> temp = value;
        var tempPair = Pair<String, String>(master,temp[radioOptionsSelected[i]].toString());

        encoded.add(tempPair);
        i++;
      });
    } catch (e) {
      print('Error Encoding options: $e');
      // Handle error loading JSON data
    }
    _encoded = encoded;
  }


}
