import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/models/core/myRecipe.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/views/screens/recipe_detail_page.dart';

class RecommendationRecipeCard extends StatelessWidget {
  final MyRecipe data;
  RecommendationRecipeCard({required this.data});
  @override
  Widget build(BuildContext context) {
    String basePath = 'http://192.168.2.104:8000/recipe-image/'; // Change this to your actual base URL
    String imagePath = data.imageUrl; // Assuming data.imageUrl is the relative path

    String imageUrl = basePath + imagePath;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RecipeDetailPage(data: data)));
      },
      child: Container(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Photo
            Container(
              height: 120,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueGrey,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Recipe title
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 8),
              padding: EdgeInsets.only(left: 4),
              child: Text(
                data.title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'inter'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Recipe calories and time
            Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/fire-filled.svg',
                    color: Colors.black,
                    width: 12,
                    height: 12,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      data.difficulty,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.alarm,
                    size: 12,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(
                      data.cookTime,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
