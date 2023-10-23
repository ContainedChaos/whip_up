import 'package:flutter/material.dart';
import 'package:whip_up/models/core/recipe.dart';

class ReviewTile extends StatelessWidget {
  final Review data;
  ReviewTile({required this.data});

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
          // Review username
          Text(
            data.username,
            style: TextStyle(color: Colors.black, fontFamily: 'inter', fontSize: 16, fontWeight: FontWeight.w600),
          ),
          // User review
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              data.review,
              style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w500, height: 150 / 100),
            ),
          ),
        ],
      ),
    );
  }
}

