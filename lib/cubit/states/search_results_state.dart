import '../../models/recipe.dart';

abstract class SearchResultsState {}

class SearchResultsLoadingState extends SearchResultsState {}

class SearchResultsLoadedState extends SearchResultsState {
  final List<Recipe> recipes;

  SearchResultsLoadedState({
    required this.recipes,
  });
}

class SearchResultsErrorState extends SearchResultsState {
  final String error;

  SearchResultsErrorState({
    required this.error,
  });
}