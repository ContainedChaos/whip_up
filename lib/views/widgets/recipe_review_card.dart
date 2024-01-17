// import 'package:flutter/material.dart';
// import '../../models/recipe_review.dart';
// //import '../screens/auth/recipeDetails.dart';// Make sure your RecipeReview model has a String timestamp field
//
// class RecipeReviewCard extends StatelessWidget {
//   final RecipeReview review;
//
//   RecipeReviewCard({required this.review});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(review.userName, style: TextStyle(fontSize: 16.0)),
//             SizedBox(height: 8.0),
//             Text(review.comment, style: TextStyle(fontSize: 16.0)),
//             SizedBox(height: 8.0),
//             Text('Rating: ${review.rating.toString()}', style: TextStyle(fontSize: 14.0)),
//             SizedBox(height: 8.0),
//             Text('Date: ${review.timestamp}', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../../models/recipe_review.dart';

class RecipeReviewCard extends StatelessWidget {
  final RecipeReview review;

  RecipeReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0), // Adjust this value as needed
      child: Card(
        color: Colors.grey.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                review.userName,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.0),
              Text(
                review.comment,
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  _buildRatingStars(review.rating),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                'Date: ${review.timestamp}',
                style: TextStyle(fontSize: 12.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    int numberOfFullStars = rating.floor();
    int numberOfHalfStars = ((rating - numberOfFullStars) * 2).round();

    return Row(
      children: List.generate(
        5,
            (index) {
          if (index < numberOfFullStars) {
            return Icon(
              Icons.star,
              color: Colors.amber,
            );
          } else if (index == numberOfFullStars && numberOfHalfStars == 1) {
            return Icon(
              Icons.star_half,
              color: Colors.amber,
            );
          } else {
            return Icon(
              Icons.star_border,
              color: Colors.amber,
            );
          }
        },
      ),
    );
  }
}
