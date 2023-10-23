import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:whip_up/model/user.dart';
import 'package:whip_up/services/auth_service.dart';
import 'package:whip_up/Screens/AddRecipe/recipeDetailScreen.dart';

Future<List<Map<String, dynamic>>> fetchRecipes() async {
  final apiUrl = 'http://192.168.0.104:8000/getrecipes/';

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
    return List<Map<String, dynamic>>.from(data['recipes']);
  } else {
    throw Exception('Failed to load recipes');
  }
}
class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Map<String, dynamic>>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recipes')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> recipe = snapshot.data![index];
                  return InkWell( // Wrapping ListTile with InkWell
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(recipeId: recipe['_id']),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(recipe['title'] ?? 'Unknown Title'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}