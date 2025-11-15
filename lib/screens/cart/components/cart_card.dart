import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/Cart.dart';

class CartCard extends StatelessWidget {
  final Cart cart;

  const CartCard({super.key, required this.cart});

  String formatRupiah(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
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

        // INFO PRODUK — DIBUNGKUS EXPANDED BIAR TIDAK OVERFLOW
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cart.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,   // 🔥 Penting!
              ),

              const SizedBox(height: 8),

              Text(
                "${formatRupiah(cart.price)} x ${cart.quantity}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
