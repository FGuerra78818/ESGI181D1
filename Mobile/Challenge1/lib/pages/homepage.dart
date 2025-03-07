import 'package:flutter/material.dart';
import 'package:challenge1/partials/nav_bar.dart';
import 'package:challenge1/partials/app_bar.dart';


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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: buildAppBar(context),
        bottomNavigationBar: const NavBar(currentIndex: 0,));
        //body: buildSingleChildScrollView());
  }
}