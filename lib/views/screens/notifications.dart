import 'dart:convert';

import '../../models/core/myRecipe.dart';
import 'package:whip_up/views/screens/recipe_detail_page.dart';
import 'package:http/http.dart' as http;

// Notification model
import 'dart:convert';

import '../../services/auth_service.dart';

// Notification model
class NotificationModel {
  final String id; // Assuming `_id` from the backend is mapped to `id` here
  final String recipientId;
  final String message;
  final String recipeId;
   bool read;
  final DateTime timestamp;

  NotificationModel({
    required this.id,
    required this.recipientId,
    required this.message,
    required this.recipeId,
    required this.read,
    required this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      recipientId: json['recipient_id'],
      message: json['message'],
      recipeId: json['recipe_id'],
      read: json['read'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'recipient_id': recipientId,
      'message': message,
      'recipe_id': recipeId,
      'read': read,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

