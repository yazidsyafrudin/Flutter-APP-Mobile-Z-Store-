import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Categories({super.key, required this.onCategorySelected});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String selectedCategory = "ALL";

  List<Map<String, dynamic>> categories = [
    {"image": "assets/images/all_icon.png", "text": "ALL"},
    {"image": "assets/images/icon_kaos.png", "text": "T-Shirt"},
    {"image": "assets/images/sepatu.png", "text": "Sneakers"},
    {"image": "assets/images/hoodie.png", "text": "Hoodie"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) {
            String category = categories[index]["text"];
            return CategoryCard(
              image: categories[index]["image"],
              text: category,
              isActive: selectedCategory == category,
              press: () {
                setState(() {
                  selectedCategory = category;
                });
                widget.onCategorySelected(category);
              },
            );
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.image,
    required this.text,
    required this.press,
    required this.isActive,
  }) : super(key: key);

  final String image, text;
  final GestureTapCallback press;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: isActive
                  ? const Color.fromARGB(255, 4, 137, 246)
                  : const Color.fromARGB(255, 252, 252, 252),
              borderRadius: BorderRadius.circular(10),
              border: isActive
                  ? Border.all(color: Colors.blue, width: 2)
                  : null,
            ),
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
