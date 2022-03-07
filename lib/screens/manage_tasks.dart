import 'package:flutter/material.dart';
import 'package:help_ukraine_dk/providers/task_provider.dart';
import 'package:provider/provider.dart';

class ManageTasks extends StatefulWidget {
  const ManageTasks({Key? key}) : super(key: key);

  static const route = '/manage-tasks';

  @override
  State<ManageTasks> createState() => _ManageTasksState();
}

class _ManageTasksState extends State<ManageTasks> {
  // date picker
  void _dayPicker() {
    showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              surface: Colors.black,
              onSurface: Colors.white70,
            ),
            dialogBackgroundColor: Colors.grey.shade900,
          ),
          child: child ?? const Text(''),
        );
      },
      context: context,
      initialDate: Provider.of<TaskProvider>(context, listen: false).date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    ).then((value) {
      if (value == null) {
        return;
      }
      Provider.of<TaskProvider>(context, listen: false).setDate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                  ),
                ),
                TextButton(
                  onPressed: () => _dayPicker(),
                  child: Text(
                    taskProvider.dateString,
                    style: const TextStyle(fontSize: 25, color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_circle_outline),
                      SizedBox(width: 10),
                      Text('Add new team'),
                    ],
                  ),
                  const Divider(),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Add team'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
