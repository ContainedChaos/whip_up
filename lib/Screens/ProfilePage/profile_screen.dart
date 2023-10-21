import 'package:flutter/material.dart';
import 'package:whip_up/model/user.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';
import 'package:whip_up/Screens/ProfilePage/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  ProfileScreen({required this.email});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  _loadProfile() async {
    try {
      _user = await ApiService().fetchUserProfile(widget.email);
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
        backgroundColor: Colors.blue[700],
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                  'assets/images/gojo.png'), // Provide a default or user's image path
              //child: _user.image == null ? Icon(Icons.person, size: 80, color: Colors.blue) : null,
            ),
            SizedBox(height: 10),
            Text(
              _user.username,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              _user.email,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            Spacer(),
            Divider(
              color: Colors.grey[400],
              height: 20,
              thickness: 0.5,
              indent: 0,
              endIndent: 0,
            ),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue[700], size: 24.0),
              title: Text('Email',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              subtitle: Text(_user.email,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue[700], size: 24.0),
              title: Text('Username',
                  style: TextStyle(fontSize: 18, color: Colors.grey[700])),
              subtitle: Text(_user.username,
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[700],
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(user: _user),
                  ),
                ).then((_) => _loadProfile());
              },
              child: Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}