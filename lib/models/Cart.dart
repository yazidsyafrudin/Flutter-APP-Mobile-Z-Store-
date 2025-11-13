import 'Product.dart';
import '../models/product_service.dart';

class Cart {
  final Product product;
  final int numOfItem;

  Cart({
    required this.product,
    required this.numOfItem,
  });
}

// ⚠️ Fungsi ini hanya untuk test tampilan sementara
Future<List<Cart>> demoCarts() async {
  try {
    final products = await ProductService.fetchAllProducts();

    if (products.isEmpty) return [];

    // Ambil 3 produk pertama untuk simulasi cart
    return [
      Cart(product: products[0], numOfItem: 2),
      if (products.length > 1) Cart(product: products[1], numOfItem: 1),
      if (products.length > 2) Cart(product: products[2], numOfItem: 1),
    ];
  } catch (e) {
    print("Gagal memuat demo cart: $e");
    return [];
  }
}
