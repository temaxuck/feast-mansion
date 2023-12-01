import 'package:flutter/material.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/searchers/api_searcher.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/section.dart';
import 'package:freaking_kitchen/widgets/search_field.dart';
import 'package:freaking_kitchen/widgets/preferences_menu.dart';
import 'package:freaking_kitchen/widgets/find_recipes_button.dart';

class SearchByRecipeScreen extends StatefulWidget {
  const SearchByRecipeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchByRecipeScreenState();
}

class _SearchByRecipeScreenState extends State<SearchByRecipeScreen> {
  final RecipeSearcher recipeSearcher = RecipeSearcher();
  String userInput = "";

  void updateInput(String pattern) {
    setState(() {
      userInput = pattern;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Container(
        color: ColorsConfig.backgroundColor,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: SectionWithGap(
              gap: 25,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Welcome to the Feast Mansion!',
                    style: TextConfig.screenTitleTextStyle,
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: SectionWithGap(
                    children: [
                      const Text(
                        'You already know what you want to cook?',
                        style: TextConfig.screenSubtitleTextStyle,
                        textAlign: TextAlign.left,
                      ),
                      SearchField(
                        placeHolder: 'Search for recipes',
                        searchCallback: (pattern) {
                          Future.microtask(() => updateInput(pattern));
                          return recipeSearcher.search(pattern);
                        },
                        suggestionSelectedCallback: (context, suggestion) => recipeSearcher.suggestionSelectedCallback(context, suggestion),
                        searchController: recipeSearcher.searchController,
                        itemBuilder: (context, suggestion) => recipeSearcher.itemBuilder(context, suggestion),
                      )
                    ],
                  ),
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: const PreferencesMenu()
                ),
                Container(
                    alignment: Alignment.center,
                    child: FindRecipesButton(
                      recipeName: userInput,
                    )
                ),
              ]
          ),
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}
