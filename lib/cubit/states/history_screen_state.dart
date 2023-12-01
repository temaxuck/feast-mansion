



import '../../models/recipe.dart';

abstract class HistoryScreenState {}

class HistoryScreenLoadingState extends HistoryScreenState {}

class HistoryScreenLoadedState extends HistoryScreenState {
  final List<Recipe> recipes;

  HistoryScreenLoadedState({
    required this.recipes,
  });
}

class HistoryScreenErrorState extends HistoryScreenState {
  final String error;

  HistoryScreenErrorState({
    required this.error,
  });
}