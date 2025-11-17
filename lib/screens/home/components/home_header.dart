import 'package:flutter/material.dart';
import '../../cart/cart_screen.dart';
import '../../../services/cart_service.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';
import '../../notification/notification_screen.dart';
import '../../../services/notification_service.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 30,
        left: 10,
        right: 10,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF0D47A1),
            Color.fromARGB(255, 7, 119, 211),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔍 Search Bar
            const Expanded(
              child: SearchField(),
            ),

            const SizedBox(width: 16),

            // 🛒 Icon Keranjang dengan jumlah item
            FutureBuilder<int>(
              future: CartService.getCartCount(),
              builder: (context, snapshot) {
                final int count = snapshot.data ?? 0;

                return IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icons.svg",
                  numOfitem: count,
                  press: () {
                    Navigator.pushNamed(context, CartScreen.routeName)
                        .then((_) {
                      (context as Element).reassemble();
                    });
                  },
                );
              },
            ),

            const SizedBox(width: 8),

            // 🔔 Icon Notifikasi dengan jumlah unread
            FutureBuilder<int>(
              future: NotificationService.getUnreadCount(),
              builder: (context, snapshot) {
                final int notifCount = snapshot.data ?? 0;

                return IconBtnWithCounter(
                  svgSrc: "assets/icons/Bell Icons.svg",
                  numOfitem: notifCount,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      NotificationScreen.routeName,
                    ).then((_) {
                      (context as Element).reassemble();
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
