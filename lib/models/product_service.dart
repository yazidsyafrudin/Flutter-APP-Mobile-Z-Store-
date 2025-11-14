import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Product.dart'; // sesuaikan dengan path model Product kamu

class ProductService {
  // ================================
  // ⚠️ Ganti sesuai server kamu
  // Emulator Android: http://10.0.2.2/Api_zstore/
  // Real device: http://IP_WIFI/Api_zstore/
  // ================================
  static const String baseUrl = "http://localhost/Api_zstore/";

  // =====================================================
  // 1. AMBIL SEMUA PRODUK
  // =====================================================
  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse("${baseUrl}get_products.php"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        List<dynamic> data = jsonData['data'];
        return data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception('Gagal mengambil data produk (${response.statusCode})');
    }
  }

  // =====================================================
  // 2. AMBIL PRODUK BERDASARKAN ID
  // =====================================================
  static Future<Product> fetchProductById(int id) async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_product_by_id.php?id=$id"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['success'] == true) {
        return Product.fromJson(json['data']);
      } else {
        throw Exception(json['message']);
      }
    } else {
      throw Exception('Gagal mengambil detail produk (${response.statusCode})');
    }
  }

  // =====================================================
  // 3. ADD TO CART
  // =====================================================
  static Future<bool> addToCart(int userId, int productId, int qty) async {
    final response = await http.post(
      Uri.parse("${baseUrl}add_to_cart.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "product_id": productId,
        "quantity": qty,
      }),
    );

    final json = jsonDecode(response.body);
    return json["success"] == true;
  }

  // =====================================================
  // 4. GET CART
  // =====================================================
  static Future<List<dynamic>> getCart(int userId) async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_cart.php?user_id=$userId"));

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return json["data"];
    } else {
      throw Exception(json["message"]);
    }
  }

  // =====================================================
  // 5. REMOVE FROM CART
  // =====================================================
  static Future<bool> removeFromCart(int cartId) async {
    final response = await http.post(
      Uri.parse("${baseUrl}remove_from_cart.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"cart_id": cartId}),
    );

    final json = jsonDecode(response.body);
    return json["success"] == true;
  }

  // =====================================================
  // 6. CHECKOUT
  // =====================================================
  static Future<bool> checkout(int userId) async {
    final response = await http.post(
      Uri.parse("${baseUrl}checkout.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    final json = jsonDecode(response.body);
    return json["success"] == true;
  }

  // =====================================================
  // 7. GET ORDERS
  // =====================================================
  static Future<List<dynamic>> getOrders(int userId) async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_orders.php?user_id=$userId"));

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return json["data"];
    } else {
      throw Exception(json["message"]);
    }
  }

  // =====================================================
  // 8. ADD ADDRESS
  // =====================================================
  static Future<bool> addAddress({
    required int userId,
    required String name,
    required String phone,
    required String address,
    required String city,
    required String postal,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}add_address.php"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user_id": userId,
        "recipient_name": name,
        "phone": phone,
        "address_line": address,
        "city": city,
        "postal_code": postal,
      }),
    );

    final json = jsonDecode(response.body);
    return json["success"] == true;
  }

  // =====================================================
  // 9. GET ADDRESSES
  // =====================================================
  static Future<List<dynamic>> getAddresses(int userId) async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_addresses.php?user_id=$userId"));

    final json = jsonDecode(response.body);

    if (json["success"] == true) {
      return json["data"];
    } else {
      throw Exception(json["message"]);
    }
  }
}

