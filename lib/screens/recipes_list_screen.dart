import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/recipe_tile.dart';
import '../models/models.dart';
import 'recipe_item_screen.dart';

class RecipesListScreen extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipesListScreen({
    super.key,
    required this.recipes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final item = recipes[index];
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete_forever,
                    color: Colors.white, size: 50.0)),
            onDismissed: (direction) {
              recipes.removeAt(index);
              JsonAPI.deleteRecipeInJson(index);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Рецепт удален!')));
            },
            child: InkWell(
              child: RecipeTile(
                  key: Key(item.id),
                  recipe: item,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeItemScreen(
                      originalItem: item,
                      onUpdate: (item) {
                        JsonAPI.updateRecipeInJson(item, index);
                        Navigator.pop(context);
                      },
                      onCreate: (item) {
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16.0);
        },
      ),
    );
  }
}