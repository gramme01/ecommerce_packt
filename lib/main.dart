import 'package:flutter/material.dart';

import './screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Packt',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyan[400],
        accentColor: Colors.deepOrange[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 72.0,
            fontWeight: FontWeight.bold,
          ),
          headline5: TextStyle(
            fontSize: 36.0,
            fontStyle: FontStyle.italic,
          ),
          bodyText1: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      home: RegisterScreen(),
    );
  }
}
