import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/cubit/search_results_cubit.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/loader.dart';
import 'package:freaking_kitchen/widgets/section.dart';

import '../cubit/states/search_results_state.dart';
import '../models/ingredient.dart';
import '../widgets/recipe_card.dart';

class SearchResultsScreen extends StatelessWidget {
  final String? recipeName;
  final List<Ingredient>? ingredients;
  const SearchResultsScreen({
    Key? key,
    this.recipeName,
    this.ingredients
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchResultsCubit>(
      create: (context) {
        SearchResultsCubit cubit = SearchResultsCubit();
        cubit.loadRecipes(recipeName, ingredients);
        return cubit;
      },
      child: BlocBuilder<SearchResultsCubit, SearchResultsState>(
        builder: (context, state) {
          if (state is SearchResultsLoadingState) {
            return const Loader();
          } else if (state is SearchResultsErrorState) {
            return Text('Error occurred while searching recipes: ${state.error}');
          } else if (state is SearchResultsLoadedState) {
            return Scaffold(
              appBar: const Header(),
              body: Container(
                color: ColorsConfig.backgroundColor,
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: SectionWithGap(
                    gap: 25,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Search results',
                          style: TextConfig.screenTitleTextStyle,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          recipeName != null ?
                            recipeName != "" ?  "for request with recipe name: $recipeName"
                            : "Random recipes"
                          : 'for request with ingredients: ${ingredients!.join(",")}',
                          style: TextConfig.screenSubtitleTextStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      (state.recipes.isNotEmpty) ? SectionWithGap(
                        children: state.recipes.reversed.map((recipe) => RecipeCard(recipe: recipe)).toList(),
                      ) : const Text("No recipe has been found 😣😣"),
                    ]
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
