import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/models/core/myRecipe.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/modals/search_filter_model.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';
//import '../screens/auth/recipeDetails.dart';
import 'package:whip_up/Screens/AddRecipe/recipeDetailScreen.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import '../../services/auth_service.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchInputController = TextEditingController();
  List<MyRecipe> _fetchedRecipes = [];


  void _performSearch() async {
    var query = searchInputController.text;
    if (query.isEmpty) return;

    var url = Uri.parse('http://192.168.2.104:8000/search/?query=${Uri.encodeComponent(query)}');

    // Fetch the access token
    final Map<String, dynamic> userData = await AuthService().getUserData();
    final String accessToken = userData['access_token'] ?? ''; // Handle null properly

    var response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['results'] as List;
      setState(() {
        _fetchedRecipes = data.map((recipe) => MyRecipe.fromJson(recipe)).toList();
      });
    } else {
      print('Failed to load recipes with status code: ${response.statusCode}');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Search Recipe',
          style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 90,
            color: Colors.grey.shade900,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 12),  // Right margin applied to the Container
                    child: TextField(
                      controller: searchInputController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        hintText: 'What do you want to eat?',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                        fillColor: Colors.grey.shade800,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        //prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: _performSearch,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (_) => _performSearch(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        builder: (context) {
                          return SearchFilterModel();
                        });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.secondary,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/magic.svg',
                      width: 25, // Set your desired width
                      height: 25,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _fetchedRecipes.isEmpty
                ? Center(child: Text('No recipes found', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: _fetchedRecipes.length,
              itemBuilder: (context, index) {
                // Pass the recipe data to the RecipeTile
                return RecipeTile(data: _fetchedRecipes[index]);
              },
            ),
          ),


        ],
      ),
    );
  }
}