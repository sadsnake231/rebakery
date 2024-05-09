// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recipe _$RecipeFromJson(Map<String, dynamic> json) => Recipe(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TypeEnumMap, json['type']),
      ingredients: json['ingredients'] as String,
      cooking: json['cooking'] as String,
    );

Map<String, dynamic> _$RecipeToJson(Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$TypeEnumMap[instance.type]!,
      'name': instance.name,
      'ingredients': instance.ingredients,
      'cooking': instance.cooking,
    };

const _$TypeEnumMap = {
  Type.pie: 'pie',
  Type.small_pie: 'small_pie',
  Type.cupcake: 'cupcake',
  Type.shortbread_pie: 'shortbread_pie',
  Type.pancake: 'pancake',
  Type.osetin_pie: 'osetin_pie',
};
