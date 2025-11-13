import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Product.dart'; // Huruf besar P karena file kamu "Product.dart" (lihat screenshot)

class ProductService {
  // ⚠️ Ganti dengan alamat server kamu
  // Jika pakai emulator Android Studio: gunakan http://10.0.2.2/
  // Jika pakai device nyata: gunakan IP lokal misalnya http://192.168.x.x/
  static const String baseUrl = "http://localhost/Api_zstore/";

  // 🔹 Ambil semua produk
  static Future<List<Product>> fetchAllProducts() async {
    final response = await http.get(Uri.parse("${baseUrl}get_products.php"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        List<dynamic> data = jsonData['data'];
        // ✅ tambahkan cast supaya tidak error tipe data
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

  // 🔹 Ambil 1 produk berdasarkan ID
  static Future<Product> fetchProductById(int id) async {
    final response =
        await http.get(Uri.parse("${baseUrl}get_product_by_id.php?id=$id"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['success'] == true) {
        return Product.fromJson(jsonData['data']);
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception('Gagal mengambil detail produk (${response.statusCode})');
    }
  }
}
