import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _controller = TextEditingController();
  String selectedCategory = "ALL";
  String searchText = "";

  final List<Map<String, String>> allProducts = [
    {'title': 'PRAWNS', 'category': 'NON VEG'},
    {'title': 'BURGER', 'category': 'FAST FOOD'},
    {'title': 'PIZZA', 'category': 'FAST FOOD'},
    {'title': 'NOODLES', 'category': 'FRIED'},
    {'title': 'CHEESE RICE', 'category': 'VEG'},
    {'title': 'MEALS', 'category': 'VEG'},
    {'title': 'FRIES', 'category': 'FRIED'},
    {'title': 'CORNS', 'category': 'VEG'},
  ];

  List<String> categories = ['ALL', 'VEG', 'NON VEG', 'FAST FOOD', 'FRIED'];

  @override
  Widget build(BuildContext context) {
    var filteredProducts = allProducts.where((item) {
      bool categoryMatch =
          selectedCategory == "ALL" || item['category'] == selectedCategory;
      bool searchMatch =
          item['title']!.toLowerCase().contains(searchText.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => searchText = v),
                decoration: InputDecoration(
                  hintText: "Search food items...",
                  prefixIcon: const Icon(Icons.search, color: Colors.orangeAccent),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ),

          // 🟠 CATEGORY FILTER CHIPS
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String cat = categories[index];
                bool selected = cat == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                          color: selected ? Colors.white : Colors.black87),
                    ),
                    selected: selected,
                    selectedColor: Colors.orangeAccent,
                    backgroundColor: Colors.white,
                    elevation: selected ? 4 : 0,
                    onSelected: (_) =>
                        setState(() => selectedCategory = cat),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // ✅ RESULTS
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(
                    child: Text(
                      "No matching products 😕",
                      style:
                          TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      var product = filteredProducts[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orangeAccent.shade100,
                            radius: 28,
                            child: const Icon(Icons.fastfood,
                                color: Colors.deepOrange),
                          ),
                          title: Text(
                            product['title']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            product['category']!,
                            style:
                                const TextStyle(color: Colors.black54),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.orangeAccent),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
