import 'dart:convert';
import 'package:http/http.dart' as http;


import 'package:freaking_kitchen/models/ingredient.dart';

import 'package:freaking_kitchen/config/app_config.dart';

abstract class RecipeApi {
  final String baseUrl;

  RecipeApi(
    this.baseUrl,
  );

  Future<Map<String, dynamic>> getRecipes(
    String? recipeName,
    List<Ingredient>? ingredients,
    Map<String, dynamic>? preferences,
    {
      int count,
      bool fullRecipeInfo = false,
    }
  );

  Future<Map<String, dynamic>> getRecipeDetails(
    int recipeId,
  );

  Future<Map<String, dynamic>> getIngredients(
    String? ingredientName,
    Map<String, dynamic>? preferences,
    {
      int count,
    }
  );

  Future<Map<String, dynamic>> getEquipment(
    String? equipmentName,
    {
      int count,
    }
  );
}

class SpoonacularApi extends RecipeApi {
  SpoonacularApi(String baseUrl) : super(baseUrl);

  @override
  Future<Map<String, dynamic>> getRecipes(
    String? recipeName,
    List<Ingredient>? ingredients,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
      bool fullRecipeInfo = false,
    }
  ) async {
    final params = {
      "apiKey": AppConfig.SPOONACULAR_API_KEY,
      "diet": preferences?['diet'] == 'None' ? null : preferences?['diet'],
      "cuisines": preferences?['cuisine'] == 'All' ? null : preferences?['cuisine'],
      "excludeIngredients": preferences?['excludeIngredients']?.join(','),
      "intolerances": preferences?['intolerances']?.join(','),
      "equipment": preferences?['equipment']?.join(','),
      "number": count,
      "query": recipeName,
      "includeIngredients": ingredients?.map((ingredient) => ingredient.name).toList().join(','),
      "addRecipeInformation": fullRecipeInfo.toString(),
    };
    final uri = Uri.https(baseUrl, '/recipes/complexSearch', params.map((key, value) => MapEntry(key, value.toString())));
    // print(uri.toString());
    final response = await http.get(uri);
    // print("quota: ${response.headers['x-api-quota-left']}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  Future<Map<String, dynamic>> getRecipeDetails(int recipeId) async {
    final params = {
      "apiKey": AppConfig.SPOONACULAR_API_KEY,
    };
    final uri = Uri.https(baseUrl, '/recipes/$recipeId/information', params);
    final response = await http.get(uri);
    // print("quota: ${response.headers['x-api-quota-left']}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recipe with id $recipeId');
    }
  }

  @override
  Future<Map<String, dynamic>> getIngredients(
    String? ingredientName,
    Map<String, dynamic>? preferences,
    {
      int count = 10,
    }
  ) async {
    final params = {
      "apiKey": AppConfig.SPOONACULAR_API_KEY,
      "intolerances": preferences?['intolerances']?.join(','),
      "number": count,
      "query": ingredientName,
    };
    final uri = Uri.https(baseUrl, '/food/ingredients/search', params.map((key, value) => MapEntry(key, value.toString())));
    final response = await http.get(uri);
    // print("quota: ${response.headers['x-api-quota-left']}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }


  @override
  Future<Map<String, dynamic>> getEquipment(
    String? equipmentName,
    {
      int count = 10, // There's always one result for Spoonacular API
    }
  ) async {
    // There's no equipment endpoint for equipment search in Spoonacular api
    // So we trying to take image from "https://spoonacular.com/cdn/equipment_100x100/$equipmentName.jpg"
    // And if the Header "cf-cache-status" is "HIT" then the search is considered to be successful
    final uri = Uri.https('spoonacular.com', '/cdn/equipment_100x100/$equipmentName.png',); // Hardcode it for now
    final response = await http.get(uri);
    // print("quota: ${response.headers['x-api-quota-left']}");

    if (response.statusCode == 200) {
      if (response.headers['cf-cache-status'] == 'HIT') {
        return {
          "results": [
            {
              "name": equipmentName,
              "image": "https://spoonacular.com/cdn/equipment_100x100/$equipmentName.png"
            },
          ]
        };
      } else {
        return {
          "results": [],
        };
      }
    } else {
      throw Exception('Failed to load recipes');
    }
  }

}