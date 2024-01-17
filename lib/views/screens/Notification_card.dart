import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'notifications.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;

  NotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Apply a light blue color if the notification is not read, otherwise white
      color: notification.read ? Colors.white : Colors.lightBlue[50],
      child: ListTile(
        title: Text(
          notification.message,
          // Bold text for unread notifications
          style: TextStyle(
            fontWeight: notification.read ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text('Reviewed on: ${notification.timestamp}'),
        // Show a red notification icon for unread notifications
        trailing: notification.read ? null : Icon(Icons.circle_notifications, color: Colors.red),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        onTap: () {
          // TODO: Define what happens when you tap on the notification card
        },
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // Raised effect for unread notifications
      elevation: notification.read ? 1 : 3,
    );
  }
}
