import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:challenge1/pages/valuespage.dart';
import 'package:challenge1/pages/homepage.dart';


enum RecipientTypes { vat, barrel }


class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});


  @override
  State<StatefulWidget> createState() {
    return _OptionsPageState();
  }
}

class _OptionsPageState extends State<OptionsPage> {


  @override
  void initState() {
    super.initState();
    loadJsonData();
  }


  final List<List<dynamic>> _vatRadioOptions = [];
  RecipientTypes? _type = RecipientTypes.vat;
  List<String> _options = [];
  // Header Name, Option 1, Option 2
  List<List<String>> _radioOptions = [];
  List<int> _radioOptionsSelected = [];
  List<String> _selectedOptions = [];
  Map<String, dynamic>? _optionsJson;


  Future<void> loadJsonData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/config/options.json');
      Map<String, dynamic> jsonOptions = jsonDecode(jsonString);
      print('Parsed JSON: $jsonOptions'); // Debug print
      setState(() {
        _optionsJson = jsonOptions;
        _updateOptions(); // Initialize options based on default type (VAT)
      });
    } catch (e) {
      print('Error loading options.json: $e');
      // Handle error loading JSON data
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB4D8F9),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: _optionsJson == null
          ? const Center(child: CircularProgressIndicator())
          : buildSingleChildScrollView(),
    );
  }

  Widget buildSingleChildScrollView() {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double paddingTop = screenHeight * 0.075; // 7.5%

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: paddingTop),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Select the type',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: const Text('Vat'),
                    leading: Radio<RecipientTypes>(
                      value: RecipientTypes.vat,
                      groupValue: _type,
                      onChanged: (RecipientTypes? value) {
                        setState(() {
                          _type = value;
                          _updateOptions();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Barrel'),
                    leading: Radio<RecipientTypes>(
                      value: RecipientTypes.barrel,
                      groupValue: _type,
                      onChanged: (RecipientTypes? value) {
                        setState(() {
                          _type = value;
                          _updateOptions();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                for (int i = 0; i< _radioOptions.length; i++)
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,

                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),

                          child: Text(_radioOptions[i][0],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),),),),
                      Row(
                        children: [
                          for (int j = 1; j < 3 ; j++)
                            Expanded(
                                child: ListTile(
                                  title: Text(_radioOptions[i][j]),
                                  leading: Radio<String>(
                                    value: _radioOptions[i][j],
                                    groupValue: _radioOptions[i][_radioOptionsSelected[i]+1],
                                    onChanged: (String? value) {
                                      setState(() {
                                        _updateRadialOptions(i,j);
                                      });
                                    },
                                  ),
                                )),
                        ],),
                    ],
                  ),],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
                children: [
                  for (var option in _options)
                    CheckboxListTile(
                      title: Text(option),
                      value: _selectedOptions.contains(option),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value != null && value) {
                            _selectedOptions.add(option);
                          } else{
                            _selectedOptions.remove(option);
                          }
                        });
                      },)
                ]
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff5B92C6),
      currentIndex: 1,
      onTap: _navigate,
      selectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            height: 25,
            width: 30,
          ),
          label: "HOME",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/setting.svg',
            height: 25,
            width: 30,
          ),
          label: "OPTIONS",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/map.svg',
            height: 25,
            width: 30,
          ),
          label: "VALUES",
        ),
      ],
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
      ),
    );
  }
  void _updateRadialOptions(int i, int j){
    if (j == 1){
      _selectedOptions.remove(_radioOptions[i][0] + _radioOptions[i][2]);
      _selectedOptions.add(_radioOptions[i][0] + _radioOptions[i][1]);
      _radioOptionsSelected[i] = 0;
    } else{
      _selectedOptions.remove(_radioOptions[i][0] + _radioOptions[i][1]);
      _selectedOptions.add(_radioOptions[i][0] + _radioOptions[i][2]);
      _radioOptionsSelected[i] = 1;
    }

  }
  void _updateOptions() {
    String toDecode = "";
    if (_type == RecipientTypes.vat){
      toDecode = "VAT";
    }
    else if (_type == RecipientTypes.barrel){
      toDecode = "BARREL";
    }
    if (_optionsJson != null) {

      _radioOptions.clear();
      _options.clear();
      if (_optionsJson!["OPTIONS"][toDecode].containsKey("CHECKBOX")){
        _optionsJson!["OPTIONS"][toDecode]["CHECKBOX"].forEach((key){
        _options.add(key);
      });}

      _vatRadioOptions.clear();
      if (_optionsJson!["OPTIONS"][toDecode].containsKey("RADIAL")){
      _optionsJson!["OPTIONS"][toDecode]["RADIAL"].forEach((key, value) {
        List<dynamic> optionList = [key];
        optionList.addAll(value.cast<String>());
        _vatRadioOptions.add(optionList);});}
      _radioOptions = _vatRadioOptions.map((innerList) {
        return innerList.map((element) => element.toString()).toList();
      }).toList();

      _radioOptionsSelected.clear();
      for (int i = 0; i< _radioOptions.length; i++){
        _radioOptionsSelected.add(0);
      }

      _selectedOptions.clear();
    }
  }


  void _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 1:
      // Current page is OptionsPage, no need to navigate
        break;
      case 2:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
    }
  }


}