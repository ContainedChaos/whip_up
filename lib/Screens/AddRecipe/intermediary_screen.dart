// import 'package:flutter/material.dart';
// import 'package:whip_up/views/screens/recipe_detail_page.dart';
//
// import 'add_recipe_screen.dart';
//
// class IntermediaryPage extends StatelessWidget {
//   final String userId;
//   IntermediaryPage({required this.userId});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           // Background Image
//           Image.asset(
//             'assets/images/beef_bibimbap_recipe.jpeg', // Replace with your image path
//             height: double.infinity,
//             width: double.infinity,
//             fit: BoxFit.cover,
//           ),
//           // Gradient Overlay
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   Colors.black.withOpacity(0),
//                   Colors.black.withOpacity(0),
//                   Colors.black.withOpacity(0.8),
//                   Colors.black.withOpacity(0.9),
//                 ],
//               ),
//             ),
//           ),
//           // Content
//           Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(height: 300),
//                 Text(
//                   "Share your masterpiece with us!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20, color: Colors.white),
//                 ),
//
//                 SizedBox(height: 120),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             RecipeDetailsPage(userId: userId),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.black, // Set button background color
//                     onPrimary: Colors.white, // Set text color
//                     side: BorderSide(color: Colors.white, width: 2), // Add white border
//                   ),
//                   child: Text(
//                     "Let's Get Cooking!",
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
