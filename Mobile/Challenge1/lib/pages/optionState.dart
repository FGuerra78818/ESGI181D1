import 'package:flutter/material.dart';
import 'package:pair/pair.dart';

class OptionsState extends ChangeNotifier {

  List<int> _radioOptionsSelected = [];
  List<String> _selectedOptions = [];
  List<Pair<String, String>> _encoded = [];
  bool _hasBeenLoaded = false;

  List<int> get radioOptionsSelected => _radioOptionsSelected;
  List<String> get selectedOptions => _selectedOptions;
  List<Pair<String, String>> get encoded => _encoded;
  bool get hasBeenLoaded => _hasBeenLoaded;

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


}
