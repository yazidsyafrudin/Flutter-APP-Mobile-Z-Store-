import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReorderService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/";

  static Future<bool> reorder(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");
    if (userId == null) return false;

    final url = Uri.parse("${baseUrl}reorder.php");

    final resp = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "order_id": orderId,
        "user_id": userId,
      }),
    );

    final json = jsonDecode(resp.body);
    return json["success"] == true;
  }
}
