import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freaking_kitchen/cubit/states/preference_item_state.dart';
import 'package:freaking_kitchen/models/ingredient.dart';
import 'package:freaking_kitchen/repositories/user_preferences_repository.dart';
import 'package:freaking_kitchen/searchers/api_searcher.dart';

import '../models/equipment.dart';

class PreferenceItemsCubit extends Cubit<PreferenceItemsState> {
  UserPreferencesRepository userPreferencesRepository;

  PreferenceItemsCubit() :
    userPreferencesRepository = SPUserPreferencesRepository(),
    super(PreferenceItemsLoadingState());

  Future<void> loadExcludeIngredients() async {
    try {
      List<Ingredient>? excludeIngredients = await userPreferencesRepository.getExcludeIngredients();
      emit(
        ExcludeIngredientsLoadedState(
          preferences: excludeIngredients,
          searcher: _excludeIngredientsSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> addExcludeIngredient(Ingredient excludeIngredient) async {
    try {
      await userPreferencesRepository.addExcludeIngredient(excludeIngredient);
      List<Ingredient>? excludeIngredients = await userPreferencesRepository.getExcludeIngredients();
      emit(
        ExcludeIngredientsLoadedState(
          preferences: excludeIngredients,
          searcher: _excludeIngredientsSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> removeExcludeIngredient(Ingredient excludeIngredient) async {
    try {
      await userPreferencesRepository.removeExcludeIngredient(excludeIngredient);
      List<Ingredient>? excludeIngredients = await userPreferencesRepository.getExcludeIngredients();
      emit(
        ExcludeIngredientsLoadedState(
          preferences: excludeIngredients,
          searcher: _excludeIngredientsSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  IngredientSearcher get _excludeIngredientsSearcher => IngredientSearcher(
    customSuggestionSelectedCallback: (context, suggestion) {
      Ingredient excludeIngredient = suggestion as Ingredient;
      addExcludeIngredient(excludeIngredient);
    }
  );

  Future<void> loadIntolerances() async {
    try {
      List<Ingredient>? intolerances = await userPreferencesRepository.getIntolerances();
      emit(
        IntolerancesLoadedState(
          preferences: intolerances,
          searcher: _intolerancesSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> addIntolerance(Ingredient intolerance) async {
    try {
      await userPreferencesRepository.addIntolerance(intolerance);
      List<Ingredient>? intolerances = await userPreferencesRepository.getIntolerances();
      emit(
        IntolerancesLoadedState(
          preferences: intolerances,
          searcher: _intolerancesSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> removeIntolerance(Ingredient intolerance) async {
    try {
      await userPreferencesRepository.removeIntolerance(intolerance);
      List<Ingredient>? intolerances = await userPreferencesRepository.getIntolerances();
      emit(
        IntolerancesLoadedState(
          preferences: intolerances,
          searcher: _intolerancesSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  IngredientSearcher get _intolerancesSearcher => IngredientSearcher(
      customSuggestionSelectedCallback: (context, suggestion) {
        Ingredient intolerance = suggestion as Ingredient;
        addIntolerance(intolerance);
      }
  );

  Future<void> loadEquipment() async {
    try {
      List<Equipment>? equipment = await userPreferencesRepository.getEquipment();
      emit(
        EquipmentLoadedState(
          preferences: equipment,
          searcher: _equipmentSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> addEquipment(Equipment equipmentPiece) async {
    try {
      await userPreferencesRepository.addEquipment(equipmentPiece);
      List<Equipment>? equipment = await userPreferencesRepository.getEquipment();
      emit(
        EquipmentLoadedState(
          preferences: equipment,
          searcher: _equipmentSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  Future<void> removeEquipment(Equipment equipmentPiece) async {
    try {
      await userPreferencesRepository.removeEquipment(equipmentPiece);
      List<Equipment>? equipment = await userPreferencesRepository.getEquipment();
      emit(
        EquipmentLoadedState(
          preferences: equipment,
          searcher: _equipmentSearcher
        )
      );
      return;
    } catch (e) {
      emit(PreferenceItemsErrorState(error: e.toString()));
      return;
    }
  }

  EquipmentSearcher get _equipmentSearcher => EquipmentSearcher(
      customSuggestionSelectedCallback: (context, suggestion) {
        Equipment equipmentPiece = suggestion as Equipment;
        addEquipment(equipmentPiece);
      }
  );

}