import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/cubit/history_screen_cubit.dart';
import 'package:freaking_kitchen/cubit/states/history_screen_state.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/loader.dart';
import 'package:freaking_kitchen/widgets/section.dart';

import '../widgets/recipe_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryScreenCubit>(
      create: (context) {
        HistoryScreenCubit cubit = HistoryScreenCubit();
        cubit.loadRecipes();
        return cubit;
      },
      child: BlocBuilder<HistoryScreenCubit, HistoryScreenState>(
        builder: (context, state) {
          if (state is HistoryScreenLoadingState) {
            return const Loader();
          } else if (state is HistoryScreenErrorState) {
            return Text('Error occurred while searching recipes: ${state.error}');
          } else if (state is HistoryScreenLoadedState) {
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
                        SectionWithGap(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'History',
                                style: TextConfig.screenTitleTextStyle,
                              ),
                            ),
                            Container(
                               alignment: Alignment.centerLeft,
                               child: const Text(
                                 '... of your culinary masterpieces',
                                 style: TextConfig.screenSubtitleTextStyle,
                                 textAlign: TextAlign.left,
                               ),
                            )
                          ]
                        ),
                        (state.recipes.isNotEmpty) ? SectionWithGap(
                          children: state.recipes.reversed.map((recipe) => RecipeCard(
                            recipe: recipe,
                            action: IconButton(
                              onPressed: () async {
                                context.read<HistoryScreenCubit>().removeRecipe(recipe);
                              },
                              icon: const Icon(
                                Icons.close_rounded, size: 30,
                                color: ColorsConfig.secondaryColor,
                              ),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.topRight,
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                // alignment: Alignment.topRight,
                              ),
                            ),
                          )).toList(),
                        ) : Text(
                          "Your history is clear 🐢",
                          style: TextConfig.screenSubtitleTextStyle.copyWith(color: ColorsConfig.accentColor),
                        ),
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
