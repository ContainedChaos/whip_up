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
  TextEditingController _bioController = TextEditingController();
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _bioController.text = widget.user.bio.toString();
  }

  String uploadsPath = '';
  String imageName = '';
  String imageUrl = '';
  String bio = '';

  Future<void> _copyImageToUploadsFolder(File selectedImage) async {
    try {
      if (selectedImage != null) {
        Directory uploadsDir = await getApplicationDocumentsDirectory();
        uploadsPath = '${uploadsDir.path}/uploads';

        if (!await Directory(uploadsPath).exists()) {
          await Directory(uploadsPath).create(recursive: true);
        }

        imageName = 'user_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
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
        backgroundColor: Colors.grey.shade900,
        title: Text("Edit Profile"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Updated onTap callback to immediately replace the image
                    _getImage();
                  },
                  child: Container(
                    width: 130,
                    height: 130,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Stack(
                      children: [
                        ClipOval(
                          child: selectedImage != null
                              ? Image.file(
                            selectedImage!,
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          )
                              : (widget.user.image != null
                              ? Image.file(
                            File(widget.user.image!),
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                          )
                              : Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.white,
                          )),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ClipOval(
                            child: Container(
                              width: 40,
                              height: 40,
                              color: Colors.grey.shade600,
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    SizedBox(width: 8),
                  ],
                ),
              ],
            ),

            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.grey.shade800, // Change the label text color
                  fontSize: 17,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade700, // Change the border color when focused
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600, // Change the border color when enabled
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: "Bio",
                labelStyle: TextStyle(
                  color: Colors.grey.shade800, // Change the label text color
                  fontSize: 17,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade700, // Change the border color when focused
                    width: 2.0,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade600, // Change the border color when enabled
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
                      _bioController.text,
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
                primary: Colors.grey.shade900, // Change the background color
                minimumSize: Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
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