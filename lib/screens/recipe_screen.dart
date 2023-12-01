// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/cubit/recipe_screen_cubit.dart';
import 'package:freaking_kitchen/cubit/states/recipe_screen_state.dart';
import 'package:freaking_kitchen/models/ingredient.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/section.dart';

import '../models/recipe.dart';
import '../widgets/loader.dart';

class RecipeScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeScreen({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: BlocProvider<RecipeCubit>(
        create: (BuildContext context) {
          final cubit = RecipeCubit(recipe: recipe);
          cubit.loadRecipe();
          return cubit;
        },
        child: BlocBuilder<RecipeCubit, RecipeScreenState>(
          builder: (context, state) {
            if (state is RecipeLoadingState) {
              return const Loader();
            } else if (state is RecipeErrorState) {
              return Text("Error occurred while loading recipe details: ${state.error}");
            } else if (state is RecipeLoadedState) {
              return  Container(
                color: ColorsConfig.backgroundColor,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    child: SectionWithGap(
                      gap: 25,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            state.recipe!.title!,
                            style: TextConfig.screenTitleTextStyle,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RecipeTab(
                              isActive: (state is RecipeIngredientsState),
                              title: "Ingredients",
                              onTapCallback: () {
                                context.read<RecipeCubit>().switchToRecipeIngredients();
                              },
                            ),
                            RecipeTab(
                              isActive: (state is RecipeStepsState),
                              title: "Steps",
                              onTapCallback: () {
                                context.read<RecipeCubit>().switchToRecipeSteps();
                              },
                            ),
                            RecipeTab(
                              isActive: (state is RecipeAboutState),
                              title: "About",
                              onTapCallback: () {
                                context.read<RecipeCubit>().switchToRecipeAbout();
                              },
                            ),
                          ],
                        ),
                        Builder(
                          key: key,
                          builder: (context) {
                            if (state is RecipeIngredientsState) {
                              final ingredients = state.recipe?.ingredients;
                              return SectionWithGap(
                                children: ingredients!.map((ingredient) =>
                                  IngredientSection(ingredient: ingredient)
                                ).toList(),
                              );
                            } else if (state is RecipeStepsState) {
                              return StepsSection(recipe: state.recipe!);
                            } else if (state is RecipeAboutState) {
                              return AboutSection(recipe: state.recipe!);
                            }
                            return Container();
                          },
                        )
                      ],
                    )
                  ),
              );
            }
            return Container();
          },
        ),
      ),
      // bottomNavigationBar: const Footer(),
    );
  }
}

class AboutSection extends StatefulWidget {
  final Recipe recipe;

  const AboutSection({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _AboutSectionState createState() {
    return _AboutSectionState();
  }
}

class _AboutSectionState extends State<AboutSection> {
  bool isChecked = false;
  late List<RecipeInstruction>? instructions;

  @override
  void initState() {
    instructions = widget.recipe.instructions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SectionWithGap(
      children: [
        SizedBox(
          width: double.infinity,
          height: 220,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(widget.recipe.imageUrl ?? "", fit: BoxFit.cover,),
          ),
        ),
        Text(
          "Description",
          style: TextConfig.screenSubtitleTextStyle.copyWith(color: ColorsConfig.accentColor),
        ),
        Html(
          data:
            widget.recipe.description == null ? ""
            : "<div>${widget.recipe.description}</div>",
          style: {
            "div": Style.fromTextStyle(TextConfig.labelTextStyle.copyWith(color: ColorsConfig.accentColor)),
            "a": Style(textDecoration: TextDecoration.none, color: ColorsConfig.accentColor, fontWeight: FontWeight.bold),
          },
        ),

      ]
    );
  }

}

class StepsSection extends StatefulWidget {
  final Recipe recipe;

  const StepsSection({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  _StepsSectionState createState() {
    return _StepsSectionState();
  }
}

class _StepsSectionState extends State<StepsSection> {
  bool isChecked = false;
  late List<RecipeInstruction>? instructions;

  @override
  void initState() {
    instructions = widget.recipe.instructions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {},
        child: Column(
          children: instructions != null ?
          instructions!.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            // instruction.ingredients!.forEach((element) {
            //   print("${element.name} ${element.imageUrl}");
            // });
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: ColorsConfig.secondaryTextColor,
                      width: 2
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text((index + 1).toString(), style: TextConfig.instructionIndexTextStyle),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15, right: 15),
                      child: Column(
                        children: [
                          Text(instruction.description ?? "", style: TextConfig.instructionIndexTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),),
                          const SizedBox(height: 10,),
                          Row(
                            children: [
                              Expanded(
                                  child: instruction.ingredients == null  && instruction.equipment == null
                                  ? const SizedBox.shrink()
                                  : Wrap(
                                    spacing: 5,
                                    children: [
                                      ...instruction.ingredients!.map((ingredient) => ingredient),
                                      ...instruction.equipment!.map((equipment) => equipment)
                                    ].map(
                                      (preference) => preference.imageUrl != null && preference.imageUrl != "" ? SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child:
                                            Image.network(
                                              preference.imageUrl!,
                                              fit: BoxFit.fitHeight,
                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                        ),
                                      ) : const SizedBox.shrink(),
                                    ).toList(),
                                  )
                              ),
                              const SizedBox(width: 20,),
                              // Expanded(
                              //   child: InkWell(
                              //     onTap: () {print('Timer!');},
                              //     child: Container(
                              //       width: double.infinity,
                              //       height: 30,
                              //       color: ColorsConfig.secondaryColor,
                              //
                              //       child: ,
                              //     ),
                              //   )
                              // ),
                            ],
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
            );
          }).toList()
              : [
            const Text("No instructions have been provided for this recipe 😣😣")
          ],
        )
    );
  }

}

class IngredientSection extends StatefulWidget {
  final Ingredient ingredient;

  const IngredientSection({
    Key? key,
    required this.ingredient,
  }) : super(key: key);

  @override
  _IngredientSectionState createState() => _IngredientSectionState();
}

class _IngredientSectionState extends State<IngredientSection> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isChecked ? ColorsConfig.primaryColor : ColorsConfig.backgroundColor,
          borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: ColorsConfig.accentColor.withAlpha(128),
                offset: const Offset(0, 2),
                blurRadius: 6,
              )
            ]
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 60,
              child: widget.ingredient.imageUrl != null ?
              Image.network(
                widget.ingredient.imageUrl!,
                fit: BoxFit.fitHeight,
              )
                  : const SizedBox.shrink()
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(
              widget.ingredient.nameWithMeasures ?? "No name",
              style: TextConfig.screenSubtitleTextStyle.copyWith(color: ColorsConfig.primaryTextColor),
            ))
          ],
        ),
      ),
    );
  }
}

class RecipeTab extends StatelessWidget {
  final bool isActive;
  final String title;
  final Function onTapCallback;

  const RecipeTab({
    super.key,
    required this.isActive,
    required this.title,
    required this.onTapCallback,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isActive) {
          onTapCallback();
        }
      },
      child: Container(
        width: isActive ? 150 : 100,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isActive ? ColorsConfig.accentColor : Colors.transparent,
        ),
        child: Text(
          title,
          style: isActive ?
          TextConfig.screenSubtitleTextStyle.copyWith(
            color: ColorsConfig.backgroundColor,
            fontSize: 22
          ) : TextConfig.screenSubtitleTextStyle,
        ),
      ),
    );
  }
}