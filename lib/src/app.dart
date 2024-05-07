import 'package:black_eye_workout/src/screens/home_screen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Black Eye',
      theme: ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
