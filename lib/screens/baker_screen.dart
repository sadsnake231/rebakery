import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recipe_tile.dart';
import 'task_item_screen.dart';
import 'recipe_detail_screen.dart'; // Импортируем RecipeDetailScreen
import '../models/models.dart';

class BakerScreen extends StatefulWidget {
  const BakerScreen({super.key});

  @override
  _BakerScreenState createState() => _BakerScreenState();
}

class _BakerScreenState extends State<BakerScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    var loadedTasks = await JsonAPI.loadTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  void _deleteTask(Task task) async {
    await JsonAPI.deleteTask(task);
    setState(() {
      tasks.remove(task);
    });
  }

  @override
  Widget build(BuildContext context) {
    final expiredTasks = tasks.where((task) => task.dueDate.isBefore(DateTime.now())).toList();
    final currentTasks = tasks.where((task) => task.dueDate.isAfter(DateTime.now())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Пекарь'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (currentTasks.isNotEmpty) ...currentTasks.map(_buildTaskItem).toList(),
            if (expiredTasks.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Задания с истекшим сроком',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ...expiredTasks.map(_buildTaskItem).toList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    bool isExpanded = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.recipes.map((recipe) => recipe.name).take(3).join(', '),
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.red),
                    onPressed: () {
                      _deleteTask(task);
                    },
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
            if (isExpanded)
              Column(
                children: task.recipes.map((recipe) {
                  return InkWell(
                    child: RecipeTile(recipe: recipe),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        );
      },
    );
  }
}
