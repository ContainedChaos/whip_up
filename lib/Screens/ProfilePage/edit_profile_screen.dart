import 'package:flutter/material.dart';
import 'package:whip_up/model/user.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.teal.shade900,
          title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.teal.shade800, // Change the label text color
                  fontSize: 17,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal.shade700, // Change the border color when focused
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.teal.shade600, // Change the border color when enabled
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService().editUserProfile(
                    widget.user.email,
                    _usernameController.text
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error updating profile: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            style: ElevatedButton.styleFrom(
                primary: Colors.teal.shade900, // Change the background color
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
               ),
            ),
              child: Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

