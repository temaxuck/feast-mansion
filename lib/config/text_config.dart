import 'package:flutter/material.dart';
import 'package:freaking_kitchen/config/colors_config.dart';

class TextConfig {
  const TextConfig();

  static const screenTitleTextStyle = TextStyle(
    color: ColorsConfig.primaryTextColor,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const screenSubtitleTextStyle = TextStyle(
    color: ColorsConfig.secondaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const labelTextStyle = TextStyle(
    color: ColorsConfig.secondaryTextColor,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const sectionTitleTextStyle = TextStyle(
    color: ColorsConfig.primaryTextColor,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const bodyTextStyle = TextStyle(
    color: ColorsConfig.primaryTextColor,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const accentTextStyle = TextStyle(
    color: ColorsConfig.secondaryColor,
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const bigButtonTextStyle = TextStyle(
    color: ColorsConfig.backgroundColor,
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const instructionIndexTextStyle = TextStyle(
    color: ColorsConfig.accentColor,
    fontSize: 50,
    fontWeight: FontWeight.bold,
  );
}