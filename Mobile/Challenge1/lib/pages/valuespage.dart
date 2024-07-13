
import 'dart:convert';
import 'dart:io';

import 'package:challenge1/pages/optionState.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pair/pair.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';
import 'optionspage.dart';

class ValuesPage extends StatefulWidget {
  const ValuesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ValuesPage();
  }
}
class _ValuesPage extends State<ValuesPage> {
  final List<TextEditingController> _controllers = [];
  bool _isSnackBarActive = false;
  Map<String,dynamic> _presets = {};
  @override
  void initState() {
    super.initState();

    _type = Provider
        .of<OptionsState>(context, listen: false)
        .type;
    loadJsonData(); //needed values
    readJsonFile(); //presets
  }
  @override
  void dispose() {

    super.dispose();
  }

  void disposeController() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();
  }

  String _type = "VAT";
  String enteredText = '';

  Map<String, dynamic>? _neededValues;
  final List<dynamic> _neededValuesName = [];

  Future<void> loadJsonData() async {
    try {
      final String jsonString = await rootBundle.loadString(
          'assets/config/neededValues.json');
      Map<String, dynamic> jsonOptions = jsonDecode(jsonString);
      setState(() {
        _neededValues = jsonOptions;
        loadNeededNames(); // Initialize options based on default type (VAT)
      });
    } catch (e) {
      print('Error loading options.json: $e');
      // Handle error loading JSON data
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFAEB),
        appBar: buildAppBar(),
        bottomNavigationBar: buildBottomNavigationBar(),
     body: _presets == {}
            ? const Center(child: CircularProgressIndicator())
    : buildSingleChildScrollView());
  }


  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Cubicagem',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
      centerTitle: true,
      backgroundColor: const Color(0xAAFFD447),
      //actions: [
      /*
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // Implement more options functionality here
            print('More button pressed');
          },
        ),
     ],*/
    );
  }

  Widget buildSingleChildScrollView() {
    return SingleChildScrollView(
        child: Column(
          children: [
            /**
             * Adicionar as presets
             */
            if (_presets.containsKey("PRESETS") && _presets["PRESETS"] is Map<String, dynamic>)
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _presets["PRESETS"].keys.map((key) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 3 - 12, // Adjust width based on screen size
                    child: ElevatedButton(
                      onPressed: () {
                        loadPreset(key); // Call loadPreset with the current key
                      },
                      child: Text(key), // Display the key as button text
                    ),
                  );
                }).toList().cast<Widget>(), // Cast to List<Widget>
              ),
            Padding (
              padding: const EdgeInsets.all(30.0),
              child: Container(
                child: Column(
                  children: [
                    for (int i = 0; i < _neededValuesName.length ; i++)
                      Row(
                        children: [
                          Expanded(child:
                            Text(_neededValuesName[i],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: (MediaQuery.of(context).size.height/0.45),
                              child: TextField(
                                controller: _controllers[i],
                                obscureText: false,
                                decoration: const InputDecoration(
                                      border: OutlineInputBorder()
                              ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow only decimal input
                                ],
                                /* validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid decimal value';
                          }
                          return null;
                        },*/
                          )))
                ],),
                    Row(
                      children: [
                        Expanded(child: ElevatedButton(onPressed: prepareSend, child: const Text("Calculate")),),
                        Expanded(child: ElevatedButton(onPressed: savePreset, child: const Text("Save")))
                      ],
                    )

                  ],


              ),
            ))


          ],
        )


    );
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xAAFFD447),
      currentIndex: 2,
      onTap: _navigate,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg', height: 25, width: 30,),
          label: ("HOME"),),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/setting.svg', height: 25, width: 30,),
          label: ("OPTIONS"),),
        BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/map.svg', height: 25, width: 30,),
            label: ("VALUES")),
      ],
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900,),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900,),
    );
  }

  _navigate(int index) {
    saveValues();
    switch (index) {
      case 0:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) => const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 1:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) => const OptionsPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 2:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) => const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));

        break;
    }
  }

  void loadPreset(String name) {
    try {
      var tempMap2 = _presets["PRESETS"][name]["Values"];
      int i = 0;
      var tempMap1 = _presets["PRESETS"][name]["Options"];

      List<int> tempSelectedRadio = Provider
          .of<OptionsState>(context, listen: false)
          .radioOptionsSelected;
      List<String> selectedOptions = [];
      Map<String,dynamic> optionsJson =  Provider
          .of<OptionsState>(context, listen: false)
          .optionsJson;
      for (var entry in tempMap1.entries) {
        if (optionsJson["OPTIONS"][_type]["RADIAL"].containsKey(entry.key)){
          if (optionsJson["OPTIONS"][_type]["RADIAL"][entry.key][0] == entry.value) {
            tempSelectedRadio[i] = 0;
          }
          else {
            tempSelectedRadio[i] = 1;
          }
        }

        print("Entry: $entry");
        if (optionsJson["OPTIONS"][_type]["CHECKBOX"].contains(entry.key)) {
          print("Contains: $entry");
          selectedOptions.add(entry.key);
        }
        i++;
      }
      Provider.of<OptionsState>(context, listen: false).updateSelectedOptions(
          selectedOptions);
      Provider.of<OptionsState>(context, listen: false)
          .updateRadioOptionsSelected(tempSelectedRadio);
      Provider.of<OptionsState>(context, listen: false).encodeRadioSelection();
      Fluttertoast.showToast(msg: "Verify your options");

      loadNeededNames();
      i = 0;
      for (var entry in tempMap2.entries) {
        _controllers[i].text = entry.value.toString();
        i++;
      }
      _navigate(1);

    }catch (e){
      print("Crashed : $e");
    }
  }

  bool _validateFields() {
    if (_isSnackBarActive){
      return false;
    }
    bool allFilled = true;
    for (var controller in _controllers) {
      if (controller.text.isEmpty) {
        allFilled = false;
        break;
      }
    }
    if (!allFilled) {
      setState(() {
        _isSnackBarActive = true;
      });
      ScaffoldMessenger
          .of(context)
          .showSnackBar(
        SnackBar(
          content: Text(allFilled ? 'All fields are filled!' : 'Please fill all fields'),
          duration: const Duration(seconds: 2),
        ),
      )
          .closed
          .then((_) {
        setState(() {
          _isSnackBarActive = false;
        });
      });
    }
    return allFilled;
  }

  void saveValues() {
    List<Decimal> values = [];
    for (int i = 0; i < _controllers.length; i++) {
      if (!_controllers[i].text.isEmpty) {
        values.add(Decimal.parse(_controllers[i].text));
      }
    }
    Provider.of<OptionsState>(context, listen: false).updateValues(values);
  }
  void loadValues() {
    try {
      List<Decimal> values = Provider
          .of<OptionsState>(context, listen: false)
          .values;
      for (int i = 0; i < values.length; i++) {
        _controllers[i].text = values[i].toString();
      }
    } catch (e){
      print("Error on loadValues $e");
    }
  }

  void savePreset() async{
    if (!_validateFields()){
      return;
    }
    prepareSend();
    Map<String,Decimal> valuesMapped = Provider.of<OptionsState>(context, listen: false).valuesMapped;
    await _displayTextInputDialog();
    if (enteredText == "CANCELED") {
      return;
    } else if (enteredText == ""){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(
            content: Text('Please insert a valid name'),
            duration: Duration(seconds: 2),
          ),);
          return;
    }
    if (doesPresetAlreadyExist(enteredText) == true) {
        showOverwriteConfirmationDialog();
    }
    else{
      createNewPreset();
      savePresetFile();
    }


  }

  bool doesPresetAlreadyExist(String name){

    if (_presets["PRESETS"].containsKey(name)){
      return true;
    }
    return false;
  }



  void createNewPreset(){
    _presets["PRESETS"][enteredText] = {};
    Map<String,dynamic> tempMap = {};
    Map<String,Decimal> tempMap2 = {};
    for (var entry in Provider.of<OptionsState>(context, listen: false).valuesMapped.entries){
      var key = entry.key;
      var value = entry.value;
      tempMap2[key] = value;
    }

    Map<String,String> tempMap3 = {};
    for (var entry in Provider.of<OptionsState>(context, listen: false).encoded){
      var key = entry.key;
      var value = entry.value;
      tempMap3[key] = value;
    }
    for (var entry in Provider.of<OptionsState>(context, listen: false).selectedOptions){
      tempMap3[entry] = "true";
    }
    tempMap["Options"] = tempMap3;
    tempMap["Values"] = tempMap2;
    _presets["PRESETS"][enteredText] = tempMap;
    savePresetFile();
  }

  void showOverwriteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Overwrite Confirmation'),
          content: Text('A preset with the name "$enteredText" already exists. Do you want to overwrite it?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Overwrite'),
              onPressed: () {
                createNewPreset(); // Overwrite the existing preset
                savePresetFile(); // Save the updated presets list
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> savePresetFile() async{
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/presets.json';
    final jsonString = jsonEncode(_presets);
    final file = File(filePath);
    await file.writeAsString(jsonString);
  }

  Future<void> readJsonFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/presets.json';
    final file = File(filePath);

    if (!await file.exists()) {
      // Read presets.json from rootBundle
      final presetsData = await rootBundle.loadString(
          'assets/config/presets.json');

      // Write the data to options.json
      await file.writeAsString(presetsData);
    }

    final String jsonString = await file.readAsString();
    Map<String, dynamic> jsonOptions = jsonDecode(jsonString);
    setState(() {
      _presets = jsonOptions;
    });
  }

  final TextEditingController _textFieldController = TextEditingController();
  Future<void> _displayTextInputDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Preset'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Insert Preset Name"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\w{0,8}')), // Allow only decimal input
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                enteredText = "CANCELED";
                _textFieldController.text = "";
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                enteredText = _textFieldController.text;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  void prepareSend() {
  /*
      _presets = {"PRESETS":{"C69" :{"Options" : {"Body" : "Cylinder","Top" : "Cone","Neck Position" : "Center","Door" : "Inside","Door Shape" : "Ellipse"},"Values" : {"Neck Diameter" : 40,"Neck Height" : 36,"Hypotenuse" : 136,"Base Diameter" : 304.5,"Total Height" : 521.3,"Door Bigger Diameter" : 43,"Door Smaller Diameter" : 31,"Door Depht" : 1.5}}}};
      savePresetFile();
      print('Created or overwritten presets.json file at: ');
  */
    savePresetFile();
    if (!_validateFields()){
      return;
    }
    Map<String,Decimal> valuesMapped = <String,Decimal>{};
    for (int i = 0; i < _controllers.length; i++){
      valuesMapped[_neededValuesName[i]] = Decimal.parse(_controllers[i].text);

    }
    Provider.of<OptionsState>(context, listen: false).updateValuesMapped(valuesMapped);
  }

  void loadNeededNames() {
    /**
     * Missing CheckBoxes
     */
    try {
      if (_neededValues != null) {
        _neededValuesName.clear();
        disposeController();
        var encoded = Provider.of<OptionsState>(context, listen: false).encoded;
        for (Pair<String,String> i in encoded) {
          //String (option,selected) = i;

          if (_neededValues!["NEEDEDVALUES"][_type]["RADIAL"].containsKey(i.key) ) {
            for (String str in _neededValues!["NEEDEDVALUES"][_type]["RADIAL"][i.key][i.value]) {
              _neededValuesName.add(str);
              _controllers.add(TextEditingController());
            }
          }
        }
        if (Provider.of<OptionsState>(context, listen: false).selectedOptions.isNotEmpty) {
          for (var str1 in Provider
              .of<OptionsState>(context, listen: false)
              .selectedOptions) {
            if (_neededValues!["NEEDEDVALUES"][_type]["CHECKBOX"].containsKey(str1)) {
              for (String str in _neededValues!["NEEDEDVALUES"][_type]["CHECKBOX"][str1]) {
                _neededValuesName.add(str);
                _controllers.add(TextEditingController());
              }
            }
          }
        }
        loadValues();
      }
    } catch (e) {
      print('Error decoding needevalues.json: $e');
    }

  }

}