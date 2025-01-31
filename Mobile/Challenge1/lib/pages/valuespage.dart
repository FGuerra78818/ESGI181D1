
import 'dart:convert';
import 'dart:io';

import 'package:challenge1/pages/optionState.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
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
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }



  String _type = "VAT";
  String enteredText = '';

  Map<String, dynamic>? _neededValues;
  final List<dynamic> _neededValuesName = [];



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





}