import 'dart:ui';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/models/core/myRecipe.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/views/screens/recipe_detail_page.dart';

class FeaturedRecipeCard extends StatelessWidget {
  final MyRecipe data;
  FeaturedRecipeCard({required this.data});

  @override
  Widget build(BuildContext context) {
    String basePath = 'http://192.168.2.105:8000/recipe-image/'; // Change this to your actual base URL
    String imagePath = data.imageUrl; // Assuming data.imageUrl is the relative path

    String imageUrl = basePath + imagePath;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDetailPage(data: data)));
      },
      // Card Wrapper
      child: Container(
        width: 180,
        height: 220,
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        // Recipe Card Info
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              height: 95,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black.withOpacity(0.26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    data.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 150 / 100, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                  ),
                  // Recipe Calories and Time
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/performance.png',
                          color: Colors.white,
                          width: 18,
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            data.difficulty,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 25),
                        Image.asset(
                          'assets/icons/wedding-dinner.png',
                          color: Colors.white,
                          width: 18,
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            data.servings.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/serving-dish.png',
                          color: Colors.white,
                          width: 18,
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            data.cuisine,
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 25),
                        SvgPicture.asset(
                          'assets/icons/like.svg',
                          color: Colors.white,
                          width: 14,
                          height: 14,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            data.total_likes.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
