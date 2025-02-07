
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'optionspage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}
class _HomePage extends State<HomePage> {
  int selectedBox = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: buildAppBar(),
        bottomNavigationBar: buildBottomNavigationBar());
        //body: buildSingleChildScrollView());
  }
  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Cubicagem',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
      centerTitle: true,
      backgroundColor: const Color(0xFFFFF0C2),
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


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFF0C2),
      currentIndex: 0,
      onTap: _navigate,
      selectedItemColor: Colors.black,
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
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900,color: Colors.black),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900,color: Colors.black),
    );
  }

  _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 1:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OptionsPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 2:/*
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));

        break;*/
    }
  }
}