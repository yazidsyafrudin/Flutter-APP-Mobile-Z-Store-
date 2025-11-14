class Cart {
  final int cartId;
  final int productId;
  final String title;
  final double price;
  final int quantity;
  final double totalPrice;
  final String imageUrl;

  Cart({
    required this.cartId,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.imageUrl,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: int.parse(json["cart_id"].toString()),
      productId: int.parse(json["product_id"].toString()),
      title: json["title"],
      price: double.parse(json["price"].toString()),
      quantity: int.parse(json["quantity"].toString()),
      totalPrice: double.parse(json["total_price"].toString()),
      imageUrl: json["image_url"],
    );
  }
}
