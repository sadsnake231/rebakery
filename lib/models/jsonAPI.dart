import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rebakery/models/recipe.dart';

class JsonAPI {

  static void writeToJson(Recipe item) async {
    String json = jsonEncode(item);
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    await file.writeAsString('$json\n', mode: FileMode.append);
  }

  static Future<List<Recipe>> loadFromJson() async{
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

  static void deleteInJson(int index) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    final List<String> lines = await file.readAsLines();
    lines.removeAt(index);
    await file.writeAsString(lines.join('\n'));
  }

  static void updateInJson (Recipe item, int index) async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.txt');
    final List<String> lines = await file.readAsLines();
    String json = jsonEncode(item);
    lines[index] = '$json\n';
    await file.writeAsString(lines.join('\n'));
  }
}