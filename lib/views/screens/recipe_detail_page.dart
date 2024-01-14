import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/models/core/recipe.dart';
import 'package:whip_up/views/screens/full_screen_image.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/ingridient_tile.dart';
import 'package:whip_up/views/widgets/review_tile.dart';
import 'package:whip_up/views/widgets/step_tile.dart';
import 'dart:io';
import '../../models/core/myRecipe.dart';
import 'package:http/http.dart' as http;

import '../../services/auth_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final MyRecipe data;
  RecipeDetailPage({required this.data});

  @override
  _RecipeDetailPageState createState() => _RecipeDetailPageState();


}

class _RecipeDetailPageState extends State<RecipeDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  bool? _isBookmarked;
  String user_id = '';
  int noOfServings = 0;
  int givenNoOfServings = 0;
  int customized = 0;

  @override
  void initState() {
    super.initState();
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
    });
  }

  Future<bool> getBookmarks(String user_id, String recipe_id) async {
    final apiUrl = 'http://192.168.0.107:8000/getbookmark/$user_id/$recipe_id/';
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
    final apiUrl = 'http://192.168.0.107:8000/bookmark/$user_id/$recipe_id/';
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
    String basePath = 'http://192.168.0.107:8000/recipe-image/'; // Change this to your actual base URL
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
            centerTitle: true,
            title: Text('Recipe', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                onPressed: () {
                  bookmarkRecipe(user_id, widget.data.id);
                },
                icon: SvgPicture.asset(
                  _isBookmarked == true
                      ? 'assets/icons/bookmark-filled.svg' // Show filled bookmark if _isBookmarked is true
                      : 'assets/icons/bookmark.svg',       // Show regular bookmark if _isBookmarked is false
                  color: _isBookmarked == true ? Colors.yellow.shade600 : Colors.white,
                  width: 60, // Set the width of the icon
                  height: 60,
                ),
              ),
            ], systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
        ),
      ),
      // Post Review FAB
      floatingActionButton: Visibility(
        visible: showFAB(_tabController),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
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
                });
          },
          child: Icon(Icons.edit),
          backgroundColor: Colors.grey.shade900,
        ),
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
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(gradient: AppColor.linearBlackTop),
                height: 280,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          // Section 2 - Recipe Info
          Container(
            width: MediaQuery.of(context).size.width,
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
                // Recipe Title
                Container(
                  margin: EdgeInsets.only(bottom: 12, top: 16),
                  child: Text(
                    widget.data.title,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'inter'),
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
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
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
            width: MediaQuery.of(context).size.width,
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
              labelStyle: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w500),
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  text: 'Ingredients',
                ),
                Tab(
                  text: 'Tutorial',
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
              // Inside the ListView.builder in the RecipeDetailPage
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
                  );
                },
              ),
              // Reviews
              // ListView.builder(
              //   shrinkWrap: true,
              //   padding: EdgeInsets.zero,
              //   itemCount: widget.data.reviews.length,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return ReviewTile(data: widget.data.reviews[index]);
              //   },
              // )
            ],
          ),
        ],
      ),
    );
  }
}
