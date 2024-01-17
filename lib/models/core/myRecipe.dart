class RecipeIngredient {
  final String name;
  final String quantity;

  RecipeIngredient({
      required this.name,
      required this.quantity,
});

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      name: json['name'] as String,
      quantity: json['quantity'] as String,
    );
  }
}

class RecipeStep{
  final String description;

  RecipeStep({
    required this.description,
});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      description: json['description'] as String,
    );
  }
}

class MyRecipe {
  final String id;
  final String userId;
  final String title;
  final int servings;
  final String difficulty;
  final String cookTime;
  final String cuisine;
  final List<String> tags;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final String imageUrl;
  final int total_likes;
  final String username;

  MyRecipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.servings,
    required this.difficulty,
    required this.cookTime,
    required this.cuisine,
    required this.tags,
    required this.ingredients,
    required this.steps,
    required this.imageUrl,
    required this.total_likes,
    required this.username,
  });

  factory MyRecipe.fromJson(Map<String, dynamic> json) {
    // Null-aware operators are used to provide defaults in case of null values.
    return MyRecipe(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      servings: json['servings'] ?? 0,
      difficulty: json['difficulty'] ?? '',
      cookTime: json['cookTime'] ?? '',
      cuisine: json['cuisine'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      ingredients: (json['ingredients'] as List<dynamic>? ?? []).map((ingredient) {
        return RecipeIngredient.fromJson(ingredient);
      }).toList(),
      steps: (json['steps'] as List<dynamic>? ?? []).map((step) {
        return RecipeStep.fromJson(step);
      }).toList(),
      imageUrl: json['imageUrl'] ?? '',
      total_likes: json['total_likes'] ?? 0,
      username: json['username'] ?? '',
    );
  }
}




