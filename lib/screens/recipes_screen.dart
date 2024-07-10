import 'package:flutter/material.dart';
import 'package:rebakery/screens/recipe_item_screen.dart';
import 'empty_recipes_screen.dart';
import 'recipes_list_screen.dart';
import '../models/models.dart';
import '../models/recipe_tile.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>{
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
  }

  void _loadItems() async {
    /*List<Recipe> tempRecipes = [];
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/recipes.json');
    String? text = await file.readAsString();
    if(text != '') {
      List<String> strings = text.split('\n');
      for (final s in strings) {
        final recipeMap = jsonDecode(s) as Map<String, dynamic>;
        tempRecipes.add(Recipe.fromJson(recipeMap));
      }
    }
    */
    var temp_recipes = await JsonAPI.loadRecipeFromJson();
    setState(() {
      _recipes = temp_recipes;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeItemScreen(
                    onCreate: (item) {
                      JsonAPI.writeRecipeToJson(item);
                      Navigator.pop(context);
                    },
                    onUpdate: (item) {}
                  ),
              ),
          );
        }
      ),
      body: buildRecipesScreen(),
    );
  }

  Widget buildRecipesScreen() {
    _loadItems();
    /*if (_recipes.isNotEmpty) {
      return RecipesListScreen(recipes: _recipes);
    } else {
      return const EmptyRecipesScreen();
      }

    */

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.separated(
        itemCount: _recipes.length,
        itemBuilder: (context, index) {
          final item = _recipes[index];
          return Dismissible(
            key: Key(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete_forever,
                    color: Colors.white, size: 50.0)),
            onDismissed: (direction) {
              _recipes.removeAt(index);
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