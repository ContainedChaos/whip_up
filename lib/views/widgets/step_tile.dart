import 'package:flutter/material.dart';
import 'package:whip_up/models/core/recipe.dart';

import '../../models/core/myRecipe.dart';

class StepTile extends StatelessWidget {
  final RecipeStep data;
  final int stepNumber;


  StepTile({required this.data, required this.stepNumber});

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
            'Step $stepNumber: ${data.description}',
            style: TextStyle(color: Colors.black, fontFamily: 'inter', fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
