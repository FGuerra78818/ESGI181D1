import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:challenge1/pages/optionspage.dart';
import 'package:challenge1/pages/valuespage.dart';
import 'package:challenge1/pages/homepage.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    Key? key,
    this.currentIndex = 0, // Default to 0 if not provided
  }) : super(key: key);

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 1:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const OptionsPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 2:
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
          const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFFFF0C2),
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      selectedItemColor: Colors.black,
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
        color: Colors.black,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }
}
