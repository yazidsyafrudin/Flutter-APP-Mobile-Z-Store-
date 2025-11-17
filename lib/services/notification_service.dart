import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/notification.dart';

class NotificationService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/";

  static Future<List<AppNotification>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return [];

    final url = Uri.parse("${baseUrl}notification/get_notifications.php?user_id=$userId");
    final resp = await http.get(url);
    print("RESPONSE NOTIF: ${resp.body}");

    final jsonData = jsonDecode(resp.body);

    // 🔥 PERBAIKAN DI SINI
    if (jsonData['status'] == true && jsonData['data'] != null) {
      return (jsonData['data'] as List)
          .map((e) => AppNotification.fromJson(e))
          .toList();
    }

    return [];
  }

  static Future<bool> markAsRead(int notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return false;

    final url = Uri.parse("${baseUrl}notification/mark_notification_read.php");
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'notification_id': notificationId,
        'user_id': userId,
      }),
    );

    final jsonData = jsonDecode(resp.body);

    return jsonData['status'] == true;
  }

  static Future<bool> deleteNotification(int notificationId) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return false;

    final url = Uri.parse("${baseUrl}notification/delete_notification.php");
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'notification_id': notificationId,
        'user_id': userId,
      }),
    );

    final jsonData = jsonDecode(resp.body);

    return jsonData['status'] == true;
  }

  //======================================================
  // 🔹 ADD NOTIFICATION
  //======================================================
  static Future<bool> addNotification(String title, String message) async {
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');
  if (userId == null) return false;

  final url = Uri.parse("${baseUrl}notification/add_notification.php");

  final resp = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "user_id": userId,
      "title": title,
      "message": message,
    }),
  );

  final jsonData = jsonDecode(resp.body);
  return jsonData["status"] == true;
}

//======================================================
  // 🔹 GET UNREAD COUNT
  //======================================================
  static Future<int> getUnreadCount() async {
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt('user_id');
  if (userId == null) return 0;

  final url = Uri.parse("${baseUrl}notification/get_notification_count.php?user_id=$userId");
  final resp = await http.get(url);

  final jsonData = jsonDecode(resp.body);
  if (jsonData['success'] == true) {
    return jsonData['count'] ?? 0;
  }
  return 0;
}


}
