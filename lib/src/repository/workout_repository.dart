import 'package:black_eye_workout/src/models/exercise.dart';
import 'package:black_eye_workout/src/models/workout.dart';

class WorkoutRepository {
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

  static List<Workout> get workouts => _workouts;

  static void addWorkout(String name) {
    _workouts.add(Workout(name: name, exercises: []));
  }

  static void addExercise(String workoutName, Exercise exercise) {
    final workout = getWorkoutByName(workoutName);
    workout.exercises.add(exercise);
  }

  static void checkOffExercise(String workoutName, String exerciseName) {
    final workout = getWorkoutByName(workoutName);
    final exercise = getExerciseByName(exerciseName, workout);
    exercise.isCompleted = !exercise.isCompleted;
  }

  static int numberOfExerciseInWorkout(String workoutName) {
    return getWorkoutByName(workoutName).exercises.length;
  }

  static Workout getWorkoutByName(String name) {
    return _workouts.firstWhere((element) => element.name == name);
  }

  static Exercise getExerciseByName(String exerciseName, Workout workout) {
    return workout.exercises
        .firstWhere((element) => element.name == exerciseName);
  }
}
