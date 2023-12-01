// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';


import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/text_config.dart';

class SearchField extends StatefulWidget {
  final TextEditingController? searchController;
  final Function searchCallback;
  final Function itemBuilder;
  final Function suggestionSelectedCallback;
  final String? placeHolder;
  final int searchDelayAfterInput;

  const SearchField({
    super.key,
    this.searchController,
    required this.searchCallback,
    required this.itemBuilder,
    required this.suggestionSelectedCallback,
    this.placeHolder,
    this.searchDelayAfterInput = 0,
  });

  // TextEditingController? getSearchController(BuildContext context) {  // for stateless widgets
  //   return context.;
  // }
// }

  @override
  _SearchFieldState createState() => _SearchFieldState();
}


class _SearchFieldState extends State<SearchField> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = widget.searchController!;
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: searchController,
        style: const TextStyle(fontSize: 18, color: ColorsConfig.primaryTextColor),
        autocorrect: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(20),
          label: Text(widget.placeHolder!, style: TextConfig.labelTextStyle),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: ColorsConfig.secondaryTextColor,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(
              color: ColorsConfig.primaryTextColor,
              width: 2,
            )
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              color: ColorsConfig.secondaryTextColor,
              height: 14,
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        return await widget.searchCallback(pattern);
      },
      debounceDuration: Duration(seconds: widget.searchDelayAfterInput),
      itemBuilder: (context, suggestion)
        => widget.itemBuilder(context, suggestion),
      onSuggestionSelected: (suggestion) {
        widget.suggestionSelectedCallback(context, suggestion);
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: ColorsConfig.backgroundColor,
        elevation: 15,

        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: ColorsConfig.primaryTextColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30.0),
        )
      ),
    );
  }
}