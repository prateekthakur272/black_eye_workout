import 'package:black_eye_workout/src/models/exercise.dart';
import 'package:black_eye_workout/src/repository/workout_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutScreen extends StatefulWidget {
  final String name;
  const WorkoutScreen({super.key, required this.name});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Consumer<WorkoutRepository>(
        builder: (context, value, child) {
          final exercises = value.getWorkoutByName(widget.name).exercises;
          return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: exercises[index].isCompleted,
                  title: Text(exercises[index].name),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(label: Text('${exercises[index].weight}kg')),
                      Chip(label: Text('${exercises[index].reps} reps')),
                      Chip(label: Text('${exercises[index].sets} sets'))
                    ],
                  ),
                  onChanged: ((value) {
                    _onChanged(exercises[index].name);
                  })));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createExercise,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onChanged(String name) {
    Provider.of<WorkoutRepository>(context, listen: false)
        .checkOffExercise(widget.name, name);
  }

  void _createExercise() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final weightController = TextEditingController();
    final repsController = TextEditingController();
    final setsController = TextEditingController();
    showModalBottomSheet(
        showDragHandle: true,
        useSafeArea: true,
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: const EdgeInsets.all(24),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Text(
                          'Create New Exercise',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Exercise name is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Exercise Name",
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: weightController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Weight is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "Weight",
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: repsController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Reps is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "No of Reps",
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: setsController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Sets is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: "No of Sets",
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Provider.of<WorkoutRepository>(context,
                                        listen: false)
                                    .addExercise(
                                        widget.name,
                                        Exercise(
                                            name: nameController.text.trim(),
                                            weight:
                                                weightController.text.trim(),
                                            reps: repsController.text.trim(),
                                            sets: setsController.text.trim(),
                                            isCompleted: false));
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add')),
                        const SizedBox(
                          height: 16,
                        ),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'))
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
