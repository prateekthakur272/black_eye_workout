import 'package:black_eye_workout/src/repository/workout_repository.dart';
import 'package:black_eye_workout/src/screens/workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Black Eye'),
      ),
      body: Consumer<WorkoutRepository>(
          builder: (context, value, child) => ListView.builder(
              itemCount: value.workouts.length,
              itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkoutScreen(
                                  name: value.workouts[index].name)));
                    },
                    title: Text(value.workouts[index].name),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWorkout,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createWorkout() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
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
                          'Create New Workout',
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
                              return 'Workout name is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              hintText: "Workout Name",
                              suffixIcon: Icon(FontAwesomeIcons.personRunning)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FilledButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Provider.of<WorkoutRepository>(context,
                                        listen: false)
                                    .addWorkout(nameController.text.trim());
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
