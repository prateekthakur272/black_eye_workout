import 'package:black_eye_workout/src/datetime/date_time.dart';
import 'package:black_eye_workout/src/models/exercise.dart';
import 'package:black_eye_workout/src/models/workout.dart';
import 'package:black_eye_workout/src/repository/hive_database.dart';
import 'package:flutter/material.dart';

class WorkoutRepository extends ChangeNotifier {
  final _db = HiveDatabase();

  static List<Workout> _workouts = [
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

  void initializeWorkouts() {
    if (_db.dataExists()) {
      _workouts = _db.read();
    } else {
      _db.save(workouts);
    }
    loadHeatMap();
  }

  void addWorkout(String name) {
    _workouts.add(Workout(name: name, exercises: []));
    notifyListeners();
    _db.save(workouts);
  }

  void addExercise(String workoutName, Exercise exercise) {
    final workout = getWorkoutByName(workoutName);
    workout.exercises.add(exercise);
    notifyListeners();
    _db.save(workouts);
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    final workout = getWorkoutByName(workoutName);
    final exercise = getExerciseByName(exerciseName, workout);
    exercise.isCompleted = !exercise.isCompleted;
    notifyListeners();
    _db.save(workouts);
    loadHeatMap();
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

  String getStartDate() {
    return _db.getStartDate();
  }

  Map<DateTime, int> heatMapData = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (var i = 0; i < daysInBetween + 1; i++) {
      String date = dateToString(startDate.add(Duration(days: i)));
      int status = _db.getCompletetionStatus(date);
      int year = startDate.add(Duration(days: i)).year;
      int month = startDate.add(Duration(days: i)).month;
      int day = startDate.add(Duration(days: i)).day;
      final percent = <DateTime, int>{DateTime(year, month, day): status};
      heatMapData.addEntries(percent.entries);
    }
  }
}
