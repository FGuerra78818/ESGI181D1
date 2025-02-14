import 'package:challenge1/pages/homepage.dart';
import 'package:challenge1/pages/optionState.dart';
import 'package:challenge1/theme/dark_theme.dart';
import 'package:challenge1/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => OptionsState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme1,
        darkTheme: darkTheme1,
        themeMode: Provider.of<OptionsState>(context).themeMode,
        home: const HomePage(),
    );
  }
}
