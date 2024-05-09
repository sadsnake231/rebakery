import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'models/recipe_manager.dart';
import 'screens/home_screen.dart';
import 'models/tab_manager.dart';

void main() {
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
  runApp(const Rebakery());
}
class Rebakery extends StatelessWidget {
// 2
  const Rebakery({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Create theme
    // TODO: Apply Home widget
    // 3
    return MaterialApp(
      // TODO: Add theme
      title: 'Rebakery',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TabManager()),
          ChangeNotifierProvider(create: (context) => RecipeManager()),
        ],
        child: const Home()
      ),
    );
    }
}