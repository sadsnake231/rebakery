import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyRecipesScreen extends StatelessWidget{
  const EmptyRecipesScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //TODO: replaces
            Flexible(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: Image.asset('images/Recipe-PNG-Free-Image.png'),
                ),
            ),
            const SizedBox(height: 16.0),
            Text('Вы еще не создали ни одного рецепта',
                style: GoogleFonts.openSans(fontSize: 24),
                textAlign: TextAlign.center
            ),
            const SizedBox(height: 16.0),
            Text('Создайте новый, нажав на кнопку +',
                style: GoogleFonts.openSans(fontSize: 24),
                textAlign: TextAlign.center,
            )
           ],
        ),
      ),
    );
  }

}