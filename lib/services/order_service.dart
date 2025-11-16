import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class OrderService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/";

  static Future<List<Order>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("user_id");

    if (userId == null) return [];

    final url = Uri.parse("${baseUrl}get_orders.php?user_id=$userId");

    final response = await http.get(url);

    final jsonData = jsonDecode(response.body);

    if (jsonData["success"] != true) return [];

    List<Order> orders =
        (jsonData["data"] as List).map((e) => Order.fromJson(e)).toList();

    return orders;
  }
}
