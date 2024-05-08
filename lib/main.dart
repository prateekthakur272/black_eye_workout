import 'package:black_eye_workout/src/app.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  await Hive.openBox('database');
  runApp(const App());
}
