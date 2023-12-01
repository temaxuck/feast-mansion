import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freaking_kitchen/api/recipe_api.dart';
import 'package:freaking_kitchen/config/app_config.dart';
import 'package:freaking_kitchen/cubit/states/history_screen_state.dart';
import 'package:freaking_kitchen/repositories/recipe_repository.dart';

import '../models/recipe.dart';

class HistoryScreenCubit extends Cubit<HistoryScreenState> {
  RecipeApi? api;
  RecipeRepository recipeRepository;

  HistoryScreenCubit({
    this.api
  }) :
        recipeRepository = ApiRecipeRepository(api: api ?? SpoonacularApi(AppConfig.SPOONACULAR_API_URL!)),
        super(HistoryScreenLoadingState());

  Future<void> loadRecipes() async {
    try {
      List<Recipe>? recipes = await recipeRepository.getRecipeHistory();
      emit(
          HistoryScreenLoadedState(recipes: recipes)
      );
      return;
    } catch (e) {
      emit(HistoryScreenErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> addRecipe(Recipe recipe) async {
    try {
      await recipeRepository.addRecipeHistory(recipe);
      List<Recipe> recipes = await recipeRepository.getRecipeHistory();
      emit(
          HistoryScreenLoadedState(recipes: recipes)
      );
      return;
    } catch (e) {
      emit(HistoryScreenErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> removeRecipe(Recipe recipe) async {
    try {
      await recipeRepository.removeRecipeHistory(recipe);
      List<Recipe> recipes = await recipeRepository.getRecipeHistory();
      emit(
          HistoryScreenLoadedState(recipes: recipes)
      );
      return;
    } catch (e) {
      emit(HistoryScreenErrorState(error: e.toString()));
      return;
    }
  }
}