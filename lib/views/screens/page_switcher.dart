import 'package:flutter/material.dart';
import 'package:whip_up/Screens/AddRecipe/add_recipe_screen.dart';
import 'package:whip_up/Screens/AddRecipe/intermediary_screen.dart';
import 'package:whip_up/views/screens/bookmarks_page.dart';
import 'package:whip_up/views/screens/explore_page.dart';
import 'package:whip_up/views/screens/home_page.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/custom_bottom_navigation_bar.dart';

import 'my_recipes_page.dart';

class PageSwitcher extends StatefulWidget {
  final String userEmail;
  final String userName;
  final String userId;

  PageSwitcher({required this.userEmail, required this.userName, required this.userId});

  @override
  _PageSwitcherState createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            [
              HomePage(userEmail: widget.userEmail, userName: widget.userName),
              RecipeDetailsPage(userId: widget.userId, userName: widget.userName, userEmail: widget.userEmail),
              MyRecipesPage(userId: widget.userId),
              BookmarksPage(),
            ][_selectedIndex],
            BottomGradientWidget(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      ),
    );
  }
}

class BottomGradientWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(gradient: AppColor.linearBlackBottom),
      ),
    );
  }
}
