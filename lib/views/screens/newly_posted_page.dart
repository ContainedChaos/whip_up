import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';

import '../../models/core/myRecipe.dart';

class NewlyPostedPage extends StatefulWidget {
  final Future<List<MyRecipe>> recipes;

  NewlyPostedPage({required this.recipes});

  @override
  _NewlyPostedPageState createState() => _NewlyPostedPageState();
}

class _NewlyPostedPageState extends State<NewlyPostedPage> {
  late Future<List<MyRecipe>> _recipesFuture;

  @override
  void initState() {
    super.initState();
    _recipesFuture = widget.recipes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 0,
        title: Text('Newly Posted', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: FutureBuilder<List<MyRecipe>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<MyRecipe> recipes = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              itemCount: recipes.length,
              physics: BouncingScrollPhysics(),
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
            return Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }
}
