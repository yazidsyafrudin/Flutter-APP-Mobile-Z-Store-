import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Cart.dart';
import '../../../services/cart_service.dart';

class CartCard extends StatefulWidget {
  final Cart cart;
  final VoidCallback? onRefresh;

  const CartCard({
    super.key,
    required this.cart,
    this.onRefresh,
  });

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // 🔥 UPDATE QTY API
  Future<void> updateQty(int newQty) async {
     if (newQty < 1) return; // minimal qty 1

     bool success = await CartService.updateQty(widget.cart.cartId, newQty);

     if (success) {
        widget.onRefresh?.call(); // refresh list cart
     } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal update jumlah")),
        );
     }
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GAMBAR PRODUK
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                cart.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        const SizedBox(width: 20),

        // INFO PRODUK + QTY BUTTON
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAMA PRODUK
              Text(
                cart.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // HARGA X QTY
              Text(
                "${formatRupiah(cart.price)} x ${cart.quantity}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 10),

              // 🔥 TOMBOL + dan –
              Row(
                children: [
                  // MINUS
                  IconButton(
                    onPressed: () => updateQty(cart.quantity - 1),
                    icon: const Icon(Icons.remove_circle_outline, size: 28),
                  ),

                  // JUMLAH
                  Text(
                    "${cart.quantity}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // PLUS
                  IconButton(
                    onPressed: () => updateQty(cart.quantity + 1),
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
