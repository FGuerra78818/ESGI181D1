
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:challenge1/pages/homepage.dart';
import 'package:challenge1/pages/optionState.dart';
import 'package:provider/provider.dart';

import '../classes/param.dart';


enum RecipientTypes { VAT, BARREL }


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
    _type = Provider.of<OptionsState>(context, listen: false).type == "VAT" ? RecipientTypes.VAT : RecipientTypes.BARREL;
  }

  RecipientTypes? _type = RecipientTypes.VAT;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAEB),
      appBar: buildAppBar(),
      bottomNavigationBar: buildBottomNavigationBar(),
      body: Consumer<OptionsState>(
        builder: (context, optionsState, child) {
          if (!optionsState.hasBeenLoaded) {
            print("Loading spinner is being displayed");
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildSingleChildScrollView();
          }
        },
      ),
    );
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
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
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
                    title: const Text('Cuba'),
                    leading: Radio<RecipientTypes>(
                      value: RecipientTypes.VAT,
                      groupValue: _type,
                      onChanged: (RecipientTypes? value) {
                        setState(() {
                          _type = value;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Pipa'),
                    leading: Radio<RecipientTypes>(
                      value: RecipientTypes.BARREL,
                      groupValue: _type,
                      onChanged: (RecipientTypes? value) {
                        setState(() {
                          _type = value;
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
                  Builder(
                    builder: (_) {
                      return SizedBox.shrink(); // Placeholder widget for print
                    },
                  ),
                  if (_type == RecipientTypes.VAT) ...[
                  for (var option in Provider.of<OptionsState>(context, listen: false).conf.options)
                    Column(
                      children: [
                      Align(
                      alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            option.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),),),),
                        LayoutBuilder(
                            builder: (context, constrains) {
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final param in option.params)
                                    if (param.name.isNotEmpty)
                                    SizedBox(
                                      width: constrains.maxWidth /2 - 12,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(param.name),
                                        leading: option.isCheckbox
                                        ? Checkbox(
                                          value: option.selected == 1,
                                          onChanged: (value) => _handleCheckboxChange(option.name, param.id, option.selected),)
                                            : Radio<Param>(
                                          value: param,
                                          groupValue: option.params[option.selected],
                                          onChanged: (Param? value) {
                                            setState(() {_handleRadioChange(option.name, param.id);});

                                          }
                                        ),
                                      ),
                                    )
                                ],
                              );
                            },
                        ),
                        const SizedBox(height: 16),
                    ],
                  ),
                ]],
          ),
          )]),
      );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xAAFFD447),
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


  void _handleCheckboxChange(String option, int param, int value)  {
    if (value == 1) {
      Provider.of<OptionsState>(context, listen: false)
          .conf.handleSelectedChange(option, 0);
    } else {
      Provider.of<OptionsState>(context, listen: false)
          .conf.handleSelectedChange(option, 1);
    }
    setState(() {});
  }

  void _handleRadioChange(String option, int param){
    Provider.of<OptionsState>(context, listen: false).conf.handleSelectedChange(option, param);
  }

  void _navigate(int index) {
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
      // Current page is OptionsPage, no need to navigate
        break;
      /*case 2:
        //print("olá: ${Provider.of<OptionsState>(context).selectedOptions} , ${Provider.of<OptionsState>(context).radioOptionsSelected} ");
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation,
              secondaryAnimation) => const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;*/
    }
  }

}