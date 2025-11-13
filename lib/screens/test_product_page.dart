import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../models/product_service.dart';

class TestProductPage extends StatefulWidget {
  const TestProductPage({super.key});

  @override
  State<TestProductPage> createState() => _TestProductPageState();
}

class _TestProductPageState extends State<TestProductPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    // ✅ Panggil API ambil semua produk
    futureProducts = ProductService.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tes API Produk'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada produk ditemukan"));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: p.images.isNotEmpty
                        ? Image.network(
                            p.images[0],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported),
                          )
                        : const Icon(Icons.image),
                    title: Text(p.title),
                    subtitle: Text("Rp ${p.price.toStringAsFixed(0)}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Klik untuk test detail (optional)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ID produk: ${p.id}")),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
