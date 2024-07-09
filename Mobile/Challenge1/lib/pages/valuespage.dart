
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffB4D8F9),
        bottomNavigationBar: buildBottomNavigationBar());
    //body: buildSingleChildScrollView());
  }


  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff5B92C6),
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