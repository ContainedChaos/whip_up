// import 'package:flutter/material.dart';
// import 'package:whip_up/views/utils/AppColor.dart';
// import 'package:whip_up/views/widgets/custom_text_field.dart';
// import 'package:whip_up/views/widgets/modals/login_modal.dart';
// import 'package:whip_up/Screens/Signup/api_service.dart';
//
// import '../../../Screens/verify_screen.dart';
//
// class RegisterModal extends StatefulWidget {
//   @override
//   _RegisterModalState createState() => _RegisterModalState();
// }
//
// class _RegisterModalState extends State<RegisterModal> {
//   String _email = "";
//   String _username = "";
//   String _password = "";
//   String _retypePassword = "";
//   String? _emailError;
//   String? _usernameError;
//   String? _passwordError;
//   String? _retypePasswordError;
//
//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       children: [
//         Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height * 85 / 100,
//           padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//           ),
//           child: ListView(
//             shrinkWrap: true,
//             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//             physics: BouncingScrollPhysics(),
//             children: [
//               Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 35 / 100,
//                   margin: EdgeInsets.only(bottom: 20),
//                   height: 6,
//                   decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(20)),
//                 ),
//               ),
//               // Header
//               Container(
//                 margin: EdgeInsets.only(bottom: 24),
//                 child: Text(
//                   'Get Started',
//                   style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'inter'),
//                 ),
//               ),
//               // Form
//               CustomTextField(
//                 title: 'Email',
//                 hint: 'youremail@email.com',
//                 onChanged: (value) {
//                   setState(() {
//                     _email = value;
//                     _emailError = null; // Reset error message
//                   });
//                 },
//                 errorText: _emailError,
//               ),
//               CustomTextField(
//                 title: 'Full Name',
//                 hint: 'Your Full Name',
//                 margin: EdgeInsets.only(top: 16),
//                 onChanged: (value) {
//                   setState(() {
//                     _username = value;
//                     _usernameError = null; // Reset error message
//                   });
//                 },
//                 errorText: _usernameError,
//               ),
//               CustomTextField(
//                 title: 'Password',
//                 hint: '**********',
//                 obscureText: true,
//                 margin: EdgeInsets.only(top: 16),
//                 onChanged: (value) {
//                   setState(() {
//                     _password = value;
//                     _passwordError = null; // Reset error message
//                   });
//                 },
//                 errorText: _passwordError,
//               ),
//               CustomTextField(
//                 title: 'Retype Password',
//                 hint: '**********',
//                 obscureText: true,
//                 margin: EdgeInsets.only(top: 16),
//                 onChanged: (value) {
//                   setState(() {
//                     _retypePassword = value;
//                     _retypePasswordError = null; // Reset error message
//                   });
//                 },
//                 errorText: _retypePasswordError,
//               ),
//
//               // Register Button
//               Container(
//                 margin: EdgeInsets.only(top: 32, bottom: 6),
//                 width: MediaQuery.of(context).size.width,
//                 height: 60,
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     // Reset error messages
//                     _emailError = null;
//                     _usernameError = null;
//                     _passwordError = null;
//                     _retypePasswordError = null;
//
//                     // Validate fields
//                     if (_username.isEmpty) {
//                       _usernameError = 'Username is required.';
//                     }
//
//                     if (_email.isEmpty) {
//                       _emailError = 'Email is required.';
//                     } else if (!RegExp(
//                         r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                         .hasMatch(_email)) {
//                       _emailError = 'Invalid email format.';
//                     }
//
//                     if (_password.isEmpty) {
//                       _passwordError = 'Password is required.';
//                     } else if (!RegExp(
//                         r"^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{6,}$")
//                         .hasMatch(_password)) {
//                       _passwordError =
//                       'Password must meet the criteria (e.g., at least 6 characters, 1 capital letter, and 1 digit).';
//                     }
//
//                     if (_retypePassword.isEmpty) {
//                       _retypePasswordError = 'Retype Password is required.';
//                     } else if (_retypePassword != _password) {
//                       _retypePasswordError = 'Passwords do not match.';
//                     }
//
//                     if (_usernameError == null &&
//                         _emailError == null &&
//                         _passwordError == null &&
//                         _retypePasswordError == null) {
//                       // All fields are valid, proceed with registration
//                       final apiService = ApiService();
//                       final response =
//                       await apiService.signup(_username, _email, _password);
//
//                       if (response['message'] == 'User Created') {
//                         // Handle successful signup, e.g., navigate to another page or show a success message
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 VerifyScreen(userId: response["userId"]),
//                           ),
//                         );
//                       } else if (response['message'] == 'Customer Exists') {
//                         // Handle email already in use
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('User already exists'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       } else {
//                         // Handle errors, e.g., show an error message to the user
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content:
//                             Text(response['message'] ?? 'Unknown error occurred'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: Text(
//                     'Register',
//                     style: TextStyle(
//                         color: AppColor.secondary,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'inter'),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     primary: AppColor.primarySoft,
//                   ),
//                 ),
//               ),
//               // Login text button
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   showModalBottomSheet(
//                     context: context,
//                     backgroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(20),
//                             topRight: Radius.circular(20))),
//                     isScrollControlled: true,
//                     builder: (context) {
//                       return LoginModal();
//                     },
//                   );
//                 },
//                 style: TextButton.styleFrom(
//                   primary: Colors.white,
//                 ),
//                 child: RichText(
//                   text: TextSpan(
//                     text: 'Have an account? ',
//                     style: TextStyle(color: Colors.grey),
//                     children: [
//                       TextSpan(
//                         style: TextStyle(
//                           color: AppColor.primary,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'inter',
//                         ),
//                         text: 'Log in',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
