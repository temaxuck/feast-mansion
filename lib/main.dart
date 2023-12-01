import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freaking_kitchen/screens/home_screen.dart';
import 'package:freaking_kitchen/config/colors_config.dart';
import 'package:freaking_kitchen/config/app_config.dart';


void main() async {
  await AppConfig.loadEnv();
  runApp(const FreakingKitchen());
}

class FreakingKitchen extends StatelessWidget {
  const FreakingKitchen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
    );
    return MaterialApp(
      title: 'Freaking Kitchen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorsConfig.primaryColor),
        useMaterial3: true,
        dividerColor: Colors.transparent,
        canvasColor: ColorsConfig.backgroundColor,
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Change this to your desired border radius
          ),
          elevation: 15, // Change this to your desired elevation
        ),
        iconTheme: const IconThemeData(
          color: ColorsConfig.backgroundColor
        )
      ),
      home: const HomeScreen(),
    );
  }
}

