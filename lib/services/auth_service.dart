import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String userTokenKey = 'access_token';
  static const String userImageKey = 'imageUrl';

  Future<void> storeUserData(String userId, String userEmail, String userName,
      String accessToken, String image) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userIdKey, userId);
    prefs.setString(userEmailKey, userEmail);
    prefs.setString(userNameKey, userName);
    prefs.setString(userTokenKey, accessToken);
    prefs.setString(userImageKey, image);
  }

  Future<Map<String, String>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(userIdKey);
    String? userEmail = prefs.getString(userEmailKey);
    String? userName = prefs.getString(userNameKey);
    String? accessToken = prefs.getString(userTokenKey);
    String? profilePicture = prefs.getString(userImageKey);

    return {
      'user_id': userId ?? '',
      'user_email': userEmail ?? '',
      'user_name': userName ?? '',
      'access_token': accessToken ?? '',
      'imageUrl': profilePicture ?? '',
    };
  }

  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userTokenKey);
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userImageKey);
  }
}
