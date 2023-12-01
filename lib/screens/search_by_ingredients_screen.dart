import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/cubit/search_by_ingredients_cubit.dart';
import 'package:freaking_kitchen/cubit/states/search_by_ingredients_state.dart';
import 'package:freaking_kitchen/utils/string_extensions.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/section.dart';
import 'package:freaking_kitchen/widgets/search_field.dart';
import 'package:freaking_kitchen/widgets/preferences_menu.dart';
import 'package:freaking_kitchen/widgets/find_recipes_button.dart';

import '../widgets/loader.dart';

class SearchByIngredientsScreen extends StatelessWidget {
  const SearchByIngredientsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchByIngredientsCubit>(
      create: (context) {
        SearchByIngredientsCubit cubit = SearchByIngredientsCubit();
        cubit.loadIngredients();
        return cubit;
      },
      child: BlocBuilder<SearchByIngredientsCubit, SearchByIngredientsState>(
        builder: (context, state) {
          if (state is SearchByIngredientsLoadingState) {
            return const Loader();
          } else if (state is SearchByIngredientsErrorState) {
            return Text("Error occurred: ${state.error}");
          } else if (state is SearchByIngredientsLoadedState) {
          return Scaffold(
            appBar: const Header(),
            body: Container(
              color: ColorsConfig.backgroundColor,
              height: double.infinity,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                child: SectionWithGap(gap: 25, children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Let\'s make up the recipe!',
                      style: TextConfig.screenTitleTextStyle,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SectionWithGap(
                      children: [
                        const Text(
                          'What ingredients do you have?',
                          style: TextConfig.screenSubtitleTextStyle,
                          textAlign: TextAlign.left,
                        ),
                        SearchField(
                          placeHolder: 'Search for ingredients',
                          searchCallback: (pattern) =>
                              state.ingredientSearcher.search(pattern),
                          suggestionSelectedCallback: (context, suggestion) =>
                              state.ingredientSearcher.suggestionSelectedCallback(
                                  context, suggestion),
                          searchController: state.ingredientSearcher.searchController,
                          itemBuilder: (context, suggestion) =>
                              state.ingredientSearcher.itemBuilder(
                                  context, suggestion),
                        )
                      ],
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: SectionWithGap(
                        children: [
                          Text(
                            "Ingredients",
                            style: TextConfig.screenSubtitleTextStyle
                                .copyWith(color: ColorsConfig.primaryTextColor),
                            textAlign: TextAlign.left,
                          ),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: state.ingredients.map((ingredient) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsConfig.accentColor,
                                ),
                                child: Wrap(
                                  spacing: 10,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxHeight: 30,
                                        maxWidth: 30,
                                      ),
                                      child: Image.network(
                                          ingredient.imageUrl ?? ''),
                                    ),
                                    Text(
                                      ingredient.name!.toSentenceCase(),
                                      style: TextConfig.bodyTextStyle.copyWith(
                                          color: ColorsConfig.backgroundColor),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          context
                                              .read<SearchByIngredientsCubit>()
                                              .removeIngredient(ingredient);
                                        },
                                        style: const ButtonStyle(
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        iconSize: 25,
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          maxWidth: 25,
                                          maxHeight: 25,
                                        ),
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: ColorsConfig.backgroundColor,
                                        )),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      )),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: const PreferencesMenu()),
                  Container(
                      alignment: Alignment.center,
                      child: FindRecipesButton(
                        ingredients: state.ingredients,
                      )),
                ]),
              ),
            ),
            // bottomNavigationBar: const Footer(),
          );
        }
        return Container();
      }
      ),
    );

  }
}
