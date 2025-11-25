import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'order_success.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  String username = FirebaseAuth.instance.currentUser?.email ?? "guest_user";
  String selectedPayment = 'UPI';

  // ======== YOUR LOGIC KEPT SAME (DON'T TOUCH) =========
  int _parseInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    if (v is String) {
      const unicodeZero = 0x0660;
      const unicodeNine = 0x0669;
      String normalized = v.split('').map((ch) {
        final c = ch.codeUnitAt(0);
        if (c >= unicodeZero && c <= unicodeNine) {
          return String.fromCharCode(c - unicodeZero + 48);
        }
        return ch;
      }).join();

      if (normalized.contains('.')) {
        normalized = normalized.split('.').first;
      }

      final cleaned = normalized.replaceAll(RegExp(r'[^0-9]'), '');
      return cleaned.isEmpty ? 0 : int.parse(cleaned);
    }
    return 0;
  }

  int _safeQty(dynamic v) {
    final q = int.tryParse(v?.toString() ?? '') ?? 0;
    return q <= 0 ? 1 : q;
  }

  int _computeUnitPrice(Map<String, dynamic> data) {
    final qty = _safeQty(data['quantity']);
    final tp = _parseInt(data['totalPrice']);
    if (tp > 0 && qty > 0) return tp ~/ qty;
    return _parseInt(data['price']);
  }

  int _computeRowTotal(Map<String, dynamic> data) {
    final qty = _safeQty(data['quantity']);
    final unit = _computeUnitPrice(data);
    return unit * qty;
  }

  Future<void> updateQuantity(String id, int qty, int unit) async {
    if (qty < 1) return;
    await FirebaseFirestore.instance.collection('cart').doc(id).update({
      'quantity': qty,
      'totalPrice': qty * unit,
      'price': unit,
    });
  }

  Future<void> deleteItem(String id) async {
    await FirebaseFirestore.instance.collection('cart').doc(id).delete();
  }

  Future<void> placeOrder(List<QueryDocumentSnapshot> cartItems, int total) async {
    final cleanedItems = cartItems.map((item) {
      final data = item.data() as Map<String, dynamic>;
      final qty = _safeQty(data['quantity']);
      final unit = _computeUnitPrice(data);
      return {
        ...data,
        'quantity': qty,
        'price': unit,
        'totalPrice': unit * qty,
      };
    }).toList();

    await FirebaseFirestore.instance.collection('orders').add({
      'username': username,
      'items': cleanedItems,
      'totalAmount': total,
      'paymentMethod': selectedPayment,
      'timestamp': FieldValue.serverTimestamp(),
    });

    for (var item in cartItems) {
      await FirebaseFirestore.instance.collection('cart').doc(item.id).delete();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSuccess()));
  }

  // =====================================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Cart"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('username', isEqualTo: username)
            .snapshots(),

        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final cartItems = snapshot.data!.docs;
          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty 🛍️",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          // ✅ BILL CALCULATION
          int subtotal = 0;
          for (var item in cartItems) {
            subtotal += _computeRowTotal(item.data() as Map<String, dynamic>);
          }

          final tax = (subtotal * 0.05).toInt();
          final delivery = 20;
          final total = subtotal + tax + delivery;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: cartItems.length,

                  itemBuilder: (context, index) {
                    final snap = cartItems[index];
                    final data = snap.data() as Map<String, dynamic>;

                    final name = data['product'] ?? '';
                    final qty = _safeQty(data['quantity']);
                    final unit = _computeUnitPrice(data);
                    final rowTotal = unit * qty;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/${name.toLowerCase()}.webp",
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset("assets/images/plate.webp", width: 80),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    )),

                                const SizedBox(height: 4),

                                Text("₹$unit each", style: TextStyle(color: Colors.grey.shade600)),

                                const SizedBox(height: 8),

                                Row(
                                  children: [
                                    _qtyButton(Icons.remove, () {
                                      updateQuantity(snap.id, qty - 1, unit);
                                    }),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text("$qty",
                                          style: const TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),

                                    _qtyButton(Icons.add, () {
                                      updateQuantity(snap.id, qty + 1, unit);
                                    }),
                                  ],
                                )
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Text("₹$rowTotal",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent)),
                              IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deleteItem(snap.id))
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

              _billBox(subtotal, tax, delivery, total, cartItems),
            ],
          );
        },
      ),
    );
  }

  // ======= UI COMPONENT: Quantity Button ========
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 20),
      ),
    );
  }

  // ======= UI COMPONENT: Bottom Bill Box ========
  Widget _billBox(int subtotal, int tax, int delivery, int total,
      List<QueryDocumentSnapshot> cartItems) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _billRow("Subtotal", "₹$subtotal"),
          _billRow("GST (5%)", "₹$tax"),
          _billRow("Delivery Fee", "₹$delivery"),
          const Divider(),
          _billRow("Total", "₹$total", bold: true, color: Colors.orangeAccent),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text("Payment Method",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          Row(
            children: [
              _payment("UPI"),
              _payment("Card"),
              _payment("COD"),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => placeOrder(cartItems, total),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Place Order",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _billRow(String title, String value,
      {bool bold = false, Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: 15, fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                  color: color)),
        ],
      ),
    );
  }

  Widget _payment(String name) {
    return Row(
      children: [
        Radio<String>(
          value: name,
          groupValue: selectedPayment,
          onChanged: (v) => setState(() => selectedPayment = v!),
        ),
        Text(name),
      ],
    );
  }
}
