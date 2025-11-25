import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'search.dart';
import 'cart.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;

  List<String> cartItems = [];

  final pages = [
    Container(), 
    const Search(),
    const cart(),
    const profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "MOTEL COURT 🍕",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),

      body: pageIndex == 0
          ? HomeContent(
              onAddToCart: (itemName, price, category) async {
                String username = FirebaseAuth.instance.currentUser?.email ?? "guest_user";

                await FirebaseFirestore.instance.collection('cart').add({
                  'username': username,
                  'product': itemName,
                  'price': price,
                  'category': category,
                  'timestamp': FieldValue.serverTimestamp(),
                });

                setState(() {
                  cartItems.add(itemName);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$itemName added to cart")),
                );
              },
            )
          : pages[pageIndex],

      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: pageIndex,
      selectedItemColor: Colors.orangeAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      onTap: (index) {
        setState(() => pageIndex = index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}

// ---------------- Home Content ----------------
class HomeContent extends StatelessWidget {
  final Function(String, String, String)? onAddToCart;

  const HomeContent({super.key, this.onAddToCart});

  // 🔥 Modern Menu Item Card
  Widget buildMenuItem(String image, String title, String desc, String price, String category) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(image, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          Text(desc, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 5),
          Text(price,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(120, 36),
            ),
            onPressed: () {
              if (onAddToCart != null) {
                onAddToCart!(title, price, category);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = [
      {'img': 'assets/images/plate.webp', 'title': 'PRAWNS', 'desc': 'SPICY FOOD', 'price': '₹10.00', 'cat': 'NON VEG'},
      {'img': 'assets/images/burger.webp', 'title': 'BURGER', 'desc': 'SPICY FOOD', 'price': '₹20.00', 'cat': 'FAST FOOD'},
      {'img': 'assets/images/pizza.webp', 'title': 'PIZZA', 'desc': 'SPICY FOOD', 'price': '₹30.00', 'cat': 'FAST FOOD'},
      {'img': 'assets/images/noodles.webp', 'title': 'NOODLES', 'desc': 'SPICY FOOD', 'price': '₹40.00', 'cat': 'FRIED'},
      {'img': 'assets/images/rice bowl.webp', 'title': 'CHEESE RICE', 'desc': 'SPICY FOOD', 'price': '₹50.00', 'cat': 'VEG'},
      {'img': 'assets/images/meals.webp', 'title': 'MEALS', 'desc': 'SPICY FOOD', 'price': '₹60.00', 'cat': 'VEG'},
      {'img': 'assets/images/fries.webp', 'title': 'FRIES', 'desc': 'SPICY FOOD', 'price': '₹50.00', 'cat': 'FRIED'},
      {'img': 'assets/images/16.webp', 'title': 'CORNS', 'desc': 'SPICY FOOD', 'price': '₹60.00', 'cat': 'VEG'},
      {'img': 'assets/images/fish.webp', 'title': 'FISH FRY', 'desc': 'SPICY FOOD', 'price': '₹80.00', 'cat': 'NON VEG'},
      {'img': 'assets/images/image.webp', 'title': 'FULL MEALS', 'desc': 'SPECIAL MEAL', 'price': '₹90.00', 'cat': 'VEG'},
      {'img': 'assets/images/daco.webp', 'title': 'BREAD', 'desc': 'LIGHT FOOD', 'price': '₹15.00', 'cat': 'VEG'},
    ];

    return ListView(
      children: [
        const SizedBox(height: 10),

        // 🌟 First Carousel (UPGRADED UI)
        CarouselSlider(
          items: [
            'assets/1.webp',
            'assets/2.webp',
            'assets/3.webp',
            'assets/4.webp',
            'assets/5.webp'
          ]
              .map((img) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Image.asset(img, fit: BoxFit.cover),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: 220,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 900),
            viewportFraction: 0.85,
          ),
        ),

        // ⭐ SECTION TITLE
        const SizedBox(height: 20),
        Center(
          child: Text(
            "MENU CARD",
            style: TextStyle(
                fontSize: 28,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 20),

        // ✅ MODERN GRID (Wrap)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 18,
            children: products
                .map((item) => buildMenuItem(
                      item['img']!,
                      item['title']!,
                      item['desc']!,
                      item['price']!,
                      item['cat']!,
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 30),

        // ✅ SECOND CAROUSEL
        CarouselSlider(
          items: [
            'assets/6.webp',
            'assets/7.webp',
            'assets/8.webp',
            'assets/9.webp',
            'assets/10.webp'
          ]
              .map((img) => ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      child: Image.asset(img, fit: BoxFit.cover),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            viewportFraction: 0.85,
          ),
        ),

        const SizedBox(height: 25),

        // ⭐ SWEET TITLE
        Center(
          child: Text(
            "SWEET ITEMS",
            style: TextStyle(
                fontSize: 28,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(height: 20),

        // ✅ SWEET GRID
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Wrap(
            spacing: 12,
            runSpacing: 18,
            children: [
              buildMenuItem('assets/images/16.webp', 'JAMOON', 'SWEET FOOD', '₹50.00', 'DESSERT'),
              buildMenuItem('assets/images/rice bowl.webp', 'WHITE RICE', 'PLAIN FOOD', '₹60.00', 'VEG'),
              buildMenuItem('assets/images/fish.webp', 'BUTTER FISH', 'TASTY FOOD', '₹70.00', 'NON VEG'),
              buildMenuItem('assets/images/beef.webp', 'CURRY', 'SPICY FOOD', '₹60.00', 'NON VEG'),
              buildMenuItem('assets/images/image.webp', 'FULL MEALS', 'SPECIAL FOOD', '₹80.00', 'VEG'),
              buildMenuItem('assets/images/daco.webp', 'BREAD', 'LIGHT FOOD', '₹20.00', 'VEG'),
            ],
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}
