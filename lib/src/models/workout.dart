import 'package:black_eye_workout/src/models/exercise.dart';

class Workout {
  final String name;
  final List<Exercise> exercises;

  const Workout({required this.name, required this.exercises});
}
