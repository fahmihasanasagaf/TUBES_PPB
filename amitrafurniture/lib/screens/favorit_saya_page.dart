import 'package:flutter/material.dart';

class FavoritSayaPage extends StatelessWidget {
  const FavoritSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> favorites = [
      {"image": "assets/images/produk1.jpg", "name": "Kursi Kayu Jati", "price": "Rp. 600.000"},
      {"image": "assets/images/produk2.jpg", "name": "Kursi Rotan", "price": "Rp. 450.000"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD0E2FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD0E2FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorit Saya',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        item["image"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: [
                        Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item["price"]!, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD0E2FF),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          ),
                          child: const Text("Detail"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
