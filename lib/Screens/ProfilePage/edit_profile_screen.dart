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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.user.email;
    _usernameController.text = widget.user.username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ApiService().editUserProfile(
                    widget.user.email,
                    _emailController.text,
                    _usernameController.text,
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
              child: Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}

