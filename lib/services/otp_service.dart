import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OtpService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/auth/";

  static Future<bool> sendOtp(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    final response = await http.post(
      Uri.parse("${baseUrl}send_otp.php"),
      body: {
        "user_id": userId.toString(),
        "phone": phone,
      },
    );

    final data = jsonDecode(response.body);
    return data["success"] == true;
  }

  static Future<bool> verifyOtp(String otp) async {
    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    final response = await http.post(
      Uri.parse("${baseUrl}verify_otp.php"),
      body: {
        "user_id": userId.toString(),
        "otp": otp,
      },
    );

    final data = jsonDecode(response.body);
    return data["success"] == true;
  }
}
