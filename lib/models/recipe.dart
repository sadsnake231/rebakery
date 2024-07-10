import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'recipe.g.dart';

enum Type{
  pie,
  small_pie,
  cupcake,
  shortbread_pie,
  pancake,
  osetin_pie
}

@JsonSerializable()
class Recipe{
  final String id;
  final Type type;
  final String name;
  final String ingredients;
  final String cooking;
  Color color = Colors.transparent;

  Recipe({
    required this.id,
    required this.name,
    required this.type,
    required this.ingredients,
    required this.cooking
  });

  Recipe copyWith({
    String? id,
    String? name,
    Type? type,
    String? ingredients,
    String? cooking
  }){
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      ingredients: ingredients ?? this.ingredients,
      cooking: cooking ?? this.cooking
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeToJson(this);
}

