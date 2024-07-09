import 'package:flutter/material.dart';
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
  RecipientTypes? _type = RecipientTypes.vat;
  List<String> _options = ["Hosepipe", "Lower cone"];
  // Header Name, Option 1, Option 2
  List<List<String>> _radioOptions = [ ["Body", "Cylinder","Cone"], ["Neck Position","Center","Side"], ["Door","Inside","Outside"], ["Top","Cone","Flat"], ["Door", "Cubic", "Elipsal"]];
  List<int> _radioOptionsSelected = [0,0,0,0,0];
  List<String> _selectedOptions = [];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffB4D8F9),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: buildSingleChildScrollView(),
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
                         padding: EdgeInsets.only(left: 16.0),

                      child: Text(_radioOptions[i][0],
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
    if (_type == RecipientTypes.vat) {
      _options = ["Hosepipe", "Lower cone"];
      _radioOptions = [ ["Body", "Cylinder","Cone"], ["Top","Centered","OffCentered"], ["Door","Inside","Outside"], ["Top","Cone","Flat"], ["Door", "Rectangular", "Elipsal"]];
    } else if (_type == RecipientTypes.barrel) {
      _options = [];
      _radioOptions = [["Type","Porto","Normal"]];
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