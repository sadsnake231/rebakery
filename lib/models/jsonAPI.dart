import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'models.dart';

class JsonAPI {

  static void writeRecipeToJson(Recipe item) async {
    String json = jsonEncode(item);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    await file.writeAsString('$json\n', mode: FileMode.append);
  }

  static Future<List<Recipe>> loadRecipeFromJson() async{
    List<Recipe> tempRecipes = [];
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    String? text = await file.readAsString();
    if (text != '') {
      List<String> strings = text.split('\n');
      for (final s in strings) {
        if(s != '') {
          final recipeMap = jsonDecode(s) as Map<String, dynamic>;
          tempRecipes.add(Recipe.fromJson(recipeMap));
        }
      }
    }
    return tempRecipes;
  }

  static void deleteRecipeInJson(int index) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    final List<String> lines = await file.readAsLines();
    lines.removeAt(index);
    await file.writeAsString(lines.join('\n'));
  }

  static void updateRecipeInJson (Recipe item, int index) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    final List<String> lines = await file.readAsLines();
    String json = jsonEncode(item);
    lines[index] = '$json\n';
    await file.writeAsString(lines.join('\n'));
  }

  static Future<void> saveTask(Task task) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.json');

    List<Task> tasks = [];
    if (file.existsSync()) {
      final tasksJson = await file.readAsString();
      final tasksList = jsonDecode(tasksJson) as List;
      tasks = tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
    }

    tasks.add(task);

    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await file.writeAsString(tasksJson);
  }

  static Future<List<Task>> loadTasks() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/tasks.json');

    if (file.existsSync()) {
      final tasksJson = await file.readAsString();
      final tasksList = jsonDecode(tasksJson) as List;
      return tasksList.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      return [];
    }
  }

  static Future<void> deleteTask(Task task) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks.json';
    final file = File(path);

    if (file.existsSync()) {
      final tasksJson = await file.readAsString();
      final List<dynamic> tasksList = json.decode(tasksJson);

      tasksList.removeWhere((t) {
        Task loadedTask = Task.fromJson(t);
        return loadedTask.dueDate == task.dueDate &&
            loadedTask.recipes.length == task.recipes.length &&
            loadedTask.recipes.every((recipe) =>
                task.recipes.any((r) => r.name == recipe.name));
      });

      await file.writeAsString(json.encode(tasksList));
    }
  }


}