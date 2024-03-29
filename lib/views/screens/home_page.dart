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
import 'package:whip_up/Screens/Login/components/body.dart';
import '../../model/user.dart';
import '../../services/auth_service.dart';
import 'notification_provider.dart';
import 'notification_service.dart';
import 'package:provider/provider.dart';
import 'package:whip_up/views/screens/notification_provider.dart';

Future<List<MyRecipe>> fetchRecipes() async {
  final apiUrl = 'http://192.168.2.105:8000/getrecipes/';

  final Map<String, dynamic> userData = await AuthService().getUserData();
  final String accessToken = userData['access_token'] ?? ''; // Use a default value or handle null properly.
  final String profilePicture = userData['imageUrl'] ?? '';
  final String userId = userData['user_id'] ?? '';

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
      total_likes: map['total_likes'],
      username: map['username'],
    )).toList();

    return recipes;
  } else {
    throw Exception('Failed to load recipes');
  }
}

Future<List<MyRecipe>> fetchLatestRecipes() async {
  final apiUrl = 'http://192.168.2.105:8000/getrecipes/';

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
      total_likes: map['total_likes'],
      username: map['username'],
    )).toList();

    return recipes;
  } else {
    throw Exception('Failed to load recipes');
  }
}

Future<List<MyRecipe>> fetchRecommendations() async {
  final apiUrl = 'http://192.168.2.105:8000/recommendations/';

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
        total_likes: map['total_likes'],
        username: map['username'],
      )
    ).toList();
    print('Recipes: $recipes');
    return recipes;
  } else {
    throw Exception('Failed to load recipes');
  }
}

List<MyRecipe> filterTopLikedRecipes(List<MyRecipe> allRecipes) {
  allRecipes.sort((a, b) => b.total_likes.compareTo(a.total_likes));

  final topLikedRecipes = allRecipes.take(10).toList();

  return topLikedRecipes;
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
  late Future<List<MyRecipe>> recommendedRecipes;
  late Future<List<MyRecipe>> latestRecipes;
  late String profilePhotoUrl = '';
  late Future<List<MyRecipe>> topLikedRecipes = Future.value([]);

  @override
  void initState() {
    super.initState();
    getProfilePhotoUrl();
    futureRecipes = fetchRecipes();
    latestRecipes = fetchLatestRecipes();
    recommendedRecipes = fetchRecommendations();
    _fetchAndSetUnreadNotificationCount();

    futureRecipes.then((recipes) {
      topLikedRecipes = Future.value(filterTopLikedRecipes(recipes));
      setState(() {});
    });

    recommendedRecipes = fetchRecommendations();
  }

  Future<void> _fetchAndSetUnreadNotificationCount() async {
    try {
      final authService = AuthService();
      final userData = await authService.getUserData();
      final String userId = userData['user_id'] ?? '';
      final notificationService = NotificationService('http://192.168.2.105:8000');
      final count = await notificationService.getUnreadNotificationCount(userId);
      Provider.of<NotificationProvider>(context, listen: false).setUnreadCount(count);
    } catch (error) {
      print('Error fetching notification count: $error');
    }
  }

  Future<void> _refresh() async {
    await _fetchAndSetUnreadNotificationCount(); // Wait for notification count to be fetched and set

    setState(() {
      futureRecipes = fetchRecipes();
      recommendedRecipes = fetchRecommendations();
      latestRecipes = fetchLatestRecipes();
    });

    futureRecipes.then((recipes) {
      topLikedRecipes = Future.value(filterTopLikedRecipes(recipes));
      setState(() {});
    });
  }

  void getProfilePhotoUrl() async {
    try {
      profilePhotoUrl = await AuthService().getUserProfileImageUrl() ?? '';
    } catch (error) {
      print('Error getting profile photo URL: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('WhipUp', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w700, color: Colors.white)),
        showProfilePhoto: true,
        profilePhoto: profilePhotoUrl.isNotEmpty
            ? NetworkImage('http://192.168.2.105:8000/profile-picture/$profilePhotoUrl')
            : null, // Provide a default image asset

        profilePhotoOnPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userEmail: widget.userEmail, userName: widget.userName)));
        },
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
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
                            future: topLikedRecipes,
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
              margin: EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Today\'s recommendations based on your taste...',
                      style: TextStyle(color: Colors.grey.shade800, fontSize: 15),
                    ),
                  ),
                  // Content
                  Container(
                    height: 174,
                    child: FutureBuilder<List<MyRecipe>>(
                      future: recommendedRecipes,  // Assuming futureRecommendations is the Future<List<MyRecipe>> for recommended recipes
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Loading state
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          // Error state
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                          // Data available
                          List<MyRecipe> recommendedRecipes = snapshot.data!;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedRecipes.length,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 16);
                            },
                            itemBuilder: (context, index) {
                              // Display recommended recipe data using RecommendationRecipeCard.
                              return RecommendationRecipeCard(data: recommendedRecipes[index]);
                            },
                          );
                        } else {
                          // No data available
                          return Text('No recommendations available');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
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
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewlyPostedPage(recipes: futureRecipes)));
                        },
                        child: Text('see all'),
                        style: TextButton.styleFrom(primary: Colors.black, textStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
                      ),
                    ],
                  ),
                  // Content - Use ListView.builder to display newly posted recipes
                  FutureBuilder<List<MyRecipe>>(
                    future: latestRecipes,
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
      ),
    );
  }
}