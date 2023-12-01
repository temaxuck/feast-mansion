import 'package:freaking_kitchen/models/preference.dart';

class Ingredient extends Preference {
  String? nameWithMeasures;

  Ingredient({
    super.name,
    super.imageUrl,
    this.nameWithMeasures
  });

  Ingredient.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['image'];
    nameWithMeasures = json['original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['name'] = name;
    json['image'] = imageUrl;
    json['original'] = nameWithMeasures;

    return json;
  }

  @override
  String toString() {
    return name!;
  }

  @override
  bool operator ==(Object other) {
    if (other is Ingredient) {
      return name == other.name;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode;
}