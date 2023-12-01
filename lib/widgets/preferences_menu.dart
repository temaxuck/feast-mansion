// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';

import 'package:freaking_kitchen/repositories/user_preferences_repository.dart';
import 'package:freaking_kitchen/screens/preferences_settings_form.dart';


class PreferencesMenu extends StatefulWidget {
  const PreferencesMenu({super.key});

  @override
  _PreferencesMenuState createState() => _PreferencesMenuState();
}

class _PreferencesMenuState extends State<PreferencesMenu> {
  bool _preferencesExpanded = false;
  late SPUserPreferencesRepository prefRepository;
  late List<String> dietsAvailable;
  late List<String> cuisinesAvailable;


  @override
  void initState() {
    super.initState();
    prefRepository = SPUserPreferencesRepository();
    dietsAvailable = prefRepository.getAllDiets();
    cuisinesAvailable = prefRepository.getAllCuisines();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTileTheme(
          contentPadding: const EdgeInsets.all(0),
          child: ExpansionTile(
            title: const Text('Preferences', style: TextConfig.sectionTitleTextStyle,),
            childrenPadding: const EdgeInsets.symmetric(horizontal: 5),
            trailing: _preferencesExpanded ?
              const Text("-", style: TextStyle(color: ColorsConfig.secondaryColor, fontSize: 40)) :
              const Text("+", style: TextStyle(color: ColorsConfig.secondaryColor, fontSize: 40)),
            onExpansionChanged: (bool expanded) {
              setState(() {
                _preferencesExpanded = expanded;
              });
            },
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Your diet", style: TextConfig.bodyTextStyle),
                  FutureBuilder(
                    future: prefRepository.getDiet(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error occurred while loading data: ${snapshot.error}');
                      } else {
                        return SelectButton(
                          selectedValue: snapshot.data ?? 'None',
                          selectOptions: dietsAvailable,
                          onChangeAction: (value) {
                            prefRepository.setDiet(value);
                          }
                        );
                      }
                    }
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Cuisine", style: TextConfig.bodyTextStyle),
                  FutureBuilder(
                    future: prefRepository.getCuisine(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error occurred while loading data: ${snapshot.error}');
                      } else {
                        return SelectButton(
                          selectedValue: snapshot.data ?? 'All',
                          selectOptions: cuisinesAvailable,
                          onChangeAction: (value) {
                            prefRepository.setCuisine(value);
                          }
                        );
                      }
                    }
                    ),
                  ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Exclude ingredients", style: TextConfig.bodyTextStyle),
                  GoToButton(
                    goToScreen: PreferencesSettingsForm(settingsType: SettingsType.excludeIngredients,),
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Intolerances", style: TextConfig.bodyTextStyle),
                  GoToButton(
                    goToScreen: PreferencesSettingsForm(settingsType: SettingsType.intolerances,),
                  ),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Equipment", style: TextConfig.bodyTextStyle),
                  GoToButton(
                    goToScreen: PreferencesSettingsForm(settingsType: SettingsType.equipment,),
                  ),
                ]
              ),
            ],
          ),
        ),
      ],
    );

  }
}

class GoToButton extends StatelessWidget {
  final Widget goToScreen;
  const GoToButton({
    super.key,
    required this.goToScreen,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        alignment: Alignment.centerRight,
        onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => goToScreen,
                )
            );
        },

        constraints: const BoxConstraints(
          minHeight: 50,
          minWidth: 50,
        ),
        style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashFactory: NoSplash.splashFactory
        ),
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 22,
          color: ColorsConfig.secondaryColor,
        )
    );
  }
}

class SelectButton extends StatefulWidget {
  final String selectedValue;
  final List<String> selectOptions;
  final Function? onChangeAction;

  const SelectButton({
    super.key,
    required this.selectedValue,
    required this.selectOptions,
    required this.onChangeAction
  });

  @override
  _SelectButton createState() => _SelectButton();
}

class _SelectButton extends State<SelectButton> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.zero,
          menuMaxHeight: 400,
          items: widget.selectOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                style: TextConfig.accentTextStyle.copyWith(
                  color: value == selectedValue ?
                  ColorsConfig.secondaryColor : ColorsConfig.primaryTextColor,
                  fontWeight: value == selectedValue ?
                  FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          selectedItemBuilder: (BuildContext context) {
            return widget.selectOptions.map<Widget>((String item) {
              return Container(
                alignment: Alignment.centerRight,
                child: Text(
                  item,
                  style: TextConfig.accentTextStyle,
                  textDirection: TextDirection.rtl,
                ),
              );
            }).toList();
          },
          dropdownColor: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: ColorsConfig.secondaryColor,
            size: 26,
          ),
          itemHeight: 50,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.onChangeAction!(newValue);
            });
          },
        )
    );
  }
}