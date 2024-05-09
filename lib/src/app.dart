import 'package:black_eye_workout/src/repository/workout_repository.dart';
import 'package:black_eye_workout/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutRepository(),
      child: MaterialApp(
        title: 'Black Eye',
        theme: ThemeData(
            colorScheme: ColorScheme(
                brightness: Brightness.light,
                error: Colors.red.shade400,
                onError: Colors.white,
                primary: Colors.black,
                onPrimary: Colors.white,
                secondary: Colors.grey.shade400,
                onSecondary: Colors.black,
                background: Colors.grey.shade200,
                onBackground: Colors.black,
                surface: Colors.white,
                onSurface: Colors.black)),
        home: const HomeScreen(),
      ),
    );
  }
}
