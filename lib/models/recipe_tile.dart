import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'recipe.dart';

class RecipeTile extends StatelessWidget {
  final Recipe recipe;

  RecipeTile({
    super.key,
    required this.recipe,
  });


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                color: type_to_color(recipe.type),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: GoogleFonts.lato(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  buildType(),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Text type_to_text(Type type){
    switch (type){
      case Type.pie:
        return Text(
            'Пирог',
            style: GoogleFonts.lato(),
        );
      case Type.small_pie:
        return Text(
          'Пирожок',
          style: GoogleFonts.lato(),
        );
      case Type.cupcake:
        return Text(
          'Кекс',
          style: GoogleFonts.lato(),
        );
      case Type.shortbread_pie:
        return Text(
          'Пирог из песочного теста',
          style: GoogleFonts.lato(),
        );
      case Type.pancake:
        return Text(
          'Блин',
          style: GoogleFonts.lato(),
        );
      case Type.osetin_pie:
        return Text(
          'Осетинский пирог',
          style: GoogleFonts.lato(),
        );
    }
  }
  Color type_to_color(Type type){
    switch (type){
      case Type.pie:
        return Colors.orange.shade900;
      case Type.small_pie:
        return Colors.orange.shade400;
      case Type.cupcake:
        return Colors.brown.shade800;
      case Type.shortbread_pie:
        return Colors.yellowAccent;
      case Type.pancake:
        return Colors.amber.shade200;
      case Type.osetin_pie:
        return Colors.grey;
    }
  }
  Widget buildType() {
    return type_to_text(recipe.type);
  }
}
