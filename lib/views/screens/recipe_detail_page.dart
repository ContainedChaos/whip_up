import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/views/screens/full_screen_image.dart';
import 'package:whip_up/views/screens/poster_profile.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/ingridient_tile.dart';
import 'package:whip_up/views/widgets/review_tile.dart';
import 'package:whip_up/views/widgets/step_tile.dart';
import 'dart:io';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import '../../models/core/myRecipe.dart';
import 'package:http/http.dart' as http;
import '../../models/recipe_review.dart' ;
import '../../Screens/Signup/api_service.dart';
import '../../services/auth_service.dart';
import '../../views/widgets/recipe_review_card.dart';



class RecipeDetailPage extends StatefulWidget {
  final MyRecipe data;
  int total_likes;

  RecipeDetailPage({required this.data})
      : total_likes = data.total_likes,
        super();

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();


}

Future<void> postReview(String recipeId, String userId, String comment, double rating, BuildContext context ) async {
  final apiUrl = 'http://192.168.0.106:8000/postreview/';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'recipe_id': recipeId,
      'user_id': userId,
      'comment': comment,
      'rating': rating,
    }),
  );

  if (response.statusCode == 200) {
    // Handle success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Your review has been posted!'),
        duration: Duration(seconds: 3),
      ),
    );
  } else {
    // Handle error
    throw Exception('Failed to post review');
  }
}

Future<List<RecipeReview>> getReviews(String recipeId) async {
  final apiUrl = 'http://192.168.0.106:8000/getreviews/$recipeId/';
  print("RECIPEID in RECIPEDETAILPAGE: " + recipeId);
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    print('Response from getReviews: ${response.body}'); // Add this line to log the response
    List<dynamic> reviewsJson = json.decode(response.body)['reviews'];
    return reviewsJson.map((json) => RecipeReview.fromJson(json)).toList();
  } else {
    // Handle error
    throw Exception('Failed to load reviews');
  }
}
//


