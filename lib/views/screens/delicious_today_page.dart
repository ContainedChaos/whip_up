import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/popular_recipe_card.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';

import 'package:flutter/material.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/popular_recipe_card.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';

import '../../models/core/myRecipe.dart';

class DeliciousTodayPage extends StatefulWidget {
  final Future<List<MyRecipe>> recipes; // Keep the type as Future<List<MyRecipe>>

  DeliciousTodayPage({required this.recipes});

  @override
  _DeliciousTodayPageState createState() => _DeliciousTodayPageState();
}

class _DeliciousTodayPageState extends State<DeliciousTodayPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        centerTitle: true,
        title: Text('All Recipes', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          //Section 1 - Popular Recipe
          Container(
            color: AppColor.primary,
            alignment: Alignment.topCenter,
            height: 210,
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<MyRecipe>>(
              future: widget.recipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<MyRecipe> recipes = snapshot.data!;
                  // Randomly select a recipe from the list
                  MyRecipe randomRecipe = recipes[Random().nextInt(recipes.length)];
                  return PopularRecipeCard(data: randomRecipe);
                } else {
                  return Text('No data available');
                }
              },
            ),
          ),
          //Section 2 - List of Recipes
          Container(
            padding: EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<MyRecipe>>(
              future: widget.recipes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // While waiting for the data to be fetched, you can show a loading indicator.
                  return LinearProgressIndicator();
                } else if (snapshot.hasError) {
                  // If there's an error, you can display an error message.
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  // When the data is available, you can access the length of the list.
                  List<MyRecipe> recipes = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: recipes.length, // Access the length of the list here
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 16);
                    },
                    itemBuilder: (context, index) {
                      return RecipeTile(
                        data: recipes[index],
                      );
                    },
                  );
                } else {
                  // Handle the case where there is no data.
                  return Text('No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


