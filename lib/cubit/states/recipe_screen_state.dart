import '../../models/recipe.dart';

abstract class RecipeScreenState {}

class RecipeLoadingState extends RecipeScreenState {}

class RecipeErrorState extends RecipeScreenState {
  final String error;

  RecipeErrorState({required this.error});
}

abstract class RecipeLoadedState extends RecipeScreenState {
  final Recipe? recipe;

  RecipeLoadedState({
    required this.recipe
  });
}

class RecipeIngredientsState extends RecipeLoadedState {
  RecipeIngredientsState({
    required super.recipe,
  });
}

class RecipeStepsState extends RecipeLoadedState {
  RecipeStepsState({
    required super.recipe,
  });
}

class RecipeAboutState extends RecipeLoadedState {
  RecipeAboutState({
    required super.recipe,
  });
}