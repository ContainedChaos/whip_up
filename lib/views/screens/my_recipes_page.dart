import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/modals/search_filter_model.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';
import 'package:http/http.dart' as http;
import '../../models/core/myRecipe.dart';
import '../../services/auth_service.dart';

class MyRecipesPage extends StatefulWidget {
  final String userId;
  MyRecipesPage({required this.userId});

  @override
  _MyRecipesPageState createState() => _MyRecipesPageState();
}

class _MyRecipesPageState extends State<MyRecipesPage> {
  TextEditingController searchInputController = TextEditingController();
  late Future<List<MyRecipe>> myRecipes;

  @override
  void initState() {
    super.initState();
    myRecipes = fetchMyRecipes();
  }


  Future<List<MyRecipe>> fetchMyRecipes() async {
    final apiUrl = 'http://192.168.2.105'
        ':8000/getmyrecipes/';

    final Map<String, dynamic> userData = await AuthService().getUserData();
    final String accessToken = userData['access_token'] ?? ''; // Use a default value or handle null properly.

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade900,
        centerTitle: false,
        elevation: 0,
        title: Text('My Recipes',
            style: TextStyle(
                fontFamily: 'inter',
                fontWeight: FontWeight.w500,
                fontSize: 20,
            color: Colors.white)),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 2 - Bookmarked Recipe
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<MyRecipe>>(
              future: myRecipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<MyRecipe> bookmarkedRecipe = snapshot.data!;
                  if (bookmarkedRecipe.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 280),
                          Icon(
                            Icons.no_food,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No recipes to show',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: bookmarkedRecipe.length,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      return RecipeTile(data: bookmarkedRecipe[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}