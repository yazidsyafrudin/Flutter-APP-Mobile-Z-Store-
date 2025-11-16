class OrderItem {
  final int productId;
  final int price;
  final int quantity;
  final String title;
  final String imageUrl;

  OrderItem({
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json["product_id"],
      price: json["price"],
      quantity: json["quantity"],
      title: json["title"],
      imageUrl: json["image_url"],
    );
  }
}

class Order {
  final int id;
  final int totalPrice;
  final String date;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.totalPrice,
    required this.date,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"],
      totalPrice: json["total_price"],
      date: json["created_at"],
      items: (json["items"] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
    );
  }
}
