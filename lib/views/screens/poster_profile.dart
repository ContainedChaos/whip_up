import 'package:flutter/material.dart';

import '../../Screens/Signup/api_service.dart';
import '../../model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PosterProfilePage extends StatefulWidget {
  final String userId;

  const PosterProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<PosterProfilePage> {
  late User _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true; // Set _isLoading to true when starting to load data
    });

    try {
      final apiUrl = 'http://192.168.2.105:8000/posterprofile/${widget.userId}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        _userData = jsonDecode(response.body);
        User user = _userData;
        print(_userData.username);

        // Do any other processing or set state as needed

      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Set _isLoading to false after completing the operation
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        centerTitle: true,
        title: Text('My Profile', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          :  ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          // Section 1 - Profile Picture Wrapper
          Container(
            color: Colors.grey.shade900,
            padding: EdgeInsets.symmetric(vertical: 24),
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle, // Define a circular shape
                    ),
                    // child: ClipOval(
                    //   child: _user.image != null && _user.image!.isNotEmpty
                    //       ? Image.network(
                    //     'http://192.168.2.105:8000/profile-picture/${_user.image}',
                    //     fit: BoxFit.cover,
                    //     loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    //       if (loadingProgress == null) {
                    //         // Image is fully loaded
                    //         return child;
                    //       } else {
                    //         // Image is still loading, you can show a loading indicator here
                    //         return CircularProgressIndicator();
                    //       }
                    //     },
                    //     errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                    //   )
                    //       : Image.asset(
                    //     'assets/images/pp.jpg',
                    //     height: 130,
                    //     width: 130,
                    //     fit: BoxFit.cover, // Make the image asset fill the circle
                    //   ),
                    // ),
                  ),
                ],
              ),
            ),
          ),
          // Section 2 - User Info Wrapper
          // Container(
          //   margin: EdgeInsets.only(top: 24),
          //   width: MediaQuery.of(context).size.width,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       UserInfoTile(
          //         margin: EdgeInsets.only(bottom: 16),
          //         label: 'Email',
          //         value: _user.email,
          //       ),
          //       UserInfoTile(
          //         margin: EdgeInsets.only(bottom: 16),
          //         label: 'Full Name',
          //         value: _user.username,
          //       ),
          //       UserInfoTile(
          //         margin: EdgeInsets.only(bottom: 16),
          //         label: 'Bio',
          //         value: _user.bio.toString(),
          //       ),
          //     ],
          //   ),
          // ),
          SizedBox(height: 100),
          Text('Username: ${_userData.username}'),
          Text('Email: ${_userData.email}'),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       AuthService().clearUserData();
          //       // Add your logout logic here
          //       // For example, you can navigate to the login page.
          //       Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(
          //           builder: (context) => WelcomePage(),
          //         ),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.grey.shade900, // Change the button color to grey
          //       padding: EdgeInsets.all(16), // Add padding to the button
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(
          //           Icons.logout, // Replace with the logout icon you want
          //           size: 24,
          //           color: Colors.white,// Adjust the size of the icon as needed
          //         ),
          //         SizedBox(width: 8), // Add spacing between the icon and text
          //         Text(
          //           'Log Out',
          //           style: TextStyle(
          //               fontSize: 14,
          //               color: Colors.white// Increase the font size
          //             // You can set other text styles here if needed
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}