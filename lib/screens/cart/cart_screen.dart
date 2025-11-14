import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Cart.dart';
import '../../services/cart_service.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Cart>> futureCarts;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt("user_id");

    // 🔥 DEBUG — CEK apakah benar user_id tersimpan
    print("======================================");
    print(">>>> USER ID TERBACA DI CARTSCREEN = $userId");
    print("======================================");

    if (userId == null) {
      // Jika tidak ada user_id → keranjang pasti kosong
      setState(() {
        futureCarts = Future.value([]);
      });
      return;
    }

    // 🔥 LOG — cek API dipanggil ke mana
    print(">>>> MEMANGGIL API: get_cart.php?user_id=$userId");

    setState(() {
      futureCarts = CartService.getCart(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: FutureBuilder<List<Cart>>(
        future: futureCarts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika tidak ada data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Keranjang masih kosong"),
            );
          }

          final carts = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              itemCount: carts.length,
              itemBuilder: (context, index) {
                final cart = carts[index];

                return Dismissible(
                  key: Key(cart.cartId.toString()),
                  direction: DismissDirection.endToStart,

                  // DELETE ITEM
                  onDismissed: (direction) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    int? userId = prefs.getInt("user_id");

                    if (userId != null) {
                      await CartService.removeFromCart(userId, cart.productId);
                      loadCart(); // Refresh list
                    }
                  },

                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Spacer(),
                        SvgPicture.asset("assets/icons/Trash.svg"),
                      ],
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CartCard(cart: cart),
                  ),
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: FutureBuilder<List<Cart>>(
        future: futureCarts,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox.shrink();
          }

          return CheckoutCard(carts: snapshot.data!);
        },
      ),
    );
  }
}
