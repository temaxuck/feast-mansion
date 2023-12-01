import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freaking_kitchen/api/recipe_api.dart';
import 'package:freaking_kitchen/config/app_config.dart';
import 'package:freaking_kitchen/cubit/states/recipe_screen_state.dart';

import '../models/recipe.dart';
import '../repositories/recipe_repository.dart';

class RecipeCubit extends Cubit<RecipeScreenState> {
  Recipe recipe;
  RecipeApi? api;
  late RecipeRepository recipeRepository;

  RecipeCubit({
    required this.recipe,
    this.api,
  }) :
    recipeRepository = ApiRecipeRepository(api: api ?? SpoonacularApi(AppConfig.SPOONACULAR_API_URL!)),
    super(RecipeLoadingState());

  Future<void> loadRecipe() async {
    try {
      recipe = await recipeRepository.getRecipeDetails(recipe);
      await recipeRepository.addRecipeHistory(recipe);
      emit(
        RecipeIngredientsState(recipe: recipe)
      );
      return;
    } catch (e) {
      emit(RecipeErrorState(error: e.toString()));
      return;
    }
  }

  void switchToRecipeIngredients() {
    emit(RecipeIngredientsState(recipe: recipe));
    return;
  }

  void switchToRecipeSteps() {
    emit(RecipeStepsState(recipe: recipe));
    return;
  }

  void switchToRecipeAbout() {
    emit(RecipeAboutState(recipe: recipe));
    return;
  }

}