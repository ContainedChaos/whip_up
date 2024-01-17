import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/core/myRecipe.dart';
import '../../services/auth_service.dart';
import '../widgets/featured_recipe_card.dart';

class PosterProfilePage extends StatefulWidget {
  final String userId;

  PosterProfilePage({required this.userId});

  @override
  _PosterProfilePageState createState() => _PosterProfilePageState();
}

class _PosterProfilePageState extends State<PosterProfilePage> {
  late Future<Map<String, dynamic>> profileData;
  late Future<List<MyRecipe>> chefsRecipes;

  @override
  void initState() {
    super.initState();
    profileData = fetchProfileData();
    chefsRecipes = fetchChefsRecipes();
  }

  Future<List<MyRecipe>> fetchChefsRecipes() async {
    if (widget.userId == null || widget.userId.isEmpty) {
      throw Exception('Invalid userId');
    }

    final apiUrl = 'http://192.168.2.105'
        ':8000/getchefsrecipes/${widget.userId}/';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      List<Map<String, dynamic>> recipeData = List<Map<String, dynamic>>.from(data['recipes']);

      List<MyRecipe> myRecipes = recipeData.map((map) => MyRecipe(
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

      return myRecipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  Future<Map<String, dynamic>> fetchProfileData() async {
    final apiUrl = 'http://192.168.2.105:8000/posterprofile/${widget.userId}/';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load profile data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chef\'s Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey.shade900,
        centerTitle: false,
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: profileData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            // Data available, use it to initialize your UI
            final Map<String, dynamic> data = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Section with Background Color
                Container(
                  color: Colors.grey.shade900, // Set your desired background color
                  height: MediaQuery.of(context).size.height * 0.18, // Adjust the percentage as needed
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side - Image
                      Container(
                        margin: EdgeInsets.only(left:16, right: 16, bottom: 25),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('http://192.168.2.105:8000/profile-picture/${data['imageUrl']}'),
                          radius: 50,
                        ),
                      ),
                      // Right side - Username, Email, Bio
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Add spacing below each text
                            Padding(
                              padding: EdgeInsets.only(bottom: 12, left: 8),
                              child: Text('Username: ${data['username']}', style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 12, left: 8),
                              child: Text('Email: ${data['email']}', style: TextStyle(color: Colors.white)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 30, left: 8),
                              child: Text('Bio: ${data['bio']}', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<MyRecipe>>(
                    future: chefsRecipes,
                    builder: (context, snapshotRecipes) {
                      if (snapshotRecipes.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshotRecipes.hasError) {
                        return Center(child: Text('Error: ${snapshotRecipes.error}'));
                      } else if (!snapshotRecipes.hasData) {
                        return Center(child: Text('No recipes available'));
                      } else {
                        // Access the length property here
                        final List<MyRecipe> recipes = snapshotRecipes.data!;
                        return ListView.builder(
                          itemCount: (recipes.length / 2).ceil(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final int startIndex = index * 2;
                            final int endIndex = (index + 1) * 2;
                            final List<MyRecipe> currentRecipes =
                            recipes.sublist(startIndex, endIndex.clamp(0, recipes.length));

                            // Check if the last row has only one recipe
                            if (currentRecipes.length == 1 && index == (recipes.length / 2).floor()) {
                              return Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 14.0, right: 8.0, top: 10.0),
                                      child: FeaturedRecipeCard(data: currentRecipes[0]),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              );
                            }

                            return Row(
                              children: currentRecipes.map((recipe) {
                                return Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 14.0, right: 8.0, top: 10.0),
                                    child: FeaturedRecipeCard(data: recipe),
                                  ),
                                  flex: 1,
                                );
                              }).toList(),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
