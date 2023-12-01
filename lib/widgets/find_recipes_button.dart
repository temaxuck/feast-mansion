import 'package:flutter/material.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/screens/search_results_screen.dart';

import '../models/ingredient.dart';

class FindRecipesButton extends StatelessWidget {
  final String? recipeName;
  final List<Ingredient>? ingredients;

  const FindRecipesButton({
    super.key,
    this.recipeName,
    this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
              SearchResultsScreen(
                recipeName: recipeName,
                ingredients: ingredients,
              )
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsConfig.primaryColor,
        elevation: 18,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Find recipes', style: TextConfig.bigButtonTextStyle,),
    );
  }

}