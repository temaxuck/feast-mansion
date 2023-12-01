import 'package:freaking_kitchen/models/preference.dart';

class Equipment extends Preference {
  Equipment({
    super.name,
    super.imageUrl,
  });

  Equipment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['name'] = name;
    json['image'] = imageUrl;

    return json;
  }

  @override
  String toString() {
    return name!;
  }

  @override
  bool operator ==(Object other) {
    if (other is Equipment) {
      return name == other.name;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode;
}