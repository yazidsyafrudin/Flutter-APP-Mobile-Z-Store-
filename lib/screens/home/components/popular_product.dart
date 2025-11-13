import 'package:flutter/material.dart';
import '../../../components/product_card.dart';
import '../../../models/Product.dart';
import '../../../models/product_service.dart'; // 🔹 Tambahkan ini
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class PopularProducts extends StatefulWidget {
  final String selectedCategory;

  const PopularProducts({
    super.key,
    required this.selectedCategory,
  });

  @override
  State<PopularProducts> createState() => _PopularProductsState();
}

class _PopularProductsState extends State<PopularProducts> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada produk ditemukan"));
        }

        final allProducts = snapshot.data!;

        // 🔹 Filter produk berdasarkan kategori
        final filteredProducts = widget.selectedCategory == "ALL"
            ? allProducts.where((p) => p.isPopular).toList()
            : allProducts
                .where((product) =>
                    product.category.toLowerCase() ==
                    widget.selectedCategory.toLowerCase())
                .toList();

        // 🔹 Tentukan tampilan sesuai kategori
        Widget productList = widget.selectedCategory == "ALL"
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...List.generate(
                      filteredProducts.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ProductCard(
                          product: filteredProducts[index],
                          onPress: () => Navigator.pushNamed(
                            context,
                            DetailsScreen.routeName,
                            arguments: ProductDetailsArguments(
                              product: filteredProducts[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: filteredProducts[index],
                    onPress: () {
                      Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: ProductDetailsArguments(
                          product: filteredProducts[index],
                        ),
                      );
                    },
                  );
                },
              );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.selectedCategory == "ALL")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  title: "Popular Products",
                  press: () {
                    Navigator.pushNamed(context, ProductsScreen.routeName);
                  },
                ),
              ),
            const SizedBox(height: 10),
            productList,
          ],
        );
      },
    );
  }
}
