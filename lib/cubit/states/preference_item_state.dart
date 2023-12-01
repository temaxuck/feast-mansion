import 'package:freaking_kitchen/models/preference.dart';
import 'package:freaking_kitchen/searchers/searcher.dart';

abstract class PreferenceItemsState {}

class PreferenceItemsLoadingState extends PreferenceItemsState {}

class PreferenceItemsErrorState extends PreferenceItemsState {
  final String error;

  PreferenceItemsErrorState({required this.error});
}

abstract class PreferenceItemsLoadedState extends PreferenceItemsState {
  final List<Preference>? preferences;
  final Searcher searcher;
  String get title => "";
  String get subTitle => "";
  String get searchFieldPlaceholder => "";
  String get preferencesItemsTitle => "";

  PreferenceItemsLoadedState({
    required this.preferences,
    required this.searcher
  });
}

class ExcludeIngredientsLoadedState extends PreferenceItemsLoadedState {
  @override
  String get title => "Exclude ingredients";
  @override
  String get subTitle => "... from recipe search, because you might not like them";
  @override
  String get searchFieldPlaceholder => "Search for ingredients";
  @override
  String get preferencesItemsTitle => "Exclude ingredients";

  ExcludeIngredientsLoadedState({
    required super.preferences,
    required super.searcher
  });
}

class IntolerancesLoadedState extends PreferenceItemsLoadedState {
  @override
  String get title => "Intolerances";
  @override
  String get subTitle => "The ingredients that make you feel sick 🤢";
  @override
  String get searchFieldPlaceholder => "Search for ingredients";
  @override
  String get preferencesItemsTitle => "Intolerances";

  IntolerancesLoadedState({
    required super.preferences,
    required super.searcher
  });
}

class EquipmentLoadedState extends PreferenceItemsLoadedState {
  @override
  String get title => "Equipment";
  @override
  String get subTitle => "Which equipment is by your hand?";
  @override
  String get searchFieldPlaceholder => "Search for equipment";
  @override
  String get preferencesItemsTitle => "Equipment";

  EquipmentLoadedState({
    required super.preferences,
    required super.searcher
  });
}

