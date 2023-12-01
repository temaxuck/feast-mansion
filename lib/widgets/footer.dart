// ignore_for_file: library_private_types_in_public_api

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'package:freaking_kitchen/config/colors_config.dart';

class TabItem {
  String title;
  String iconPath;

  TabItem(this.title, this.iconPath);
}

class Footer extends StatefulWidget {
  final int selectedTabIndex;
  final PageController pageController;


  const Footer({
    super.key,
    required this.selectedTabIndex,
    required this.pageController,
  });

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {

  final List<TabItem> _items = [
    TabItem('Recipe by name', 'assets/icons/skillet.svg'),
    TabItem('Recipe by ingredients', 'assets/icons/grocery.svg'),
    TabItem('History', 'assets/icons/history.svg'),
  ];

  List<BottomNavigationBarItem> getBottomTabs(List<TabItem> tabs, int selectedIndex) {
    List<BottomNavigationBarItem> items = [];
    for (int i = 0; i < tabs.length; i++) {
      items.add(
          BottomNavigationBarItem(
            icon: AnimatedContainer(
              height: i == selectedIndex ? 29.0 : 25.0,
              duration: const Duration(milliseconds: 200),
              child: SvgPicture.asset(
                tabs[i].iconPath,
                color: i == selectedIndex ? Colors.white : Colors.grey,
              ),
            ),
            label: tabs[i].title,
          )
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BottomNavigationBar(
        selectedItemColor: ColorsConfig.backgroundColor,
        unselectedItemColor: ColorsConfig.secondaryTextColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: widget.selectedTabIndex,
        onTap: (index) {
          setState(() {
            widget.pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
        backgroundColor: ColorsConfig.primaryColor,
        items: getBottomTabs(_items, widget.selectedTabIndex),
      ),
    );
  }
}
