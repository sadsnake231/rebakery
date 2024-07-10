import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recipe_tile_for_tasks.dart';
import '../models/models.dart';
import 'tasks_screen.dart'; // Импортируем TasksScreen

class TaskItemScreen extends StatefulWidget {
  @override
  _TaskItemScreenState createState() => _TaskItemScreenState();
}

class _TaskItemScreenState extends State<TaskItemScreen> {
  List<Recipe> recipes = [];
  List<Recipe> checked_recipes = [];
  List<bool> indicators = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    var temp_recipes = await JsonAPI.loadRecipeFromJson();
    setState(() {
      recipes = temp_recipes;
      indicators = List<bool>.filled(temp_recipes.length, false); // Инициализация индикаторов
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _saveTask() async {
    final task = Task(dueDate: selectedDate, recipes: checked_recipes);
    await JsonAPI.saveTask(task);
    _showSnackBar('Задание сохранено');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TasksScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание задания'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveTask,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'До какого времени нужно его выполнить?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _selectTime(context),
                  child: Text(DateFormat('HH:mm').format(selectedDate)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Добавьте рецепт в задание, нажав на него',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: buildRecipes(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecipes() {
    return ListView.separated(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final item = recipes[index];
        final isChecked = indicators[index];

        return InkWell(
          child: Stack(
            children: [
              RecipeTileForTasks(
                key: Key(item.id),
                recipe: item,
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  color: isChecked ? Colors.green : Colors.transparent,
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              if (isChecked) {
                checked_recipes.remove(item);
                indicators[index] = false;
                _showSnackBar('Рецепт удален');
              } else {
                checked_recipes.add(item);
                indicators[index] = true;
                _showSnackBar('Рецепт добавлен');
              }
            });
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }
}
