import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'cook_time_input.dart';
import 'package:http/http.dart' as http;

class RecipeStep {
  String description;

  RecipeStep(this.description);

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }
}

class RecipeIngredient {
  String name;
  String quantity;

  RecipeIngredient(this.name, this.quantity);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}

class RecipeDetailsPage extends StatefulWidget {
  final String userId;

  RecipeDetailsPage({required this.userId});

  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  String title = '';
  int servings = 1;
  String difficulty = 'easy';
  int selectedHours = 0;
  int selectedMinutes = 0;
  List<String> selectedTags = [];
  List<String> availableTags = [
    'breakfast',
    'brunch',
    'lunch',
    'dinner',
    'salad',
    'drink'
  ];
  List<String> availableDifficulties = ['easy', 'medium', 'hard'];
  List<String> availableCuisines = [
    'Mexican',
    'Chinese',
    'Indian',
    'Italian',
    'French',
    'Others'
  ];
  String cuisine = 'Mexican';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextFormField(
              // ... (Recipe Title)
              decoration: InputDecoration(labelText: 'Recipe Title'),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            TextFormField(
              // ... (Number of Servings)
              decoration: InputDecoration(labelText: 'Number of Servings'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  servings = int.tryParse(value) ?? 1;
                });
              },
            ),
            // ... (Difficulty dropdown)
            Text(
              'Difficulty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: availableDifficulties.map((difficultyOption) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      difficulty = difficultyOption;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: difficulty == difficultyOption
                            ? Colors
                                .blue // Use a different color for the selected option
                            : Colors.grey,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(difficultyOption),
                  ),
                );
              }).toList(),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CookTimeInput(
                initialHours: selectedHours,
                initialMinutes: selectedMinutes,
                onHoursChanged: (hours) {
                  setState(() {
                    selectedHours = hours;
                  });
                },
                onMinutesChanged: (minutes) {
                  setState(() {
                    selectedMinutes = minutes;
                  });
                },
              ),
            ),
            DropdownButtonFormField<String>(
              value: cuisine,
              onChanged: (newValue) {
                setState(() {
                  cuisine = newValue!;
                });
              },
              items: availableCuisines
                  .map<DropdownMenuItem<String>>((cuisineOption) {
                return DropdownMenuItem<String>(
                  value: cuisineOption,
                  child: Text(cuisineOption),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Cuisine'),
            ),
            Text(
              'Tags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: [
                for (final tag in availableTags)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedTags.contains(tag)) {
                          selectedTags.remove(tag);
                        } else {
                          selectedTags.add(tag);
                        }
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedTags.contains(tag)
                              ? Colors
                                  .blue // Use a different color for selected tags
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(tag),
                    ),
                  ),
              ],
            ),

            // ... (Next button)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IngredientsAndStepsPage(
                      title: title,
                      servings: servings,
                      difficulty: difficulty,
                      cookTime: '$selectedHours hours $selectedMinutes minutes',
                      userId: widget.userId,
                      cuisine: cuisine,
                      tags: selectedTags,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}

class IngredientsAndStepsPage extends StatefulWidget {
  final String title;
  final int servings;
  final String difficulty;
  final String cookTime;
  final String userId;
  final String cuisine;
  final List<String> tags;

  IngredientsAndStepsPage({
    required this.title,
    required this.servings,
    required this.difficulty,
    required this.cookTime,
    required this.userId,
    required this.cuisine,
    required this.tags,
  });

  @override
  _IngredientsAndStepsPageState createState() =>
      _IngredientsAndStepsPageState();
}

class _IngredientsAndStepsPageState extends State<IngredientsAndStepsPage> {
  List<RecipeIngredient> ingredients = [];
  List<RecipeStep> steps = [];

  String uploadsPath = '';  // Define uploadsPath at the class level
  String imageName = '';

  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientQuantityController = TextEditingController();
  TextEditingController stepController = TextEditingController();

  File? selectedImage;

