import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/models/helper/recipe_helper.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/recipe_tile.dart';

class NewlyPostedPage extends StatelessWidget {
  final TextEditingController searchInputController = TextEditingController();
  final List<Recipe> newlyPostedRecipe = RecipeHelper.newlyPostedRecipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 0,
        title: Text('Newly Posted', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ), systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      // body: ListView.separated(
      //   padding: EdgeInsets.all(16),
      //   shrinkWrap: true,
      //   itemCount: newlyPostedRecipe.length,
      //   physics: BouncingScrollPhysics(),
      //   separatorBuilder: (context, index) {
      //     return SizedBox(height: 16);
      //   },
      //   itemBuilder: (context, index) {
      //     return RecipeTile(
      //       data: newlyPostedRecipe[index],
      //     );
      //   },
      // ),
    );
  }
}
