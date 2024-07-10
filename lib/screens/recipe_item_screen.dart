import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class RecipeItemScreen extends StatefulWidget {
  final Function(Recipe) onCreate;
  final Function(Recipe) onUpdate;
  final Recipe? originalItem;
  final bool isUpdating;

  const RecipeItemScreen({
    super.key,
    required this.onCreate,
    required this.onUpdate,
    this.originalItem,
  })  : isUpdating = (originalItem != null);

  @override
  RecipeItemScreenState createState() => RecipeItemScreenState();
}

class RecipeItemScreenState extends State<RecipeItemScreen>{
  final _nameController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _cookingController = TextEditingController();
  String _name = '';
  Type _type = Type.pie;
  String _ingredients = '';
  String _cooking = '';

  @override
  void initState() {
    super.initState();
    final originalItem = widget.originalItem;
    if (originalItem != null) {
      _nameController.text = originalItem.name;
      _ingredientsController.text = originalItem.ingredients;
      _cookingController.text = originalItem.cooking;
      _name = originalItem.name;
      _type = originalItem.type;
      _ingredients = originalItem.ingredients;
      _cooking = originalItem.cooking;
    }

    _nameController.addListener(() {
      setState(() {
        _name = _nameController.text;
      });
    });

    _ingredientsController.addListener(() {
      setState(() {
        _ingredients = _ingredientsController.text;
      });
    });

    _cookingController.addListener(() {
      setState(() {
        _cooking = _cookingController.text;
      });
    });
  }

  @override
  void dispose(){
    _nameController.dispose();
    _cookingController.dispose();
    _ingredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              final recipe = Recipe(
                id: widget.originalItem?.id ?? const Uuid().v1(),
                name: _nameController.text,
                type: _type,
                ingredients: _ingredientsController.text,
                cooking: _cookingController.text,
                );
              if (widget.isUpdating){
                widget.onUpdate(recipe);
              } else {
                JsonAPI.writeRecipeToJson(recipe);
                widget.onCreate(recipe);
              }
              },
          )
        ],
        elevation: 0,
        title: Text(
          'Новый рецепт',
          style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildTextField(),
            buildTypeField(),
          ],
        ),
      ),
    );
  }
  Widget buildTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Название изделия',
          style: GoogleFonts.lato(fontSize: 24),
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Пирожок с мясом, Осетинский пирог, ...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        Text(
          'Ингредиенты',
          style: GoogleFonts.lato(fontSize: 24),
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _ingredientsController,
          decoration: InputDecoration(
            hintText: '2 яйца, 100 гр сахара, ...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        Text(
          'Процесс приготовления',
          style: GoogleFonts.lato(fontSize: 24),
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _cookingController,
          decoration: InputDecoration(
            hintText: 'Разбить яйца, добавить сахар, размешать, ...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

    Widget buildTypeField() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вид изделия',
            style: GoogleFonts.lato(fontSize: 24),
          ),
          Wrap(
            spacing: 10.0,
            children: [
              ChoiceChip(
                  selectedColor: Colors.amber.shade100,
                  selected: _type == Type.pie,
                  label: const Text(
                    'Пирог',
                  ),
                  onSelected: (selected) {
                    setState(() => _type = Type.pie);
                  },
              ),
              ChoiceChip(
                selectedColor: Colors.amber.shade100,
                selected: _type == Type.small_pie,
                label: const Text(
                  'Пирожок',
                ),
                onSelected: (selected) {
                  setState(() => _type = Type.small_pie);
                },
              ),
              ChoiceChip(
                selectedColor: Colors.amber.shade100,
                selected: _type == Type.cupcake,
                label: const Text(
                  'Кекс',
                ),
                onSelected: (selected) {
                  setState(() => _type = Type.cupcake);
                },
              ),
              ChoiceChip(
                selectedColor: Colors.amber.shade100,
                selected: _type == Type.shortbread_pie,
                label: const Text(
                  'Пирог из песочного теста',
                ),
                onSelected: (selected) {
                  setState(() => _type = Type.shortbread_pie);
                },
              ),
              ChoiceChip(
                selectedColor: Colors.amber.shade100,
                selected: _type == Type.pancake,
                label: const Text(
                  'Блин',
                ),
                onSelected: (selected) {
                  setState(() => _type = Type.pancake);
                },
              ),
              ChoiceChip(
                selectedColor: Colors.amber.shade100,
                selected: _type == Type.osetin_pie,
                label: const Text(
                  'Осетинский пирог',
                ),
                onSelected: (selected) {
                  setState(() => _type = Type.osetin_pie);
                },
              ),
            ]
          )
        ],
      );
    }
}

