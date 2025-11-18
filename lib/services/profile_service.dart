import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/user/";

  static Future<bool> saveProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    if (userId == null) return false;

    final url = Uri.parse("${baseUrl}save_profile.php");

    final resp = await http.post(url, body: {
      "user_id": userId.toString(),
      "first_name": firstName,
      "last_name": lastName,
      "phone": phone,
      "address": address
    });

    final data = jsonDecode(resp.body);
    return data["success"] == true;
  }
}
