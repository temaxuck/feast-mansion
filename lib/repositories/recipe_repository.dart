import 'dart:convert';

import 'package:freaking_kitchen/models/recipe.dart';
import 'package:freaking_kitchen/models/ingredient.dart';

import 'package:freaking_kitchen/api/recipe_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/equipment.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes(
    String? recipeName,
    List<Ingredient>? ingredients,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
      bool fullRecipeInfo = false,
    }
  );

  Future<Recipe> getRecipeDetails(Recipe recipe);

  Future<List<Ingredient>> getIngredients(
    String? ingredientName,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
    }
  );

  Future<List<Equipment>> getEquipment(
    String? equipmentName,
    {
      int count = 10,
    }
  );

  Future<List<Recipe>> getRecipeHistory();
  Future<void> setRecipeHistory(List<Recipe>? recipes);
  Future<void> addRecipeHistory(Recipe recipe);
  Future<void> removeRecipeHistory(Recipe recipe);
}

class ApiRecipeRepository implements RecipeRepository {
  final RecipeApi api;

  ApiRecipeRepository({
    required this.api
  });

  @override
  Future<List<Recipe>> getRecipes(
    String? recipeName,
    List<Ingredient>? ingredients,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
      bool fullRecipeInfo = false,
    }
  ) async {
    final response = await api.getRecipes(
        recipeName,
        ingredients,
        preferences,
        count: count,
        fullRecipeInfo: fullRecipeInfo,
    );
    final result = response['results'].map<Recipe>((json) => Recipe.fromJson(json)).toList();
    return result;
  }

  @override
  Future<Recipe> getRecipeDetails(Recipe recipe) async {
    if (recipe.id == null) {
      throw Exception("getRecipeDetails: Recipe must have id");
    }

    final response = await api.getRecipeDetails(recipe.id!);
    final result = Recipe.fromJson(response);

    for (Ingredient ingredient in result.ingredients!) {
      ingredient.imageUrl = 'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.imageUrl}';
    }

    for (RecipeInstruction instruction in result.instructions!) {
      if (instruction.ingredients != null) {
        for (Ingredient ingredient in instruction.ingredients!) {
          if (ingredient.imageUrl != "" && ingredient.imageUrl != null) {
            ingredient.imageUrl = 'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.imageUrl}';
          } else {
            ingredient.imageUrl = null;
          }
        }
      }

      if (instruction.equipment != null) {
        for (Equipment equipment in instruction.equipment!) {
          if (equipment.imageUrl != "" && equipment.imageUrl != null) {
            equipment.imageUrl = 'https://spoonacular.com/cdn/equipment_100x100/${equipment.imageUrl}';
          } else {
            equipment.imageUrl = null;
          }
        }
      }
    }

    return result;
  }

  @override
  Future<List<Ingredient>> getIngredients(
    String? ingredientName,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
    }
  ) async {
    final response = await api.getIngredients(
      ingredientName,
      preferences,
      count: count,
    );
    List<Ingredient> result = response['results'].map<Ingredient>((json) => Ingredient.fromJson(json)).toList();

    for (Ingredient ingredient in result) {
      if (ingredient.imageUrl != "" && ingredient.imageUrl != null) {
        ingredient.imageUrl = 'https://spoonacular.com/cdn/ingredients_100x100/${ingredient.imageUrl}';
      } else {
        ingredient.imageUrl = null;
      }
    }
    return result;
  }


  @override
  Future<List<Equipment>> getEquipment(
    String? equipmentName,
    {
      int count = 10,
    }
  ) async {
    final response = await api.getEquipment(
      equipmentName,
      count: count,
    );

    return response['results'].map<Equipment>((json) =>
        Equipment.fromJson(json)).toList();
  }

  @override
  Future<List<Recipe>> getRecipeHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String>? recipesJson = prefs.getStringList("recipe_history");
    final List<Recipe>? recipes = recipesJson?.map<Recipe>(
      (recipeJson) => Recipe.fromJson(jsonDecode(recipeJson))
    ).toList();

    return recipes ?? [];
  }

  @override
  Future<void> setRecipeHistory(List<Recipe>? recipes) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("recipe_history", recipes != null ?
    recipes.toSet().map((recipe) => jsonEncode(recipe.toJson())).toList()
      : []
    );
  }

  @override
  Future<void> addRecipeHistory(Recipe recipe) async {
    final List<Recipe> recipes = await getRecipeHistory();
    recipes.add(recipe);

    await setRecipeHistory(recipes);
  }

  @override
  Future<void> removeRecipeHistory(Recipe recipe) async {
    final List<Recipe> recipes = await getRecipeHistory();
    recipes.remove(recipe);

    await setRecipeHistory(recipes);
  }
}