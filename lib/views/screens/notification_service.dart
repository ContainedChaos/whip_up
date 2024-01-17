import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../models/core/myRecipe.dart';

import '../../services/auth_service.dart';
import 'notification_provider.dart';
import 'notifications.dart';

import 'package:provider/provider.dart';

class NotificationService {
  final String baseUrl;

  NotificationService(this.baseUrl);

  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.2.105:8000/notifications/$userId/'),
    );
    if (response.statusCode == 200) {
      List<dynamic> notificationsJson = jsonDecode(response.body);
      List<NotificationModel> notifications = notificationsJson
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      return notifications;
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  // Future<void> markNotificationAsRead(String notificationId) async {
  //   final response = await http.patch(
  //     Uri.parse('http://192.168.2.105:8000/notifications/$notificationId/read'),
  //   );
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to mark notification as read');
  //   }
  // }

  Future<void> markAllNotificationsAsRead(String userId) async {
    final response = await http.patch(
      Uri.parse(
          'http://192.168.2.105:8000/notifications/mark-all-read/$userId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notifications as read');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final response = await http.patch(
      Uri.parse('http://192.168.2.105:8000/notifications/$notificationId/read'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notification as read');
    }
  }


  Future<MyRecipe> fetchRecipeById(String recipeId) async {
    final apiUrl = 'http://192.168.2.105:8000/getrecipe/$recipeId';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Full JSON Response: $jsonResponse'); // Log the full JSON response

      if (jsonResponse.containsKey('recipe')) {
        var recipeData = jsonResponse['recipe'];
        print(
            'Extracted Recipe Data: $recipeData'); // Log the extracted recipe data

        MyRecipe recipe = MyRecipe.fromJson(recipeData);
        print('MyRecipe Object: $recipe'); // Log the MyRecipe object

        return recipe;
      } else {
        throw Exception('Recipe key not found in response');
      }
    } else {
      print('Failed to fetch recipe. Status code: ${response.statusCode}');
      throw Exception('Failed to load recipe details');
    }
  }

  Future<int> getUnreadNotificationCount(String userId) async {
    final response = await http.get(
      Uri.parse('http://192.168.2.105:8000/notifications/$userId/count'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['unread_count'];
    } else {
      throw Exception('Failed to load unread notification count');
    }
  }

}
