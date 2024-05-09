import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Card1 extends StatelessWidget {
  const Card1({super.key});

// 1
  final String title = 'Домашняя страница. Скоро наполнится.';

// 2
  @override
  Widget build(BuildContext context) {
// 3
    return Center(
// TODO: Card1 Decorate Container
      child: Container(
        child: Text(
            title,
            style: GoogleFonts.openSans(fontSize: 32)),
      ),
    );
  }
}