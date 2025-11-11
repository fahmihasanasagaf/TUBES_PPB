import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB3D9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // =====================
              // TOP BAR
              // =====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu, size: 30),
                    Container(
                      width: 230,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text("Search..."),
                        ],
                      ),
                    ),
                    const Icon(Icons.settings, size: 30),
                  ],
                ),
              ),

              // =====================
              // CATEGORY ICONS
              // =====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategory(Icons.chair, "Kursi"),
                    _buildCategory(Icons.bed_rounded, "Ranjang"),
                    _buildCategory(Icons.table_bar, "Meja"),
                    _buildCategory(Icons.weekend, "Sofa"),
                  ],
                ),
              ),

              // =====================
              // PROMO BANNER
              // =====================
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  children: [
                    _buildPromoCard(
                      "BIG SALE\nUP TO 50%",
                      "assets/images/Kursi.png",
                    ),
                    _buildPromoCard(
                      "NEW PRODUCT\nDiscount 20%\nFirst Transaction",
                      "assets/images/Kursi.png",
                      button: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // =====================
              // TAB MENU
              // =====================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTab("Semua", true),
                  _buildTab("Populer", false),
                  _buildTab("Kursi", false),
                  _buildTab("Meja", false),
                ],
              ),

              const SizedBox(height: 10),

              // =====================
              // PRODUCT GRID
              // =====================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.70,
                  children: [
                    _buildProduct("Laci Meja Kayu", "Rp.500.000", "assets/images/lemari.png"),
                    _buildProduct("Kursi Kayu", "Rp.400.000", "assets/images/Kursi.png"),
                    _buildProduct("Sofa", "Rp.5.000.000", "assets/images/sofa.png"),
                    _buildProduct("GrandWood Bed", "Rp.7.000.000", "assets/images/ranjang.png"),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // =====================
      // BOTTOM NAVBAR
      // =====================
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFB3D9FF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(Icons.home, size: 30),
            Icon(Icons.favorite, size: 30),
            Icon(Icons.shopping_cart, size: 30),
            Icon(Icons.person, size: 30),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // WIDGET: CATEGORY ICON
  // ===============================================================
  Widget _buildCategory(IconData icon, String title) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 30),
        ),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  // ===============================================================
  // WIDGET: PROMO CARD
  // ===============================================================
  Widget _buildPromoCard(String text, String img, {bool button = false}) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              Image.asset(img, height: 80),
              if (button)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("BELI"),
                )
            ],
          )
        ],
      ),
    );
  }

  // ===============================================================
  // WIDGET: TAB MENU
  // ===============================================================
  Widget _buildTab(String text, bool active) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: active ? FontWeight.bold : FontWeight.normal,
        color: active ? Colors.black : Colors.grey,
      ),
    );
  }

  // ===============================================================
  // WIDGET: PRODUCT CARD
  // ===============================================================
  Widget _buildProduct(String title, String price, String img) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                img, 
                height: 110,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 60);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            price,
            style: const TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }
}