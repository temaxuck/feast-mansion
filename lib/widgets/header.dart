import 'package:flutter/material.dart';
import 'package:freaking_kitchen/config/colors_config.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      elevation: 4.0,
      shadowColor: Colors.black,
      backgroundColor: ColorsConfig.primaryColor,
      iconTheme: const IconThemeData(
          color: ColorsConfig.backgroundColor
      ),
      title: const Text(
        'Feast Mansion',
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: ColorsConfig.backgroundColor
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}