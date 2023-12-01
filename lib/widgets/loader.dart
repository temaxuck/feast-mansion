import 'package:flutter/material.dart';

import '../config/colors_config.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorsConfig.backgroundColor,
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}