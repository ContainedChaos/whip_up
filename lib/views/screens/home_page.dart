import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whip_up/Screens/AddRecipe/recipe_list_screen.dart';
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

import '../../services/auth_service.dart';

Future<List<MyRecipe>> fetchRecipes() async {
  final apiUrl = 'http://192.168.0.104:8000/getrecipes/';

  final Map<String, dynamic> userData = await AuthService().getUserData(); // Use a default value or handle null properly.

  final response = await http.get(
    Uri.parse(apiUrl)
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
        title: Text('Hungry?', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w700)),
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
                  color: AppColor.primary,
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
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeListScreen()));
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
                      child: FutureBuilder<List<MyRecipe>>(
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


                  ],
                )
              ],
            ),
          ),
          // Section 2 - Recommendation Recipe
          Container(
            margin: EdgeInsets.only(top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Today recomendation based on your taste...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                // Content
                Container(
                  height: 174,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendationRecipe.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 16);
                    },
                    itemBuilder: (context, index) {
                      return RecommendationRecipeCard(data: recommendationRecipe[index]);
                    },
                  ),
                )
              ],
            ),
          ),
          // Section 3 - Newly Posted
          // Container(
          //   margin: EdgeInsets.only(top: 14),
          //   padding: EdgeInsets.symmetric(horizontal: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       // Header
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             'Newly Posted',
          //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'inter'),
          //           ),
          //           TextButton(
          //             onPressed: () {
          //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewlyPostedPage()));
          //             },
          //             child: Text('see all'),
          //             style: TextButton.styleFrom(primary: Colors.black, textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          //           ),
          //         ],
          //       ),
          //       // Content
          //       ListView.separated(
          //         shrinkWrap: true,
          //         itemCount: 3 ?? newlyPostedRecipe.length,
          //         physics: NeverScrollableScrollPhysics(),
          //         separatorBuilder: (context, index) {
          //           return SizedBox(height: 16);
          //         },
          //         itemBuilder: (context, index) {
          //           return RecipeTile(
          //             data: newlyPostedRecipe[index],
          //           );
          //         },
          //       ),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}