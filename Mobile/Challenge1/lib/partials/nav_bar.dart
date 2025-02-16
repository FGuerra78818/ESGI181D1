import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:challenge1/pages/optionspage.dart';
import 'package:challenge1/pages/valuespage.dart';
import 'package:challenge1/pages/homepage.dart';
import 'package:provider/provider.dart';

import '../pages/optionState.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return; // Don't navigate if already on the page

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
      case 1:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const OptionsPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        Provider.of<OptionsState>(context, listen: false).optionsSelected = true;
        break;
      case 2:
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const ValuesPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      currentIndex: currentIndex,
      onTap: (index) => _navigate(context, index),
      selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      selectedFontSize: 15,
      unselectedFontSize: 12,
      unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/home.svg',
            height: 25,
            width: 30,
            color: currentIndex == 0 ? Theme.of(context).colorScheme.onPrimary : Colors.grey,
          ),
          label: "HOME",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/setting.svg',
            height: 25,
            width: 30,
            color: currentIndex == 1 ? Theme.of(context).colorScheme.onPrimary : Colors.grey,
          ),
          label: "OPTIONS",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            'assets/icons/map.svg',
            height: 25,
            width: 30,
            color: currentIndex == 2 ? Theme.of(context).colorScheme.onPrimary : Colors.grey,
          ),
          label: "VALUES",
        ),
      ],
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
