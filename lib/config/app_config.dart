// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String? get SPOONACULAR_API_KEY {
    return dotenv.env['SPOONACULAR_API_KEY'];
  }

  static String? get SPOONACULAR_API_URL {
    return dotenv.env['SPOONACULAR_API_URL'];
  }

  static Future<void> loadEnv() {
    return dotenv.load();
  }
}