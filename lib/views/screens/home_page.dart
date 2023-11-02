import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whip_up/Screens/AddRecipe/recipe_list_screen.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';
import 'package:whip_up/models/core/myRecipe.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/screens/delicious_today_page.dart';
import 'package:whip_up/views/screens/newly_posted_page.dart';
import 'package:whip_up/views/screens/profile_page.dart';
import 'package:whip_up/views/screens/search_page.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/custom_app_bar.dart';
import 'package:whip_up/views/widgets/dummy_search_bar.dart';
import 'package:whip_up/views/widgets/featured_recipe_card.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';
import 'package:whip_up/views/widgets/recommendation_recipe_card.dart';
import 'package:http/http.dart' as http;
import 'package:whip_up/services/auth_service.dart';
import '../../model/user.dart';
import '../../services/auth_service.dart';

Future<List<MyRecipe>> fetchRecipes() async {
  final apiUrl = 'http://192.168.1.103:8000/getrecipes/';

  final Map<String, dynamic> userData = await AuthService().getUserData();
  final String accessToken = userData['access_token'] ?? ''; // Use a default value or handle null properly.
  final String profilePicture = userData['imageUrl'] ?? '';

  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      "Authorization": "Bearer $accessToken",
    },
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    List<Map<String, dynamic>> recipeData = List<Map<String, dynamic>>.from(data['recipes']);

    List<MyRecipe> recipes = recipeData.map((map) => MyRecipe(
      id: map['_id'],
      userId: map['userId'],
      title: map['title'],
      servings: map['servings'],
      difficulty: map['difficulty'],
      cookTime: map['cookTime'],
      cuisine: map['cuisine'],
      tags: List<String>.from(map['tags']),
      ingredients: (map['ingredients'] as List<dynamic>).map((ingredientMap) {
        return RecipeIngredient(
          name: ingredientMap['name'],
          quantity: ingredientMap['quantity'],
        );
      }).toList(),
      steps: (map['steps'] as List<dynamic>).map((stepMap) {
        return RecipeStep(
          description: stepMap['description'],
        );
      }).toList(),
      imageUrl: map['imageUrl'],
    )).toList();

    return recipes;
  } else {
    throw Exception('Failed to load recipes');
  }
}

class HomePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  HomePage({
    required this.userName,
    required this.userEmail,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Recipe> featuredRecipe = RecipeHelper.featuredRecipe;
  final List<Recipe> recommendationRecipe = RecipeHelper.recommendationRecipe;
  final List<Recipe> newlyPostedRecipe = RecipeHelper.newlyPostedRecipe;

  late Future<List<MyRecipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('WhipUp', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w700)),
        showProfilePhoto: true,
        profilePhoto: AssetImage('assets/images/pp.jpg'),
        profilePhotoOnPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userEmail: widget.userEmail, userName: widget.userName)));
        },
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Featured Recipe - Wrapper
          Container(
            height: 350,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  height: 245,
                  color: Colors.grey.shade900,
                ),
                // Section 1 - Content
                Column(
                  children: [
                    // Search Bar
                    DummySearchBar(
                      routeTo: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPage()));
                      },
                    ),
                    // Delicious Today - Header
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delicious Today',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliciousTodayPage(recipes: futureRecipes)));
                            },
                            child: Text('see all'),
                            style: TextButton.styleFrom(primary: Colors.white, textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    // Delicious Today - ListView
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      height: 220,
                      child: Center(
                        child: FutureBuilder<List<MyRecipe>>(
                          future: futureRecipes,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Loading state
                              return CircularProgressIndicator(); // Display the loading indicator in the center.
                            } else if (snapshot.hasError) {
                              // Error state
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              // Data available
                              List<MyRecipe> recipes = snapshot.data!;
                              return ListView.separated(
                                itemCount: recipes.length,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 16);
                                },
                                itemBuilder: (context, index) {
                                  // Display your recipe data using FeaturedRecipeCard.
                                  return FeaturedRecipeCard(data: recipes[index]);
                                },
                              );
                            } else {
                              // No data available
                              return Text('No data available');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 14),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0), // Adjust the value (16.0) to your desired spacing
                      child: Text(
                        'Newly Posted',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                      ),
                    ),
                  ],
                ),
                // Content - Use ListView.builder to display newly posted recipes
            FutureBuilder<List<MyRecipe>>(
              future: futureRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Loading state
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Error state
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // Data available
                  List<MyRecipe> allRecipes = snapshot.data!;
                  List<MyRecipe> latestRecipes = allRecipes.reversed.take(6).toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: latestRecipes.length,
                    itemBuilder: (context, index) {
                      // Display your recipe data using RecipeTile with added space
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0), // Adjust the value (16.0) for the desired space
                        child: RecipeTile(data: latestRecipes[index]),
                      );
                    },
                  );
                } else {
                  // No data available
                  return Text('No data available');
                }
              },
            ),
            ],
            ),
          ),
        ],
      ),
    );
  }
}