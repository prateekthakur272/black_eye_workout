import 'package:black_eye_workout/src/models/exercise.dart';
import 'package:black_eye_workout/src/models/workout.dart';
import 'package:flutter/material.dart';

class WorkoutRepository extends ChangeNotifier {
  static final List<Workout> _workouts = [
    Workout(name: 'Upper Body', exercises: [
      Exercise(
          name: 'Bicep Curls',
          weight: '10',
          reps: '10',
          sets: '3',
          isCompleted: false)
    ]),
  ];

  List<Workout> get workouts => _workouts;

  void addWorkout(String name) {
    _workouts.add(Workout(name: name, exercises: []));
    notifyListeners();
  }

  void addExercise(String workoutName, Exercise exercise) {
    final workout = getWorkoutByName(workoutName);
    workout.exercises.add(exercise);
    notifyListeners();
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    final workout = getWorkoutByName(workoutName);
    final exercise = getExerciseByName(exerciseName, workout);
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners();
  }

  int numberOfExerciseInWorkout(String workoutName) {
    return getWorkoutByName(workoutName).exercises.length;
  }

  Workout getWorkoutByName(String name) {
    return _workouts.firstWhere((element) => element.name == name);
  }

  Exercise getExerciseByName(String exerciseName, Workout workout) {
    return workout.exercises
        .firstWhere((element) => element.name == exerciseName);
  }
}
