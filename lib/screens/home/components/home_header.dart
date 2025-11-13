import 'package:flutter/material.dart';
import '../../cart/cart_screen.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

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

            // 🛒 Icon Keranjang
            IconBtnWithCounter(
              svgSrc: "assets/icons/Cart Icons.svg",
              press: () => Navigator.pushNamed(
                context,
                CartScreen.routeName,
              ),
            ),

            const SizedBox(width: 8),

            // 🔔 Icon Notifikasi dengan badge merah (3)
            IconBtnWithCounter(
              svgSrc: "assets/icons/Bell Icons.svg",
              numOfitem: 3,
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
