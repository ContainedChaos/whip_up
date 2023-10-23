import 'package:flutter/material.dart';
import 'package:whip_up/models/core/recipe.dart';

import '../../models/core/myRecipe.dart';

class StepTile extends StatelessWidget {
  final RecipeStep data;

  StepTile({required this.data});

  @override
  Widget build(BuildContext context) {
    Color greyColor = Colors.grey.shade300; // Create a custom color similar to Colors.grey

    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: greyColor, width: 1)), // Use greyColor here
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.description,
            style: TextStyle(color: Colors.black, fontFamily: 'inter', fontSize: 16, fontWeight: FontWeight.w600),
          ),
          if (data.description != null) // Use 'if' for conditional rendering
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                data.description,
                style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w500, height: 150 / 100),
              ),
            ),
        ],
      ),
    );
  }
}
