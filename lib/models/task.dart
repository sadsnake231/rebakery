import 'models.dart';

class Task {
  final DateTime dueDate;
  final List<Recipe> recipes;

  Task({required this.dueDate, required this.recipes});

  Map<String, dynamic> toJson() {
    return {
      'dueDate': dueDate.toIso8601String(),
      'recipes': recipes.map((recipe) => recipe.toJson()).toList(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      dueDate: DateTime.parse(json['dueDate']),
      recipes: (json['recipes'] as List).map((recipeJson) => Recipe.fromJson(recipeJson)).toList(),
    );
  }
}






