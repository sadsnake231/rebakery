import 'package:flutter/material.dart';
import 'tasks_screen.dart';
import 'recipes_screen.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';

// 1
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}
class HomeState extends State<Home> {
  int _selectedIndex = 0;
  static List<Widget> pages = <Widget>[
    const TasksScreen(),
    const RecipesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabManager>(
        builder: (context, tabManager, child) {
          return Scaffold(
            body: pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book),
                  label: 'Recipes',
                ),
              ],
            ),
        );
      },
      );
  }

}
