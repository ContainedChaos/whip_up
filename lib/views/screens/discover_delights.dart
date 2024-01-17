import 'package:flutter/material.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';
import '../../models/core/myRecipe.dart';

class DiscoverDelightsPage extends StatefulWidget {
  final Future<List<MyRecipe>> recipes; // Keep the type as Future<List<MyRecipe>>
  final String categoryTag;

  DiscoverDelightsPage({required this.recipes, required this.categoryTag});

  @override
  _DiscoverDelightsPageState createState() => _DiscoverDelightsPageState();
}

class _DiscoverDelightsPageState extends State<DiscoverDelightsPage> {
  List<MyRecipe> filteredRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filterRecipes();
  }

  void filterRecipes() {
    widget.recipes.then((recipes) {
      setState(() {
        filteredRecipes = recipes.where((recipe) => recipe.tags.contains(widget.categoryTag)).toList();
        isLoading = false;
      });
    });
  }

  String capitalize(String s) {
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        centerTitle: true,
        title: Text(capitalize(widget.categoryTag), style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          if (isLoading)
            LinearProgressIndicator(), // Show loading indicator below AppBar while recipes are being loaded
          if (!isLoading && filteredRecipes.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(25), // Adjust the padding as needed
                child: Text(
                  'Nothing to show',
                  style: TextStyle(
                    color: Colors.grey, // Change the color as needed
                    fontSize: 18, // Change the font size as needed
                  ),
                ),
              ),
            ),
          if (!isLoading && filteredRecipes.isNotEmpty)
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: filteredRecipes.length,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16);
                      },
                      itemBuilder: (context, index) {
                        return RecipeTile(
                          data: filteredRecipes[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}


