import 'package:freaking_kitchen/models/equipment.dart';

import 'ingredient.dart';

class Recipe {
  int? id;
  String? title;
  int? totalCookingTime;
  String? imageUrl;
  String? description;
  List<RecipeInstruction>? instructions;
  List<Ingredient>? ingredients;

  Recipe({
    this.id,
    this.title,
    this.totalCookingTime,
    this.imageUrl,
    this.description,
    this.instructions,
    this.ingredients,
  });

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    totalCookingTime = json['readyInMinutes'];
    imageUrl = json['image'];
    description = json['summary'];

    if (!(json['analyzedInstructions'] ?? []).isEmpty) {
      if (json['analyzedInstructions'][0]['steps'] != null) {
        instructions = <RecipeInstruction>[];
        json['analyzedInstructions'][0]['steps'].forEach((v) {
          instructions!.add(RecipeInstruction.fromJson(v));
        });
      }
    }

    if (json['extendedIngredients'] != null) {
      ingredients = json['extendedIngredients'].map<Ingredient>(
        (ingredientJson) => Ingredient.fromJson(ingredientJson)
      ).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['id'] = id;
    json['title'] = title;
    json['readyInMinutes'] = totalCookingTime ;
    json['image'] = imageUrl;
    json['summary'] = description;
    json['analyzedInstructions'] = [
      {
        'steps': instructions != null ?
          instructions?.map((instruction) => instruction.toJson()).toList()
          : [],
      }
    ];
    json['extendedIngredients'] = ingredients != null ?
      ingredients?.map((ingredient) => ingredient.toJson()).toList()
      : [];

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (other is Recipe) {
      return id == other.id;
    }

    return false;
  }

  @override
  int get hashCode => id.hashCode;

}

class RecipeInstruction {
  int? number;
  String? description;
  Duration? executionDuration;
  List<Ingredient>? ingredients;
  List<Equipment>? equipment;

  RecipeInstruction({
    required this.number,
    required this.description,
    this.executionDuration,
    this.ingredients,
    this.equipment,
  });

  Duration? deserializeDuration(int? number, String? units) {
    if (number == null || units == null) {
      return null;
    }

    switch(units) {
      case 'seconds':
        return Duration(seconds: number);
      case 'minutes':
        return Duration(minutes: number);
      case 'hours':
        return Duration(hours: number);
      case 'days':
        return Duration(days: number);
      default:
        throw 'Invalid unit of time';
    }
  }

  Map<String, dynamic>? serializeDuration() {
    return executionDuration == null ? null
      : {
        "length": {
          "number": "${executionDuration?.inMinutes}",
          "length": "minutes",
        },
      };
  }

  RecipeInstruction.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    description = json['step'];
    executionDuration = json['length'] != null
      ? deserializeDuration(json['length']['number'], json['length']['unit'])
      : null;
    ingredients = json['ingredients'].map<Ingredient>((ingredientJson) => Ingredient.fromJson(ingredientJson)).toList();
    equipment = json['equipment'].map<Equipment>((equipmentJson) => Equipment.fromJson(equipmentJson)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['number'] = number;
    json['step'] = description;
    json['length'] = serializeDuration();
    json['ingredients'] = ingredients != null ?
      ingredients?.map((ingredient) => ingredient.toJson()).toList()
      : [];
    json['equipment'] = equipment != null ?
    equipment?.map((equipment) => equipment.toJson()).toList()
      : [];

    return json;
  }
}