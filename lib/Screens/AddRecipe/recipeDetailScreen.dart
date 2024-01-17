import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:whip_up/services/auth_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Map<String, dynamic>> futureRecipe;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRecipeById(widget.recipeId);
  }

  Future<Map<String, dynamic>> fetchRecipeById(String id) async {
    final apiUrl = 'http://192.168.2.105:8000/getrecipe/$id';

    // Retrieve the access token
    final Map<String, dynamic> userData = await AuthService().getUserData();
    final String accessToken = userData['access_token'] ??
        ''; // Use a default value or handle null properly.

    // Fetch the recipe using the passed id with the access token in the header
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    // Debugging: Print the response body
    print('Response Body: ${response.body}');

    // Assuming the endpoint returns a single recipe based on its ID.
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Debugging: Print the data received
      print('Data Received: $data');
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception('Failed to load recipe');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipe Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: futureRecipe,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Map<String, dynamic> recipe = snapshot.data!['recipe'];

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Title'),
                        subtitle: Text(recipe['title'] ?? 'Unknown Title'),
                      ),
                      ListTile(
                        title: Text('Cuisine'),
                        subtitle: Text(recipe['cuisine'] ?? 'Unknown'),
                      ),
                      ListTile(
                        title: Text('Servings'),
                        subtitle: Text(recipe['servings']?.toString() ?? 'Unknown'),
                      ),
                      ListTile(
                        title: Text('Difficulty'),
                        subtitle: Text(recipe['difficulty'] ?? 'Unknown'),
                      ),
                      ListTile(
                        title: Text('Cook Time'),
                        subtitle: Text(recipe['cookTime'] ?? 'Unknown'),
                      ),
                      ListTile(
                        title: Text('Tags'),
                        subtitle: Text(recipe['tags']?.join(', ') ?? 'Unknown'),
                      ),
                      Divider(),
                      Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (recipe['ingredients'] as List<dynamic>?)
                            ?.map((ingredient) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('${ingredient['name']} - ${ingredient['quantity']}'),
                        ))
                            .toList() ??
                            [],
                      ),
                      Divider(),
                      Text('Steps:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (recipe['steps'] as List<dynamic>?)
                            ?.map((step) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(step['description']),
                        ))
                            .toList() ??
                            [],
                      ),
                    ],
                  ),
                );

              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}