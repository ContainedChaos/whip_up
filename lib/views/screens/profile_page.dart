import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/Screens/Login/login_screen.dart';
import 'package:whip_up/views/screens/auth/welcome_page.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:whip_up/views/widgets/user_info_tile.dart';

import '../../Screens/ProfilePage/edit_profile_screen.dart';
import '../../Screens/Signup/api_service.dart';
import '../../model/user.dart';
import 'dart:io';

import '../../services/auth_service.dart'; // Import this for File class

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  ProfilePage({
    required this.userName,
    required this.userEmail,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    try {
      _user = await ApiService().fetchUserProfile(widget.userEmail);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading profile: $e");
      setState(() {
        _isLoading = false;
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
        title: Text('My Profile', style: TextStyle(fontFamily: 'inter', fontWeight: FontWeight.w400, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditProfileScreen(user: _user)),
              ).then((_) => _loadProfile());
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            ),
          )
        ], systemOverlayStyle: SystemUiOverlayStyle.light,
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
                    child: ClipOval(
                      child: _user.image != null && _user.image!.isNotEmpty
                          ? Image.network(
                        'http://192.168.0.114:8000/profile-picture/${_user.image}',
                          fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            // Image is fully loaded
                            return child;
                          } else {
                            // Image is still loading, you can show a loading indicator here
                            return CircularProgressIndicator();
                          }
                        },
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      )
                          : Image.asset(
                        'assets/images/pp.jpg',
                        height: 130,
                        width: 130,
                        fit: BoxFit.cover, // Make the image asset fill the circle
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Section 2 - User Info Wrapper
          Container(
            margin: EdgeInsets.only(top: 24),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Email',
                  value: _user.email,
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Full Name',
                  value: _user.username,
                ),
                UserInfoTile(
                  margin: EdgeInsets.only(bottom: 16),
                  label: 'Bio',
                  value: _user.bio.toString(),
                ),
              ],
            ),
          ),
          SizedBox(height: 100),
          Center(
            child: ElevatedButton(
              onPressed: () {
                AuthService().clearUserData();
                // Add your logout logic here
                // For example, you can navigate to the login page.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey.shade900, // Change the button color to grey
                padding: EdgeInsets.all(16), // Add padding to the button
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout, // Replace with the logout icon you want
                    size: 24, // Adjust the size of the icon as needed
                  ),
                  SizedBox(width: 8), // Add spacing between the icon and text
                  Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 14, // Increase the font size
                      // You can set other text styles here if needed
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}