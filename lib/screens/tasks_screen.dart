import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'task_item_screen.dart';
import '../models/models.dart';
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> tasks = [];
  List<Task> overdueTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    var loadedTasks = await JsonAPI.loadTasks();
    var now = DateTime.now();
    setState(() {
      tasks = loadedTasks.where((task) => task.dueDate.isAfter(now)).toList();
      overdueTasks = loadedTasks.where((task) => task.dueDate.isBefore(now)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Задачи'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskItemScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Текущие задания',
              style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return _buildTaskItem(tasks[index]);
                },
              ),
            ),
            if (overdueTasks.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Задания с истекшим сроком',
                style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: overdueTasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskItem(overdueTasks[index]);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    String recipesText = task.recipes.map((recipe) => recipe.name).take(3).join(', ');
    String dueDateText = DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              recipesText,
              style: GoogleFonts.roboto(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 16),
          Text(
            dueDateText,
            style: GoogleFonts.roboto(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
