import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';
import 'package:freaking_kitchen/cubit/preference_items_cubit.dart';
import 'package:freaking_kitchen/models/equipment.dart';
import 'package:freaking_kitchen/models/ingredient.dart';

import 'package:freaking_kitchen/widgets/header.dart';
import 'package:freaking_kitchen/widgets/section.dart';
import 'package:freaking_kitchen/widgets/search_field.dart';

import 'package:freaking_kitchen/utils/string_extensions.dart';

import '../api/recipe_api.dart';
import '../config/app_config.dart';
import '../cubit/states/preference_item_state.dart';
import '../repositories/recipe_repository.dart';
import '../repositories/user_preferences_repository.dart';
import '../widgets/loader.dart';

enum SettingsType {
  excludeIngredients,
  intolerances,
  equipment
}

class PreferencesSettingsForm extends StatelessWidget {
  final SettingsType settingsType;
  final RecipeApi? api;

  final RecipeRepository recipeRepository;
  final UserPreferencesRepository userPreferencesRepository;

  PreferencesSettingsForm({
    Key? key,
    required this.settingsType,
    this.api
  }) :
      recipeRepository = ApiRecipeRepository(api: api ?? SpoonacularApi(AppConfig.SPOONACULAR_API_URL!)),
      userPreferencesRepository = SPUserPreferencesRepository(),
      super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider<PreferenceItemsCubit>(
      create: (context) {
          final cubit = PreferenceItemsCubit();
        if (settingsType == SettingsType.excludeIngredients) {
          cubit.loadExcludeIngredients();
        } else if (settingsType == SettingsType.intolerances) {
          cubit.loadIntolerances();
        }  else if (settingsType == SettingsType.equipment) {
          cubit.loadEquipment();
        }
        return cubit;
      },
      child: BlocBuilder<PreferenceItemsCubit, PreferenceItemsState>(
        builder: (context, state) {
          if (state is PreferenceItemsLoadingState) {
            return const Loader();
          } else if (state is PreferenceItemsErrorState) {
            return Text('Error occurred: ${state.error}');
          } else if (state is PreferenceItemsLoadedState){
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
                          child: Text(
                            state.title,
                            style: TextConfig.screenTitleTextStyle,
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: SectionWithGap(
                            children: [
                              Text(
                                state.subTitle,
                                style: TextConfig.screenSubtitleTextStyle,
                                textAlign: TextAlign.left,
                              ),
                              SearchField(
                                placeHolder: state.searchFieldPlaceholder,
                                searchCallback: (pattern) => state.searcher.search(pattern),
                                suggestionSelectedCallback: (context, suggestion) => state.searcher.suggestionSelectedCallback(context, suggestion),
                                searchController: state.searcher.searchController,
                                itemBuilder: (context, suggestion) => state.searcher.itemBuilder(context, suggestion),
                              )
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: SectionWithGap(
                            children: [
                              Text(
                                state.preferencesItemsTitle,
                                style: TextConfig.screenSubtitleTextStyle.copyWith(color: ColorsConfig.primaryTextColor),
                                textAlign: TextAlign.left,
                              ),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: state.preferences!.map((preference) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15,
                                        vertical: 15
                                    ),
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
                                          child: Image.network(preference.imageUrl ?? ''),
                                        ),
                                        Text(
                                          preference.name!.toSentenceCase(),
                                          style: TextConfig.bodyTextStyle.copyWith(color:ColorsConfig.backgroundColor),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              if (state is ExcludeIngredientsLoadedState) {
                                                await context.read<PreferenceItemsCubit>().removeExcludeIngredient(preference as Ingredient);
                                              } else if (state is IntolerancesLoadedState) {
                                                await context.read<PreferenceItemsCubit>().removeIntolerance(preference as Ingredient);
                                              } else if (state is EquipmentLoadedState) {
                                                await context.read<PreferenceItemsCubit>().removeEquipment(preference as Equipment);
                                              }
                                            },
                                            style: const ButtonStyle(
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                                            )
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                              ],
                            )
                        ),
                      ]
                  ),
                ),
              ),
            );
          }
          return Container();
        }
      ),
    );
  }
}
