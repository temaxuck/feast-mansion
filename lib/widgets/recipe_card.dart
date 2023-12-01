import 'package:flutter/material.dart';
import 'package:freaking_kitchen/utils/string_extensions.dart';

import '../config/colors_config.dart';
import '../config/text_config.dart';
import '../models/recipe.dart';
import '../screens/recipe_screen.dart';


class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Widget? action;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.action
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipeScreen(recipe: recipe,)
              )
          );
        },
        child: Container(
            // height: 120,
          constraints: const BoxConstraints(
            minHeight: 120
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: ColorsConfig.accentColor.withAlpha(128),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                )
              ],
            color: ColorsConfig.backgroundColor,
          ),
          padding: const EdgeInsets.all(15).copyWith(right: 20),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 90,
                child: recipe.imageUrl != null ?
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    recipe.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                )
                : const SizedBox.shrink()
              ),
              const SizedBox(width: 15,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title!.toSentenceCase(),
                            style: TextConfig.screenSubtitleTextStyle.copyWith(
                                      color: ColorsConfig.primaryTextColor
                            ),
                          ),
                        ),
                      action ?? const SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        const Expanded(
                          child: SizedBox.shrink(),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.timer_outlined, color: ColorsConfig.primaryTextColor,),
                              Text("${recipe.totalCookingTime!} min",),
                            ],
                          )
                        )
                      ],
                    )
                  ]
                )
              )
            ]
          )
        )
    );
  }
}