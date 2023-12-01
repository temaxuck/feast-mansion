
import '../../models/ingredient.dart';
import '../../searchers/api_searcher.dart';

abstract class SearchByIngredientsState {}

class SearchByIngredientsLoadingState extends SearchByIngredientsState {}

class SearchByIngredientsLoadedState extends SearchByIngredientsState {
  final List<Ingredient> ingredients;
  final IngredientSearcher ingredientSearcher;

  SearchByIngredientsLoadedState({
    required this.ingredients,
    required this.ingredientSearcher,
  });
}

class SearchByIngredientsErrorState extends SearchByIngredientsState {
  final String error;

  SearchByIngredientsErrorState({
    required this.error,
  });
}