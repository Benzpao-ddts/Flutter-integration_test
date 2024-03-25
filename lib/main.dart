import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  final todoController = TextEditingController();

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            onChanged: (value) {
              setState(() {
                tasks[index].isCompleted = value!;
              });
            },
            onDelete: () {
              setState(() {
                tasks.removeAt(index);
              });
            },
          );
        },
      ),
      
      floatingActionButton: Row(
        children: [
          const SizedBox(width: 32),
          Expanded(
            child: TextField(
              controller: todoController,
            ),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                tasks.add(Task(title: todoController.text));
              });
              todoController.clear();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}


class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?) onChanged;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: (task.isCompleted) ? TextDecoration.lineThrough : TextDecoration.none
        ),
      ),
      subtitle: task.description != null ? Text(task.description!) : null,
      leading: Checkbox(
        value: task.isCompleted,
        onChanged: onChanged,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}

class Task {
  final String title;
  final String? description;
  bool isCompleted;

  Task({required this.title, this.description, this.isCompleted = false});
}
