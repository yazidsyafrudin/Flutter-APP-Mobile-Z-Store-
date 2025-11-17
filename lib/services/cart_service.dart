import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Cart.dart';

class CartService {
  static const String baseUrl = "http://10.0.2.2/Api_mobile_zstore/";

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

  // ==========================================================
  // 🔹 CHECKOUT
  // ==========================================================
  static Future<bool> checkout(
  List<Cart> items,
  int totalPrice,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt("user_id");

  if (userId == null) return false;

  final url = Uri.parse("${baseUrl}checkout.php");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "user_id": userId,
      "total_price": totalPrice,
      "items": items.map((i) => {
        "product_id": i.productId,
        "quantity": i.quantity,
        "price": i.price,
      }).toList(),
    }),
  );

  print("CHECKOUT RESPONSE: ${response.body}");

  return jsonDecode(response.body)["success"] == true;
}

// =====================================================================
// UPDATE QTY CART
// =====================================================================
static Future<bool> updateQty(int cartId, int quantity) async {
  final url = Uri.parse("${baseUrl}update_cart.php");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "cart_id": cartId,
      "quantity": quantity,
    }),
  );

  print("UPDATE QTY RESPONSE: ${response.body}");

  return jsonDecode(response.body)["success"] == true;
}

// ==========================================================
// 🔹 hitungan_keranjang
// ==========================================================
static Future<int> getCartCount() async {
  final prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt("user_id");

  if (userId == null) return 0;

  try {
    final response = await http.get(
      Uri.parse("${baseUrl}get_cart_count.php?user_id=$userId"),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      return int.parse(data["count"].toString());
    }

    return 0;
  } catch (e) {
    print("ERROR CART COUNT: $e");
    return 0;
  }
}

}
