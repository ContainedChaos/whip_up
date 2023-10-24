import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whip_up/model/user.dart';
import 'package:whip_up/Screens/Signup/api_service.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';

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

  File? selectedImage;
  String uploadsPath = '';  // Define uploadsPath at the class level
  String imageName = '';
  String imageUrl = '';

  Future<void> _copyImageToUploadsFolder(File selectedImage) async {
    try {
      if (selectedImage != null) {
        Directory uploadsDir = await getApplicationDocumentsDirectory();
        uploadsPath = '${uploadsDir.path}/uploads';

        if (!await Directory(uploadsPath).exists()) {
          await Directory(uploadsPath).create(recursive: true);
        }

        imageName =
        'user_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        File newImage = await selectedImage.copy('$uploadsPath/$imageName');

        print("Image copied to: $uploadsPath/$imageName");
        imageUrl = "$uploadsPath/$imageName";
        print(imageUrl);

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
          backgroundColor: Colors.teal.shade900,
          title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              color: AppColor.primary,
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      width: 130,
                      height: 130,
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: widget.user.image != null
                          ? Image.file(
                        File(widget.user.image!),
                        height: 100,
                        width: 100,
                      )
                          : Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _getImage,
                        child: Text(
                          'Change Profile Picture',
                          style: TextStyle(
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      selectedImage != null
                          ? Image.file(selectedImage!, height: 200, width: 200)
                          : const Text("Please select an image"),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: _getImage,
                        child: SvgPicture.asset(
                          'assets/icons/camera.svg',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),



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
                      _usernameController.text,
                      imageUrl,
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