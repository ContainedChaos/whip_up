class RecipeIngredient {
  final String name;
  final String quantity;

  RecipeIngredient({
      required this.name,
      required this.quantity,
});
}

class RecipeStep{
  final String description;

  RecipeStep({
    required this.description,
});
}

class MyRecipe {
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

  MyRecipe({
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
  });
}




