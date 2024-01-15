import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:http/http.dart' as http;
import '../../../models/core/myRecipe.dart';
import '../../../services/auth_service.dart';
import '../../screens/discover_delights.dart';
import '../category_card.dart';

Future<List<MyRecipe>> fetchRecipes() async {
  final apiUrl = 'http://192.168.2.104:8000/getrecipes/';

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
    )).toList();

    return recipes;
  } else {
    throw Exception('Failed to load recipes');
  }
}

class SearchFilterModel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        // Section 1 - Header
        Container(
          width: MediaQuery.of(context).size.width,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: AppColor.primaryExtraSoft,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 18), // Adjust the left padding as needed
                child: Text(
                  'Discover Delights',
                  style: TextStyle(
                    fontSize: 20, // Adjust the font size as needed
                    fontWeight: FontWeight.w600,
                    fontFamily: 'inter',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 60,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          width: MediaQuery.of(context).size.width,
          height: 300,
          color: Colors.white,
          child: Wrap(
            spacing: 16,
            runSpacing: 25,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'healthy'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Healthy', image: AssetImage('assets/images/healthy.jpg')),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'drink'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Drink', image: AssetImage('assets/images/drink.jpg')),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'seafood'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Seafood', image: AssetImage('assets/images/seafood.jpg')),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'dessert'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Dessert', image: AssetImage('assets/images/desert.jpg')),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'spicy'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Spicy', image: AssetImage('assets/images/spicy.jpg')),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DiscoverDelightsPage(recipes: fetchRecipes(), categoryTag: 'snack'),
                    ),
                  );
                },
                child: CategoryCard(title: 'Snack', image: AssetImage('assets/images/meat.jpg')),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