class _RecipeDetailPageState extends State<RecipeDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  late Future<List<RecipeReview>> _reviewsFuture;


  bool? _isBookmarked;
  bool? _isLiked;
  String user_id = '';
  int noOfServings = 0;
  int givenNoOfServings = 0;
  int customized = 0;
  final FlutterTts flutterTts = FlutterTts();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListeningForCommands = false;
  bool _isListeningAfterStep = false;
  int _currentStepIndex = 0;

  Future<void> refreshReviews() async {
    setState(() {
      _reviewsFuture = getReviews(widget.data.id); // Assuming _reviewsFuture is your Future<List<RecipeReview>>
    });
  }

  void _showReviewDialog(BuildContext context, String recipeId, String userId) {
    final TextEditingController _commentController = TextEditingController();
    double _rating = 0; // Initialize rating variable here

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView( // Ensure the dialog is scrollable if content exceeds screen height
            child: ListBody(
              children: [
                TextField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(hintText: 'Write your review here...'),
                ),
                SizedBox(height: 20), // Provide some spacing between the text field and the rating bar
                Text('Rate the recipe:', style: TextStyle(fontWeight: FontWeight.bold)),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _rating = rating; // Update the _rating variable
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await postReview(recipeId, userId, _commentController.text, _rating, context);
                  refreshReviews();
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  // Handle the error, such as showing a snackbar with the error message
                }
              },
              child: Text('Post Review'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _reviewsFuture = getReviews(widget.data.id);
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });

    noOfServings = widget.data.servings;
    givenNoOfServings = widget.data.servings;
    customized = 0;

    AuthService().getUserData().then((userData) {
      user_id = userData['user_id'] ?? 'default_user_id';
      getBookmarks(user_id, widget.data.id).then((value) {
        setState(() {
          _isBookmarked = value;
        });
      }).catchError((error) {
        print('Error: $error');
      });
      getLikes(user_id, widget.data.id).then((value) {
        setState(() {
          _isLiked = value;
        });
      }).catchError((error) {
        print('Error: $error');
      });
    });
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    print('Recognized Words: ${result.recognizedWords}');

    String command = result.recognizedWords?.toLowerCase() ?? '';

    if (command.isNotEmpty) {
      if (command.contains('next step')) {
        _currentStepIndex++;
        _speakRecipeSteps(_currentStepIndex);
      } else if (command.contains('go back')) {
        _currentStepIndex--;
        _speakRecipeSteps(_currentStepIndex);
      }
      else if (command.contains('again')) {
        _speakRecipeSteps(_currentStepIndex);
      }
      else if (command.contains('read the steps')) {
        setState(() {
          _currentStepIndex = 0;
        });
        _speakRecipeSteps(_currentStepIndex);
      }
    }
  }


  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _stopListeningForCommands() async {
    setState(() {
      _isListeningForCommands = false;
    });
    await _speechToText.stop();
  }

  Future<void> _speakRecipeSteps(int _currentStepIndex) async {
    await flutterTts.setLanguage("en-US");

    if (_currentStepIndex < 0){
      print("here");
      setState(() {
        _currentStepIndex = 0;
      });
      await flutterTts.speak("No steps before this");
    }

    else if (_currentStepIndex > widget.data.steps.length - 1){
      print("here2");
      setState(() {
        _currentStepIndex = 0;
      });
      await flutterTts.speak("You have reached the end");
    }

    else {
      print('Reading step: ${widget.data.steps[_currentStepIndex].description}');
      await flutterTts.speak("Step" + (_currentStepIndex + 1).toString() + ":" + widget.data.steps[_currentStepIndex].description);

      int stepLength = widget.data.steps[_currentStepIndex].description.length;
      int delayInSeconds = stepLength ~/ 10;

      int minDelayInSeconds = 6;
      int finalDelay = delayInSeconds > minDelayInSeconds ? delayInSeconds : minDelayInSeconds;

      await Future.delayed(Duration(seconds: finalDelay));

      await _startListening();
      await Future.delayed(Duration(seconds: 6));
      await _stopListening();
    }
  }

  Future<bool> getBookmarks(String user_id, String recipe_id) async {
    final apiUrl = 'http://192.168.0.106:8000/getbookmark/$user_id/$recipe_id/';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String status = responseData['status'];
      return status == "yes";
    } else {
      throw Exception('Failed to get bookmark status');
    }
  }

  Future<void> bookmarkRecipe(String user_id, String recipe_id) async {
    print("here");
    final apiUrl = 'http://192.168.0.106:8000/bookmark/$user_id/$recipe_id/';
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String status = responseData['status'];

      if (status == 'bookmarked') {
        // Update the _isBookmarked state based on the API response
        setState(() {
          _isBookmarked = true;
        });
      }
      else if (status == 'unbookmarked') {
        setState(() {
          _isBookmarked = false;
        });
      }
    } else {
      throw Exception('Failed to bookmark recipe');
    }
  }

  Future<bool> getLikes(String user_id, String recipe_id) async {
    final apiUrl = 'http://192.168.0.106:8000/getlike/$user_id/$recipe_id/';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String status = responseData['status'];
      return status == "yes";
    } else {
      throw Exception('Failed to get like status');
    }
  }

  Future<void> likeRecipe(String user_id, String recipe_id) async {
    print("here");
    final apiUrl = 'http://192.168.0.106:8000/like/$user_id/$recipe_id/';
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String status = responseData['status'];

      if (status == 'liked') {
        // Update the _isBookmarked state based on the API response
        setState(() {
          _isLiked = true;
          widget.total_likes++;
        });
      }
      else if (status == 'unliked') {
        setState(() {
          _isLiked = false;
          widget.total_likes--;
        });
      }
    } else {
      throw Exception('Failed to like recipe');
    }
  }

  Color appBarColor = Colors.transparent;

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {
          appBarColor = AppColor.primary;
        });
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {
          appBarColor = Colors.transparent;
        });
      }
    } else {
      setState(() {
        appBarColor = Colors.transparent;
      });
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String basePath = 'http://192.168.0.106:8000/recipe-image/'; // Change this to your actual base URL
    String imagePath = widget.data.imageUrl; // Assuming data.imageUrl is the relative path

    String imageUrl = basePath + imagePath;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AnimatedContainer(
          color: appBarColor,
          duration: Duration(milliseconds: 200),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,

            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  likeRecipe(user_id, widget.data.id);
                },
                icon: SvgPicture.asset(
                  _isLiked == true
                      ? 'assets/icons/heartu-filled.svg' // Show filled bookmark if _isBookmarked is true
                      : 'assets/icons/heartu.svg', // Use your heart icon
                  color: _isLiked == true ? Colors.red.shade700 : Colors.white,
                   // Set the width of the icon
                  height: 40,
                  // Set the color based on the like status
                ),
              ),
              IconButton(
                onPressed: () {
                  bookmarkRecipe(user_id, widget.data.id);
                },
                icon: SvgPicture.asset(
                  _isBookmarked == true
                      ? 'assets/icons/bookmark-filled.svg' // Show filled bookmark if _isBookmarked is true
                      : 'assets/icons/bookmark.svg',
                  // Show regular bookmark if _isBookmarked is false
                  color: _isBookmarked == true ? Colors.yellow.shade600 : Colors
                      .white,
                  width: 60, // Set the width of the icon
                  height: 60,
                ),
              ),
            ],
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
      // Post Review FAB
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              if (_speechToText.isNotListening && !_isListeningForCommands && _currentStepIndex == 0) {
                await flutterTts.setLanguage("en-US");
                await flutterTts.speak("How can I help you today?");
                await _startListening();
                await Future.delayed(Duration(seconds: 6));
                await _stopListening();
              }
              else if (_speechToText.isNotListening && !_isListeningForCommands && _currentStepIndex != 0) {
                await _startListening();
                await Future.delayed(Duration(seconds: 6));
                await _stopListening();
              }
              else if (_isListeningForCommands) {
                _stopListeningForCommands();
              } else {
                _stopListening();
              }
              setState(() {
                _isListeningAfterStep = !_isListeningAfterStep;
              });
            },
            tooltip: 'Listen',
            child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
            backgroundColor: _speechToText.isNotListening ? Colors.blue : Colors.red,
          ),
          Visibility(
            visible: showFAB(_tabController),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container (
                        width: MediaQuery.of(context).size.width,
                        height: 150,
                        color: Colors.white,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Write your review here...',
                          ),
                          maxLines: null,
                        ),
                      ),
                      actions: [
                        Row(
                          children: [
                            Container(
                              width: 120,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('cancel'),
                                style: TextButton.styleFrom(
                                  primary: Colors.grey[600],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Post Review'),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey.shade900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.edit),
              backgroundColor: Colors.grey.shade900,
            ),
          ),
        ],
      ),
      body: ListView(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Recipe Image
          GestureDetector(
            // onTap: () {
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullScreenImage(image: Image.asset(widget.data.photo, fit: BoxFit.cover))));
            // },
            child: Container(
              height: 280,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(gradient: AppColor.linearBlackTop),
                height: 280,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
            color: Colors.grey.shade900,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Calories and Time
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/serving-dish.png',
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text(
                        widget.data.cuisine,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/icons/performance.png',
                      color: Colors.white,
                      width: 18,
                      height: 18,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text(
                        widget.data.difficulty,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/like.svg',
                      color: Colors.white,
                      width: 17,
                      height: 17,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        widget.total_likes.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 20),
                    Image.asset(
                      'assets/icons/wedding-dinner.png',
                      color: Colors.white,
                      width: 20,
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 7),
                      child: Text(
                        noOfServings.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),

                    SizedBox(width: 20),
                    TextButton(
                      onPressed: () {
                        // Show servings customization dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            int servings = noOfServings; // Default value for servings
                            return AlertDialog(
                              backgroundColor: AppColor.secondarySoft,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12), // Adjust the borderRadius as needed
                              ),
                              //title: Text('Customize Servings'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 16), // Adjust the font size
                                    textAlign: TextAlign.center, // Center-align the text
                                    decoration: InputDecoration(
                                      hintText: 'Enter number of servings',
                                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Adjust padding
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      // Handle changes in the input field
                                      servings = int.tryParse(value) ?? servings;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle the selected number of servings (e.g., update UI)
                                    setState(() {
                                      noOfServings = servings;
                                      customized = 1;
                                    });
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.grey.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Apply'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: Colors.grey.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Customize',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    ],
                ),

                ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PosterProfilePage(userId: widget.data.userId),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade900,
                    padding: EdgeInsets.all(16),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PosterProfilePage(userId: widget.data.userId),
                        ),
                      );
                    },
                    child: Text(
                      widget.data.username,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                // Recipe Title
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    widget.data.title,
                    style: TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter'),
                  ),
                ),
                // Recipe Description
                Row(
                  children: [
                    Icon(
                      Icons.access_alarm, // Use the alarm icon
                      color: Colors.white, // Customize the color if needed
                      size: 18, // Customize the size if needed
                    ),
                    SizedBox(width: 7),
                    Text(
                      widget.data.cookTime,
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Wrap(
                  children: widget.data.tags.map((tag) {
                    return Container(
                      margin: EdgeInsets.only(right: 17),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800, // Customize the color
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Customize the border color
                          width: 1, // Customize the border width
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8), // Add padding here
                        child: Text(
                          tag,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          // Tabbar ( Ingridients, Tutorial, Reviews )
          Container(
            height: 60,
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: AppColor.secondary,
            child: TabBar(
              controller: _tabController,
              onTap: (index) {
                setState(() {
                  _tabController.index = index;
                });
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black.withOpacity(0.6),
              labelStyle: TextStyle(
                  fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Ingredients',
                ),
                Tab(
                  text: 'Tutorials',
                ),
                Tab(
                  text: 'Reviews',
                ),
              ],
            ),
          ),
          // IndexedStack based on TabBar index
          IndexedStack(
            index: _tabController.index,
            children: [
              // Ingridients
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.data.ingredients.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  RecipeIngredient data = widget.data.ingredients[index];

                  String quantityString = data.quantity;
                  double quantity = double.tryParse(RegExp(r'\d+(\.\d+)?').firstMatch(quantityString)?.group(0) ?? '0.0') ?? 0.0;
                  double newQuantity = (quantity / givenNoOfServings) * noOfServings;

                  String unit = RegExp(r'[^\d.]+').stringMatch(quantityString) ?? '';

                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[350] ?? Colors.black, width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 9,
                          child: Text(
                            data.name,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 150 / 100),
                          ),
                        ),
                        Flexible(
                          flex: 6,
                          child: Text(
                            customized == 0
                                ? data.quantity
                                : newQuantity % 1 == 0
                                ? '${newQuantity.toInt()} $unit'
                                : '${newQuantity.toStringAsFixed(2)} $unit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'inter',
                              color: Colors.grey[600] ?? Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // Tutorials
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.data.steps.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return StepTile(
                    data: widget.data.steps[index],
                    stepNumber: index + 1,
                  );
                },
              ),

              // Reviews
              FutureBuilder<List<RecipeReview>>(
                future: _reviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<RecipeReview> reviews = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: reviews.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return RecipeReviewCard(review: reviews[index]);
                      },
                    );
                  } else {
                    return Center(child: Text('No reviews yet'));
                  }
                },
              ),
              // end of FutureBuilder
            ],
          ),
          // end of IndexedStack
        ],
      ),
      // end of ListView
      // other Scaffold properties...
    );
  }
}
