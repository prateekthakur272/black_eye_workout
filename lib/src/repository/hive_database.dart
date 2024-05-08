import 'package:black_eye_workout/src/datetime/date_time.dart';
import 'package:black_eye_workout/src/models/exercise.dart';
import 'package:black_eye_workout/src/models/workout.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  final _box = Hive.box('database');

  bool dataExists() {
    if (_box.isEmpty) {
      _box.put('START_DATE', todaysDate());
      return false;
    }
    return true;
  }

  String getStartDate() {
    return _box.get('START_DATE');
  }

  void save(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    if (exerciseCompleted(workouts)) {
      _box.put('COMPLETION_STATUS_${todaysDate()}', 1);
    } else {
      _box.put('COMPLETION_STATUS_${todaysDate()}', 0);
    }

    _box.put("WORKOUTS", workoutList);
    _box.put('EXERCISES', exerciseList);
  }

  List<Workout> read() {
    final List<Workout> workouts = [];
    final List<String> workoutNames = _box.get('WORKOUTS');
    final exerciseDetails = _box.get('EXERCISES');

    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exercisesInWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exercisesInWorkout.add(Exercise(
            name: exerciseDetails[i][j][0],
            weight: exerciseDetails[i][j][1],
            reps: exerciseDetails[i][j][2],
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == 'true'));
      }

      final Workout workout =
          Workout(name: workoutNames[i], exercises: exercisesInWorkout);
      workouts.add(workout);
    }
    return workouts;
  }

  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  int getCompletetionStatus(String date) {
    int status = _box.get('COMPLETION_STATUS_$date') ?? 0;
    return status;
  }
}

List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> stringWorkouts = [];
  for (var element in workouts) {
    stringWorkouts.add(element.name);
  }
  return stringWorkouts;
}

List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exercises = [];

  for (var workout in workouts) {
    final exerciseInWorkout = workout.exercises;
    final List<List<String>> individualWorkout = [];
    for (var exercise in exerciseInWorkout) {
      List<String> individualExercise = [];
      individualExercise.addAll([
        exercise.name,
        exercise.weight,
        exercise.reps,
        exercise.sets,
        exercise.isCompleted.toString()
      ]);
      individualWorkout.add(individualExercise);
    }
    exercises.add(individualWorkout);
  }
  return exercises;
}
