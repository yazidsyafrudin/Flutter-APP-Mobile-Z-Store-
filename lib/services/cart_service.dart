import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Cart.dart';

class CartService {
  static const String baseUrl = "http://localhost/Api_zstore/";

  // ==========================================================
  // 🔹 GET CART BY USER ID
  // ==========================================================
  static Future<List<Cart>> getCart(int userId) async {
    final url = "${baseUrl}get_cart.php?user_id=$userId";
    print(">>> CALL API: $url");

    final response = await http.get(Uri.parse(url));

    print("=== RAW RESPONSE GET CART ===");
    print(response.body);

    final jsonData = jsonDecode(response.body);

    if (jsonData["success"] == true) {

      // Pastikan membaca key "data" (bukan "cart")
      List list = jsonData["data"];

      print("=== PARSED DATA LIST ===");
      print(list);

      return list.map((item) => Cart.fromJson(item)).toList();
    }

    return [];
  }

  // ==========================================================
  // 🔹 ADD TO CART
  // ==========================================================
  static Future<bool> addToCart(int userId, int productId, int qty) async {
    final url = "${baseUrl}add_to_cart.php";
    print(">>> CALL API ADD TO CART: $url");

    final response = await http.post(
      Uri.parse(url),
      body: {
        "user_id": userId.toString(),
        "product_id": productId.toString(),
        "quantity": qty.toString(),
      },
    );

    print("=== RAW RESPONSE ADD TO CART ===");
    print(response.body);

    final data = jsonDecode(response.body);

    return data["success"] == true;
  }

  // ==========================================================
  // 🔹 REMOVE FROM CART
  // ==========================================================
  static Future<bool> removeFromCart(int userId, int productId) async {
    final url = "${baseUrl}remove_from_cart.php";
    print(">>> CALL API REMOVE FROM CART: $url");

    final response = await http.post(
      Uri.parse(url),
      body: {
        "user_id": userId.toString(),
        "product_id": productId.toString(),
      },
    );

    print("=== RAW RESPONSE REMOVE FROM CART ===");
    print(response.body);

    final data = jsonDecode(response.body);

    return data["success"] == true;
  }
}
