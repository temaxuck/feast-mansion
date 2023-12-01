import 'package:flutter/material.dart';

import 'package:freaking_kitchen/screens/search_by_ingredients_screen.dart';
import 'package:freaking_kitchen/screens/search_by_recipe_screen.dart';

import 'package:freaking_kitchen/widgets/footer.dart';

import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
        },
        children: const <Widget>[
          SearchByRecipeScreen(),
          SearchByIngredientsScreen(),
          HistoryScreen(),
        ],
      ),
      bottomNavigationBar: Footer(
        selectedTabIndex: _currentScreenIndex,
        pageController: _pageController,
      ),
    );
  }
}