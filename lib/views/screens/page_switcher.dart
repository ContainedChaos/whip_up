import 'package:flutter/material.dart';
import 'package:whip_up/Screens/AddRecipe/add_recipe_screen.dart';
import 'package:whip_up/Screens/AddRecipe/intermediary_screen.dart';
import 'package:whip_up/views/screens/bookmarks_page.dart';
import 'package:whip_up/views/screens/explore_page.dart';
import 'package:whip_up/views/screens/home_page.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:whip_up/views/screens/NotificationPage.dart';
import 'my_recipes_page.dart';
import 'package:flutter/material.dart';
// Import the NotificationsScreen file

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
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    // Initialize the list of pages
    pages = [
      HomePage(userEmail: widget.userEmail, userName: widget.userName),
      RecipeDetailsPage(userId: widget.userId, userEmail: widget.userEmail, userName: widget.userName),
      MyRecipesPage(userId: widget.userId),
      BookmarksPage(),
      NotificationsScreen(userId: widget.userId), // NotificationsScreen added to the list
    ];
  }


  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _onItemTapped(0); // Redirect to the Home page when pressing the back button on any screen
    }
    return false; // Prevent exiting the app or navigating back from the Home page
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            pages[_selectedIndex],
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