class RecipeReview {
  final String id; // Assuming your review objects have an id
  final String recipeId;
  final String userId;
  final String userName;
  final String comment;
  final double rating;
  final String timestamp; // Changed to String to hold the date part only

  RecipeReview({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp, // Changed to String
  });

  factory RecipeReview.fromJson(Map<String, dynamic> json) {
    return RecipeReview(
      id: json['_id'], // or 'id' depending on your JSON
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      userName: json['username'],
      comment: json['comment'],
      rating: (json['rating'] as num).toDouble(), // Ensuring double conversion
      timestamp: json['timestamp'], // No parsing needed, direct assignment
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipe_id': recipeId,
      'user_id': userId,
      'username': userName,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp, // Already a String, no conversion needed
    };
  }
}