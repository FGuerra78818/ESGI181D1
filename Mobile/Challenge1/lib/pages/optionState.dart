import 'package:flutter/material.dart';
import 'package:pair/pair.dart';
import 'package:challenge1/services/config_manager.dart';

class OptionsState extends ChangeNotifier {


  List<Pair<String, String>> _encoded = [];
  bool _hasBeenLoaded = false;
  String _type = "VAT";
  late ConfigManager conf;

  OptionsState(){
    _initializeConf();
  }

  Future<void> _initializeConf() async {
    conf = await ConfigManager.create();
    notifyListeners();
    togglehasBeenLoaded();
  }


  List<Pair<String, String>> get encoded => _encoded;
  bool get hasBeenLoaded => _hasBeenLoaded;
  String get type => _type;

  ConfigManager getConf() {
    if (!hasBeenLoaded) {
      _initializeConf();
    }
    return conf;
  }


  set hasBeenLoaded(bool value) {
    _hasBeenLoaded = value;
  }

  void togglehasBeenLoaded() {
    _hasBeenLoaded = !_hasBeenLoaded;
  }


  void updateType(String name){
    _type = name;
  }


  void updateEncoded(List<Pair<String, String>> newEncoded) {
    _encoded = newEncoded;
    notifyListeners();
  }

}
