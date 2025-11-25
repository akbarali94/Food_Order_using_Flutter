import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'orders_page.dart';

class profile extends StatelessWidget {
  const profile({super.key});

  @override
  Widget build(BuildContext context) {
    String username = FirebaseAuth.instance.currentUser?.email ?? "Guest User";

    return Scaffold(
      backgroundColor: const Color(0xfff7f8fa),

      body: Column(
        children: [

          // ✅ TOP PROFILE HEADER (Modern curved design)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 70, bottom: 35),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffff8a65), Color(0xfff4511e)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Color(0xfff4511e),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  username.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          ),

          // ✅ BODY OPTIONS
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionTitle("Account"),

                _optionItem(
                  title: "My Orders",
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrdersPage()),
                  ),
                ),

                _optionItem(
                  title: "Profile Update",
                  icon: Icons.edit_outlined,
                  onTap: () {},
                ),

                const SizedBox(height: 20),
                _sectionTitle("Preferences"),

                _optionItem(
                  title: "Languages",
                  icon: Icons.language,
                  onTap: () {},
                ),

                _optionItem(
                  title: "Settings",
                  icon: Icons.settings_outlined,
                  onTap: () {},
                ),

                const SizedBox(height: 20),
                _sectionTitle("Others"),

                _optionItem(
                  title: "Accounts",
                  icon: Icons.account_balance_wallet_outlined,
                  onTap: () {},
                ),

                _optionItem(
                  title: "Logout",
                  icon: Icons.logout,
                  color: Colors.red,
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Logged out successfully")),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ✅ Section Title Widget
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
      ),
    );
  }

  // ✅ Modern Option Card Widget
  Widget _optionItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.deepOrange,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      ),
    );
  }
}
