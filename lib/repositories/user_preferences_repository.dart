import 'dart:convert';

import 'package:freaking_kitchen/models/equipment.dart';
import 'package:freaking_kitchen/models/ingredient.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserPreferencesRepository {
  UserPreferencesRepository();

  Future<String?> getDiet();
  Future<String?> getCuisine();
  Future<List<Ingredient>?> getExcludeIngredients();
  Future<List<Ingredient>?> getIntolerances();
  Future<List<Equipment>?> getEquipment();
  Future<void> setDiet(String diet);
  Future<void> setCuisine(String cuisine);
  Future<void> setExcludeIngredients(List<Ingredient> excludeIngredients);
  Future<void> setIntolerances(List<Ingredient> intolerances);
  Future<void> setEquipment(List<Equipment> equipment);
  Future<void> addExcludeIngredient(Ingredient excludeIngredient);
  Future<void> addIntolerance(Ingredient intolerance);
  Future<void> addEquipment(Equipment equipmentPiece);
  Future<void> removeExcludeIngredient(Ingredient excludeIngredient);
  Future<void> removeIntolerance(Ingredient intolerance);
  Future<void> removeEquipment(Equipment equipmentPiece);


  List<String> getAllDiets();
  List<String> getAllCuisines();

  Future<Map<String, dynamic>> getUserPreferences();

}

// User Preferences Repository that fetches data from Shared Preferences storage
class SPUserPreferencesRepository extends UserPreferencesRepository {

  @override
  Future<String?> getDiet() async {
    final prefs = await SharedPreferences.getInstance();
    final String? diet = prefs.getString('diet');

    return diet;
  }

  @override
  Future<void> setDiet(String diet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diet', diet);
  }

  @override
  Future<String?> getCuisine() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cuisine = prefs.getString('cuisine');

    return cuisine;
  }

  @override
  Future<void> setCuisine(String cuisine) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cuisine', cuisine);
  }

  @override
  Future<List<Ingredient>?> getExcludeIngredients() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? excludeIngredientsJson = prefs.getStringList('excludeIngredients');

    final List<Ingredient>? excludeIngredients =
    excludeIngredientsJson?.map(
            (jsonString) => Ingredient.fromJson(jsonDecode(jsonString))
    ).toList();

    return excludeIngredients ?? [];
  }

  @override
  Future<void> setExcludeIngredients(List<Ingredient> excludeIngredients) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'excludeIngredients',
      excludeIngredients.toSet().map(
        (ingredient) => jsonEncode(ingredient.toJson())
      ).toList()
    );
  }

  @override
  Future<void> addExcludeIngredient(Ingredient excludeIngredient) async {
    final excludeIngredients = await getExcludeIngredients();
    excludeIngredients?.add(excludeIngredient);
    await setExcludeIngredients(excludeIngredients!);
  }

  @override
  Future<void> removeExcludeIngredient(Ingredient excludeIngredient) async {
    final excludeIngredients = await getExcludeIngredients();
    excludeIngredients?.remove(excludeIngredient);
    await setExcludeIngredients(excludeIngredients!);

  }


  @override
  Future<List<Ingredient>?> getIntolerances() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? intolerancesJson = prefs.getStringList('intolerances');
    final List<Ingredient>? intolerances =
    intolerancesJson?.map(
      (jsonString) => Ingredient.fromJson(jsonDecode(jsonString))
    ).toList();

    return intolerances ?? [];
  }

  @override
  Future<void> setIntolerances(List<Ingredient> intolerances) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'intolerances',
      intolerances.toSet().map(
        (ingredient) => jsonEncode(ingredient.toJson())
      ).toList()
    );
  }

  @override
  Future<void> addIntolerance(Ingredient intolerance) async {
    final intolerances = await getIntolerances();
    intolerances?.add(intolerance);
    await setIntolerances(intolerances!);
  }

  @override
  Future<void> removeIntolerance(Ingredient intolerance) async {
    final intolerances = await getIntolerances();
    await setIntolerances(intolerances!.where((element) => (element.name != intolerance.name)).toList());
  }

  @override
  Future<List<Equipment>?> getEquipment() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? equipmentJson = prefs.getStringList('equipment');
    final List<Equipment>? equipment =
      equipmentJson?.map(
        (jsonString) => Equipment.fromJson(jsonDecode(jsonString))
      ).toList();


    return equipment ?? [];
  }

  @override
  Future<void> setEquipment(List<Equipment> equipment) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'equipment',
      equipment.toSet().map(
        (equipment) => jsonEncode(equipment.toJson())
      ).toList()
    );
  }

  @override
  Future<void> addEquipment(Equipment equipmentPiece) async {
    final equipment = await getEquipment();
    equipment?.add(equipmentPiece);
    setEquipment(equipment!);
  }

  @override
  Future<void> removeEquipment(Equipment equipmentPiece) async {
    final equipment = await getEquipment();
    await setEquipment(equipment!.where((element) => (element.name != equipmentPiece.name)).toList());
  }

  @override
  Future<Map<String, dynamic>> getUserPreferences() async {
    Map<String, dynamic> preferences = {};

    preferences['diet'] = await getDiet();
    preferences['cuisine'] = await getCuisine();
    preferences['excludeIngredients'] = await getExcludeIngredients();
    preferences['intolerances'] = await getIntolerances();
    preferences['equipment'] = await getEquipment();

    return preferences;
  }

  @override
  List<String> getAllDiets() {
    return [
      "None",
      "Gluten Free",
      "Ketogenic",
      "Vegetarian",
      "Lacto-Vegetarian",
      "Ovo-Vegetarian",
      "Vegan",
      "Pescetarian",
      "Paleo",
      "Primal",
      "Low FODMAP",
      "Whole30",
    ];
  }

  @override
  List<String> getAllCuisines() {
    return [
      "All",
      "African",
      "Asian",
      "American",
      "British",
      "Cajun",
      "Caribbean",
      "Chinese",
      "Eastern European",
      "European",
      "French",
      "German",
      "Greek",
      "Indian",
      "Irish",
      "Italian",
      "Japanese",
      "Jewish",
      "Korean",
      "Latin American",
      "Mediterranean",
      "Mexican",
      "Middle Eastern",
      "Nordic",
      "Southern",
      "Spanish",
      "Thai",
      "Vietnamese",
    ];
  }
}