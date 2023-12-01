import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freaking_kitchen/cubit/states/search_by_ingredients_state.dart';
import 'package:freaking_kitchen/models/ingredient.dart';
import 'package:freaking_kitchen/searchers/api_searcher.dart';


class SearchByIngredientsCubit extends Cubit<SearchByIngredientsState> {

  SearchByIngredientsCubit() :
    super(SearchByIngredientsLoadingState());

  void loadIngredients() {
    emit(
        SearchByIngredientsLoadedState(
          ingredients: [],
          ingredientSearcher: ingredientSearcher,
        )
    );
    return;
  }

  void addIngredient(Ingredient ingredient) {
    if (state is SearchByIngredientsLoadedState) {
      List<Ingredient> ingredients = (state as SearchByIngredientsLoadedState).ingredients;
      ingredients.add(ingredient);
      emit(
          SearchByIngredientsLoadedState(
            ingredients: ingredients,
            ingredientSearcher: ingredientSearcher,
          )
      );
      return;
    }
  }

  void removeIngredient(Ingredient ingredient) {
    if (state is SearchByIngredientsLoadedState) {
      List<Ingredient> ingredients = (state as SearchByIngredientsLoadedState).ingredients;
      ingredients.remove(ingredient);
      emit(
        SearchByIngredientsLoadedState(
          ingredients: ingredients,
          ingredientSearcher: ingredientSearcher,
        )
      );
      return;
    }
  }

  IngredientSearcher get ingredientSearcher => IngredientSearcher(
      customSuggestionSelectedCallback: (context, suggestion) {
        Ingredient ingredient = suggestion as Ingredient;
        addIngredient(ingredient);
      }
  );
}