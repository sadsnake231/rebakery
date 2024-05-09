import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rebakery/models/models.dart';
import 'recipe.dart';

class RecipeManager extends ChangeNotifier {
  var _recipeItems = <Recipe>[];
  List<Recipe> get recipeItems => List.unmodifiable(_recipeItems);

  void deleteItem(int index) {
    _recipeItems.removeAt(index);
    notifyListeners();
  }

  void uploadItem(Recipe item) {
    String json = jsonEncode(item);
    writeToJson(json);
    notifyListeners();
  }

  void updateItem(Recipe item, int index) {
    _recipeItems[index] = item;
    notifyListeners();
  }

  void writeToJson(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.json');
    await file.writeAsString('$text\n', mode: FileMode.append);
  }

  Future<void> loadItems() async{
    String? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/recipes.json');
      text = await file.readAsString();
      if(text != '') {
        List<String> strings = text.split('\n');
        for (final s in strings) {
          final recipeMap = jsonDecode(s) as Map<String, dynamic>;
          _recipeItems.add(Recipe.fromJson(recipeMap));
        }
      }
    } catch (e) {}
  }

}
