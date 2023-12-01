import 'package:flutter/material.dart';

import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/config/app_config.dart';
import 'package:freaking_kitchen/screens/recipe_screen.dart';

import 'package:freaking_kitchen/searchers/searcher.dart';

import 'package:freaking_kitchen/api/recipe_api.dart';
import 'package:freaking_kitchen/models/recipe.dart';
import 'package:freaking_kitchen/models/ingredient.dart';
import 'package:freaking_kitchen/repositories/recipe_repository.dart';
import 'package:freaking_kitchen/repositories/user_preferences_repository.dart';

import 'package:freaking_kitchen/utils/string_extensions.dart';

import '../models/equipment.dart';

abstract class ApiSearcher extends Searcher {
  int count;
  RecipeApi? api;
  RecipeRepository recipeRepository;
  UserPreferencesRepository userPreferencesRepository;
  Function? customSuggestionSelectedCallback;

  ApiSearcher({
    this.count = 3,
    this.api,
    this.customSuggestionSelectedCallback
  }) :
      recipeRepository = ApiRecipeRepository(api: api ?? SpoonacularApi(AppConfig.SPOONACULAR_API_URL!)),
      userPreferencesRepository = SPUserPreferencesRepository(),
      super();
}

class RecipeSearcher extends ApiSearcher {

  RecipeSearcher({
    int count = 3,
    RecipeApi? api,
    Function? customSuggestionSelectedCallback,
  }) : super(
    count: count,
    api: api,
    customSuggestionSelectedCallback: customSuggestionSelectedCallback,
  );

  @override
  Future<List<Recipe>> search(String pattern) async {
    // return [
    //   Recipe(
    //     title: "Borcsh",
    //     id: 635684,
    //     imageUrl: "https://spoonacular.com/recipeImages/635684-312x231.jpg",
    //   ),
    // ];

    if (pattern != '') {
      List<Ingredient> ingredients = [];
      Map<String, dynamic> preferences = await userPreferencesRepository.getUserPreferences();
      searchController.text = pattern;
      return await recipeRepository.getRecipes(pattern, ingredients, preferences, count: count, fullRecipeInfo: false);
    }
    return [];
  }


  @override
  Widget itemBuilder(BuildContext context, dynamic suggestion) {
    Recipe recipe = suggestion as Recipe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child:
      ListTile(
          leading: Container(
            constraints: const BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
            ),
            child: Image.network(recipe.imageUrl ?? '', fit: BoxFit.fitWidth,),
          ),
          title: Text(recipe.title?.capitalize() ?? 'No data', style: TextConfig.bodyTextStyle)
      ),
    );
  }

  @override
  void suggestionSelectedCallback(BuildContext context, dynamic suggestion) {
    if (customSuggestionSelectedCallback != null) {
      customSuggestionSelectedCallback!(context, suggestion);
    } else {
      Recipe recipe = suggestion as Recipe;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RecipeScreen(
              recipe: recipe
            )
        ),
      );
    }
  }
}

class IngredientSearcher extends ApiSearcher {

  IngredientSearcher({
    int count = 3,
    RecipeApi? api,
    Function? customSuggestionSelectedCallback,
  }) : super(
    count: count,
    api: api,
    customSuggestionSelectedCallback: customSuggestionSelectedCallback,
  );


  @override
  Future<List<Ingredient>> search(String pattern) async {
    if (pattern != '') {
      Map<String, dynamic> preferences = await userPreferencesRepository.getUserPreferences();
      return await recipeRepository.getIngredients(pattern, preferences, count: count,);
    }
    return [];
  }


  @override
  itemBuilder(context, suggestion) {
    Ingredient ingredient = suggestion as Ingredient;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
          leading: Container(
            constraints: const BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
            ),
            child: Image.network(ingredient.imageUrl ?? '', fit: BoxFit.fitWidth,),
          ),
          title: Text(ingredient.name?.toSentenceCase() ?? 'No data', style: TextConfig.bodyTextStyle,)
      ),
    );
  }

  @override
  suggestionSelectedCallback(BuildContext context, suggestion) {
    if (customSuggestionSelectedCallback != null) {
      customSuggestionSelectedCallback!(context, suggestion);
    } else {
      Ingredient ingredient = suggestion as Ingredient;
      searchController.text = ingredient.name!;
    }
  }
}

class EquipmentSearcher extends ApiSearcher {

  EquipmentSearcher({
    int count = 3,
    RecipeApi? api,
    Function? customSuggestionSelectedCallback,
  }) : super(
    count: count,
    api: api,
    customSuggestionSelectedCallback: customSuggestionSelectedCallback,
  );


  @override
  Future<List<Equipment>> search(String pattern) async {
    if (pattern != '') {
      return await recipeRepository.getEquipment(pattern.toLowerCase(), count: count,);
    }
    return [];
  }


  @override
  itemBuilder(context, suggestion) {
    Equipment equipment = suggestion as Equipment;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ListTile(
          leading: Container(
            constraints: const BoxConstraints(
              maxWidth: 50,
              minWidth: 50,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
            ),
            child: Image.network(equipment.imageUrl ?? '', fit: BoxFit.fitWidth,),
          ),
          title: Text(equipment.name?.toSentenceCase() ?? 'No data', style: TextConfig.bodyTextStyle,)
      ),
    );
  }

  @override
  suggestionSelectedCallback(BuildContext context, suggestion) {
    if (customSuggestionSelectedCallback != null) {
      customSuggestionSelectedCallback!(context, suggestion);
    } else {
      Ingredient equipment = suggestion as Ingredient;
      searchController.text = equipment.name!;
    }
  }
}