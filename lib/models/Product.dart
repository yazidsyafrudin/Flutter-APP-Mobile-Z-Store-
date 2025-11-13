import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description, category;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.images,
    this.colors = const [],
    this.rating = 0.0,
    this.price = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
  });

  // 🔹 Tambahkan constructor fromJson
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isFavourite: json['isFavourite'] ?? false,
      isPopular: json['isPopular'] ?? false,
    );
  }
}
