import 'dart:convert';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../views/screens/page_switcher.dart';
import 'cook_time_input.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

Dio dio = Dio();

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
  final String userEmail;
  final String userName;

  RecipeDetailsPage({required this.userId, required this.userEmail, required this.userName});

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
    'drink',
    'dessert',
    'snack',
    'side'
  ];
  List<String> availableDifficulties = ['easy', 'medium', 'hard'];
  List<String> availableCuisines = [
    'Bengali',
    'Mexican',
    'Chinese',
    'Indian',
    'Italian',
    'French',
    'Korean',
    'American',
    'Others'
  ];
  String cuisine = 'Mexican';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Recipe Details'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            SizedBox(height: 10), // Add margin at the beginning
            TextFormField(
              // ... (Recipe Title)
              decoration: InputDecoration(
                  labelText: 'Recipe Title',
                  labelStyle: TextStyle(
                  color: Colors.grey.shade800,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade800,
                      width: 2.0,
                  ), // Change the color of the line when focused
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600), // Change the color of the line when enabled
                ),
              ),
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
            ),
            SizedBox(height: 16), // Add spacing between fields
            TextFormField(
              // ... (Number of Servings)
              decoration: InputDecoration(
                  labelText: 'Number of Servings',
                  labelStyle: TextStyle(
                  color: Colors.grey.shade800,
              ),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                  color: Colors.grey.shade800,
                  width: 2.0,
                ), // Change the color of the line when focused
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600), // Change the color of the line when enabled
              ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  servings = int.tryParse(value) ?? 1;
                });
              },
            ),
            SizedBox(height: 20),
            // ... Difficulty dropdown
            Row(
              children: [
                Text(
                  'Difficulty',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 20), // Add spacing
                Wrap(
                  children: availableDifficulties.map((difficultyOption) {
                    final isSelected = difficulty == difficultyOption;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          difficulty = difficultyOption;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getDifficultyColor(difficultyOption)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? _getDifficultyColor(difficultyOption)
                                : _getDifficultyColor(difficultyOption),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          difficultyOption,
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : _getDifficultyColor(difficultyOption),

                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // ... Cook Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ // Add spacing
                Row(
                  children: [
                    Icon(
                      Icons.access_time, // Add an icon
                      size: 32,
                      color: Colors.grey.shade800,// Icon size
                    ),
                    SizedBox(width: 13),
                    CookTimeInput(
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
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
        Container(
          width: 100, // Set the desired width
          child:
            DropdownButtonFormField<String>(
              value: cuisine,

              onChanged: (newValue) {
                setState(() {
                  cuisine = newValue!;
                });
              },
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 17,
              ),
              items: availableCuisines
                  .map<DropdownMenuItem<String>>((cuisineOption) {
                return DropdownMenuItem<String>(
                  value: cuisineOption,
                  child: Text(cuisineOption),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Cuisine',
                labelStyle: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 17,// Change the color of the label text
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade800, // Change the border color when focused
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600, // Change the border color when enabled
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
        ),
            SizedBox(height: 16),
            // ... Tags
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8), // Add spacing
                Wrap(
                  children: availableTags.map((tag) {
                    final isSelected = selectedTags.contains(tag);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
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
                          color: isSelected ? _getTagColor(tag) : Colors.white,
                          border: Border.all(
                            color: isSelected ? _getTagColor(tag) : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black, // Change text color
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            // ... Next button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70), // Add left and right padding
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IngredientsAndStepsPage(
                            title: title,
                            servings: servings,
                            difficulty: difficulty,
                            cookTime: '$selectedHours hours $selectedMinutes minutes',
                            userId: widget.userId,
                            userName: widget.userName,
                            userEmail: widget.userEmail,
                            cuisine: cuisine,
                            tags: selectedTags,
                          ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade800, // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Border radius
                  ),
                  minimumSize: Size(200, 55), // Width and height
                ),
                child: Text('Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green.shade700;
      case 'medium':
        return Colors.blue.shade800;
      case 'hard':
        return Colors.deepOrange.shade800;
      default:
        return Colors.grey;
    }
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case 'breakfast':
        return Colors.green;
      case 'brunch':
        return Colors.deepPurple.shade300;
      case 'lunch':
        return Colors.orange;
      case 'dinner':
        return Colors.lightBlue.shade600;
      case 'salad':
        return Colors.lime;
      case 'drink':
        return Colors.cyan;
      case 'dessert':
        return Colors.pinkAccent;
      case 'snack':
        return Colors.purple.shade300;
      case 'side':
        return Colors.pink.shade300;
      default:
        return Colors.grey.shade600;
    }
  }

}

class IngredientsAndStepsPage extends StatefulWidget {
  final String title;
  final int servings;
  final String difficulty;
  final String cookTime;
  final String userId;
  final String userName;
  final String userEmail;
  final String cuisine;
  final List<String> tags;

  IngredientsAndStepsPage({
    required this.title,
    required this.servings,
    required this.difficulty,
    required this.cookTime,
    required this.userId,
    required this.userEmail,
    required this.userName,
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
  String imageUrl = '';

  TextEditingController ingredientNameController = TextEditingController();
  TextEditingController ingredientQuantityController = TextEditingController();
  TextEditingController stepController = TextEditingController();

  File? selectedImage;

  // Future<void> _copyImageToUploadsFolder(File selectedImage) async {
  //   try {
  //     if (selectedImage != null) {
  //       Directory uploadsDir = await getApplicationDocumentsDirectory();
  //       uploadsPath = '${uploadsDir.path}/uploads';
  //
  //       if (!await Directory(uploadsPath).exists()) {
  //         await Directory(uploadsPath).create(recursive: true);
  //       }
  //
  //       imageName =
  //           'recipe_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
  //       File newImage = await selectedImage.copy('$uploadsPath/$imageName');
  //
  //       print("Image copied to: $uploadsPath/$imageName");
  //
  //       setState(() {
  //         this.selectedImage = newImage;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error copying image: $e');
  //   }
  // }

  Future<String?> _copyImageToBackend(File selectedImage) async {
    try {
      if (selectedImage != null) {
        AuthService authService = AuthService();
        String? token = await authService.getAccessToken();
        String? email = await authService.getUserEmail();

        FormData formData = FormData.fromMap({
          'image': await MultipartFile.fromFile(
            selectedImage.path,
            filename: 'recipe_image.jpg',
            contentType: MediaType('image', 'jpeg'), // Adjust content type if needed
          ),
          'user_email': email,
        });

        print("user_email: $email");
        print("image: ${selectedImage.path}");


        Response response = await dio.post(
          'http://192.168.0.114:8000/upload-recipe-image/',
          data: formData,
          options: Options(headers: {'Authorization': token}),
        );

        print(response.statusCode);
        print(response.data);

        // Handle the response from the backend (e.g., retrieve the uploaded image URL)
        imageUrl = response.data['imageUrl'];

        setState(() {
          this.selectedImage = selectedImage;
        });

        return imageUrl;
      }
    } catch (e) {
      print('Error uploading image to backend: $e');
    }

    return null;
  }

  Future<void> _getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemp = File(image.path);

    setState(() {
      this.selectedImage = imageTemp;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ingredients and Steps'),
        backgroundColor: Colors.grey.shade900,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: stepController,
                    decoration: InputDecoration(labelText: 'Step'),
                  ),
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
              ],
            ),
            SizedBox(height: 50),
            GestureDetector(
              onTap: () async {
                await _getImage();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 70), // Adjust the padding as needed
                child: Container(
                  width: 200, // Set the width to make it a square
                  height: 250, // Set the height to make it a square
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    border: Border.all(
                      color: Colors.grey.shade600, // Green border
                      width: 1, // Border width
                    ),
                    borderRadius: BorderRadius.circular(20), // Set the border radius
                  ),
                  child: Center(
                    child: selectedImage != null
                        ? Image.file(selectedImage!, height: 150, width: 150) // Display the selected image
                        : Icon(
                      Icons.add_a_photo, // You can use another icon like Icons.add or Icons.camera_alt
                      size: 80, // Adjust the size of the icon
                      color: Colors.grey.shade700, // Green icon color
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70), // Adjust the padding as needed
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedImage != null) {
                    print(uploadsPath);
                    print(imageName);
                    String? imageUrl = await _copyImageToBackend(selectedImage!);

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
                      imageUrl!,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PageSwitcher(userEmail: widget.userEmail, userName: widget.userName, userId: widget.userId),
                      ),
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
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey.shade800, // Green background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                  ),
                  minimumSize: Size(double.infinity, 50), // Set the height
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16), // Add left and right padding
                  child: Text('Submit'),
                ),
              ),
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
    final apiUrl = 'http://192.168.0.114:8000/addrecipe/';

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

    final Map<String, dynamic> userData = await AuthService().getUserData();
    final String accessToken = userData['access_token'];
    print(accessToken);

    try {
      final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken", // Include the access token
          },
          body: jsonEncode(recipeData)
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
