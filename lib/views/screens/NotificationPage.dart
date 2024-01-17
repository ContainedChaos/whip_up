// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:whip_up/views/screens/notifications.dart';
// import '../../models/core/myRecipe.dart';
// import 'package:whip_up/views/screens/recipe_detail_page.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'recipe_detail_page.dart'; // Make sure to import your RecipeDetailPage
// import 'api_service.dart'; // Import your ApiService class
// import 'notification.dart'; // Import your Notification model
//
// class NotificationsPage extends StatefulWidget {
//   final String userId;
//
//   NotificationsPage({required this.userId});
//
//   @override
//   _NotificationsPageState createState() => _NotificationsPageState();
// }
//
// class _NotificationsPageState extends State<NotificationsPage> {
//   late Future<List<Notification>> _futureNotifications;
//
//   @override
//   void initState() {
//     super.initState();
//     _futureNotifications = ApiService().fetchNotifications(widget.userId);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//         // Add any other AppBar properties if needed
//       ),
//       body: FutureBuilder<List<Notification>>(
//         future: _futureNotifications,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             List<Notification> notifications =
//                 snapshot.data ?? [];
//             return ListView.builder(
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 Notification notification = notifications[index];
//                 return ListTile(
//                   title: Text(notification.message),
//                   subtitle: Text('Tap to view'),
//                   onTap: () {
// // Here you navigate to the RecipeDetailPage
// // Assuming you have a function to fetch recipe details
//                     Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => RecipeDetailPage(recipeId: notification.recipeId),
//                     ));
//                   },
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No notifications yet.'));
//           }
//         },
//       ),
//     );
//   }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whip_up/views/screens/recipe_detail_page.dart';
import 'package:provider/provider.dart';
import '../../models/core/myRecipe.dart';
import 'Notification_card.dart';
import 'notification_provider.dart';
import 'notification_service.dart';
import 'notifications.dart';

class NotificationsScreen extends StatefulWidget {
  final String userId;

  NotificationsScreen({required this.userId});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationService _notificationService;
  late Future<List<NotificationModel>> _notifications;
  Timer? _pollingTimer;


  @override
  void initState() {
    super.initState();
    _notificationService = NotificationService('http://192.168.2.105:8000');
    _notifications = _fetchNotifications();
    //_markNotificationsAsRead();
    _startNotificationPolling();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();  // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _startNotificationPolling() {
    _pollingTimer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      _fetchUnreadNotificationCount();
    });
  }

  Future<void> _fetchUnreadNotificationCount() async {
    try {
      final count = await _notificationService.getUnreadNotificationCount(widget.userId);
      Provider.of<NotificationProvider>(context, listen: false).setUnreadCount(count);
    } catch (e) {
      print('Error fetching unread notification count: $e');
    }
  }



  Future<void> _markNotificationsAsRead() async {
    try {
      await _notificationService.markAllNotificationsAsRead(widget.userId);
      // After marking as read, set the unread count to 0
      Provider.of<NotificationProvider>(context, listen: false).setUnreadCount(0);

    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }


  Future<List<NotificationModel>> _fetchNotifications() async {
    try {
      final notifications = await _notificationService.getNotifications(
          widget.userId);
      return notifications;
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Notifications',
          style: TextStyle(
              fontFamily: 'inter', fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        key: UniqueKey(), // Add a key to the FutureBuilder
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notification = snapshot.data![index];
                return ListTile(
                  title: Text(
                    notification.message,

                    style: TextStyle(
                      fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Reviewed on: ${notification.timestamp}'),
                  trailing: notification.read ? null : Icon(Icons.notifications_active, color: Colors.grey.shade900), // If no icon is showing, try changing the icon to see if it appears
                  onTap: () async {
                    if (!notification.read) {
                      await _notificationService.markNotificationAsRead(notification.id);
                      await _fetchUnreadNotificationCount();

                      MyRecipe recipeDetails = await _notificationService.fetchRecipeById(notification.recipeId);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(data: recipeDetails),
                      ));

                      // After marking it as read, update the local state to reflect the change
                      setState(() {
                        notification.read = true;
                      });

                    }
                    try {
                      print('Fetching recipe details for ID: ${notification
                          .recipeId}');
                      MyRecipe recipeDetails = await _notificationService
                          .fetchRecipeById(notification.recipeId);
                      print('Fetched recipe details: $recipeDetails');

                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailPage(data: recipeDetails),
                      ));
                    } catch (e) {
                      print('Error fetching recipe details: $e');
                    }
                  },
                  contentPadding:EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  tileColor: notification.read ? Colors.white : Colors.lightBlue[50] ,
                  // Remove default ListTile padding
                  dense: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