  Future<void> _copyImageToUploadsFolder(File selectedImage) async {
    try {
      if (selectedImage != null) {
        Directory uploadsDir = await getApplicationDocumentsDirectory();
        uploadsPath = '${uploadsDir.path}/uploads';

        if (!await Directory(uploadsPath).exists()) {
          await Directory(uploadsPath).create(recursive: true);
        }

        imageName =
            'recipe_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File newImage = await selectedImage.copy('$uploadsPath/$imageName');

        print("Image copied to: $uploadsPath/$imageName");

        setState(() {
          this.selectedImage = newImage;
        });
      }
    } catch (e) {
      print('Error copying image: $e');
    }
  }

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemp = File(image.path);

    await _copyImageToUploadsFolder(imageTemp);

    setState(() {
      this.selectedImage = imageTemp;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredients and Steps'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Text('Ingredients'),
            _buildIngredientList(),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: ingredientNameController,
                    decoration: InputDecoration(labelText: 'Ingredient Name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: ingredientQuantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      String name = ingredientNameController.text;
                      String quantity = ingredientQuantityController.text;

                      if (name.isNotEmpty && quantity.isNotEmpty) {
                        ingredients.add(RecipeIngredient(name, quantity));
                        ingredientNameController.clear();
                        ingredientQuantityController.clear();
                      }
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Steps'),
            _buildStepList(),
            TextFormField(
              controller: stepController,
              decoration: InputDecoration(labelText: 'Step'),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  String description = stepController.text;
                  if (description.isNotEmpty) {
                    steps.add(RecipeStep(description));
                    stepController.clear();
                  }
                });
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await _getImage();
              },
              child: Text('Select Image'),
            ),
            const SizedBox(
              height: 20,
            ),
            selectedImage != null
                ? Image.file(selectedImage!, height: 200, width: 200)
                : const Text("Please select an image"),

            ElevatedButton(
              onPressed: () async {
                if (selectedImage != null) {
                  print(uploadsPath);
                  print(imageName);
                  String imageUrl = '$uploadsPath/$imageName';

                  submitRecipe(
                    widget.userId,
                    widget.title,
                    widget.servings,
                    widget.difficulty,
                    widget.cookTime,
                    widget.cuisine,
                    widget.tags,
                    ingredients,
                    steps,
                    imageUrl,
                  );
                  print(imageUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an image'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        if (index < ingredients.length) {
          var ingredient = ingredients[index];
          return ListTile(
            title: Text('${ingredient.name} - ${ingredient.quantity}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  ingredients.removeAt(index);
                });
              },
            ),
          );
        }
        return Container(); // Return an empty container for out of bounds index
      },
    );
  }

  Widget _buildStepList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        if (index < steps.length) {
          var step = steps[index];
          return ListTile(
            title: Text('Step ${index + 1}: ${step.description}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  steps.removeAt(index);
                });
              },
            ),
          );
        }
        return Container(); // Return an empty container for out of bounds index
      },
    );
  }

  void submitRecipe(
    String userId,
    String title,
    int servings,
    String difficulty,
    String cookTime,
    String cuisine,
    List<String> selectedTags,
    List<RecipeIngredient> ingredients,
    List<RecipeStep> steps,
    String imageUrl,
  ) async {
    final apiUrl = 'http://192.168.0.104:8000/addrecipe/';

    final Map<String, dynamic> recipeData = {
      "userId": userId,
      "title": title,
      "servings": servings,
      "difficulty": difficulty,
      "cookTime": cookTime,
      "cuisine": cuisine,
      "tags": selectedTags,
      "ingredients":
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      "steps": steps.map((step) => step.toJson()).toList(),
      "imageUrl": imageUrl,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(recipeData),
      );

      if (response.statusCode == 200) {
        // Recipe added successfully
        print('Recipe added successfully');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Recipe added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Error adding recipe
        print('Error adding recipe. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception occurred
      print('Exception: $error');
    }
  }
}
