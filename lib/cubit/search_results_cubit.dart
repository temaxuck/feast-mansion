import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freaking_kitchen/api/recipe_api.dart';
import 'package:freaking_kitchen/config/app_config.dart';
import 'package:freaking_kitchen/cubit/states/search_results_state.dart';
import 'package:freaking_kitchen/repositories/recipe_repository.dart';
import 'package:freaking_kitchen/repositories/user_preferences_repository.dart';

import '../models/ingredient.dart';
import '../models/recipe.dart';

class SearchResultsCubit extends Cubit<SearchResultsState> {
  RecipeApi? api;
  RecipeRepository recipeRepository;
  UserPreferencesRepository preferencesRepository;

  SearchResultsCubit({
    this.api
  }) :
    recipeRepository = ApiRecipeRepository(api: api ?? SpoonacularApi(AppConfig.SPOONACULAR_API_URL!)),
    preferencesRepository = SPUserPreferencesRepository(),
    super(SearchResultsLoadingState());

  Future<void> loadRecipes(
    String? recipeName,
    List<Ingredient>? ingredients
  ) async {
    try {
      Map<String, dynamic>? preferences = await preferencesRepository.getUserPreferences();
      List<Recipe>? recipes = await recipeRepository.getRecipes(recipeName ?? "", ingredients, preferences, fullRecipeInfo: true);
      emit(
        SearchResultsLoadedState(recipes: recipes)
      );
      return;
    } catch (e) {
      emit(SearchResultsErrorState(error: e.toString()));
      return;
    }
  }
}