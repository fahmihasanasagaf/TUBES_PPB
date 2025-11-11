import 'package:amitrafurniture/screens/profile_page.dart';
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../data/product_data.dart';
import 'product_detail_screen.dart';

// Color palette inspired by the Figma "Frame"
const Color kLightBlue = Color(0xFFACD2FF);
const Color kPriceBlue = Color(0xFF86BBF9);
const Color kPrimaryText = Colors.black;
const Color kCardBg = Color(0xFFF5F5F5);
const double kRadius = 16;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedCategoryIndex = 0;
  final List<String> categories = ['Semua', 'Populer', 'Kursi', 'Meja'];
  
  // Add category icons and names
  final List<Map<String, dynamic>> categoryItems = [
    {'icon': Icons.chair, 'name': 'Kursi'},
    {'icon': Icons.weekend, 'name': 'Sofa'},
    {'icon': Icons.table_bar, 'name': 'Meja'},
    {'icon': Icons.bed, 'name': 'Ranjang'},
  ];

  // Add bottom navigation index
  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get products from ProductData
    final List<Product> products = ProductData.getAllProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top app bar with hamburger, search, and gear
            _buildTopBar(),

            // Category icon row
            _buildCategoryIconRow(),

            // Promo banners side by side
            _buildPromoBanners(),

            // Filter chips row
            _buildCategoryFilter(),

            // Product grid
            Expanded(child: _buildProductsGrid(products)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: kLightBlue,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: kPrimaryText, size: 28),
            onPressed: () {
              _showSnackBar(context, 'Menu diklik');
            },
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, size: 20, color: kPrimaryText),
                  SizedBox(width: 8),
                  Text(
                    'Cari furniture...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: kPrimaryText, size: 24),
            onPressed: () {
              _showSnackBar(context, 'Pengaturan diklik');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(categoryItems.length, (index) {
          return _buildCategoryItem(
            categoryItems[index]['icon'],
            categoryItems[index]['name'],
          );
        }),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String name) {
    return GestureDetector(
      onTap: () {
        _showSnackBar(context, '$name diklik');
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kLightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kPrimaryText, size: 28),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kPrimaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildPromoCard(
              'BIG SALE\nUP TO 50%',
              Icons.chair_outlined,
              hasButton: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildPromoCard(
              'NEW PRODUCT\nDiscount 20% for the first transaction',
              Icons.weekend_outlined,
              hasButton: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCard(String text, IconData icon, {bool hasButton = false}) {
    return Container(
      decoration: BoxDecoration(
        color: kLightBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryText,
                    height: 1.2,
                  ),
                ),
                if (hasButton) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {
                        _showSnackBar(context, 'Promo diklik');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: kPrimaryText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text(
                        'BELI SEKARANG',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kPrimaryText, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 46,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = _selectedCategoryIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? Colors.white : kPrimaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selected,
              selectedColor: const Color(0xFF2196F3),
              backgroundColor: Colors.grey[200],
              onSelected: (bool value) {
                setState(() {
                  _selectedCategoryIndex = value ? index : 0;
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(products[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to Product Detail Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Image.asset(
                  product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.chair_outlined,
                      size: 50,
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),
            
            // Product Info
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: kPriceBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: kLightBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomNavItem(Icons.home_filled, 'Home', 0),
              _buildBottomNavItem(Icons.favorite_border, 'Wishlist', 1),
              _buildBottomNavItem(Icons.shopping_cart_outlined, 'Cart', 2),
              _buildBottomNavItem(Icons.person_outline, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  // Di bagian _buildBottomNavItem di home_page.dart, update menjadi:
Widget _buildBottomNavItem(IconData icon, String label, int index) {
  final isSelected = _currentBottomNavIndex == index;
  
  return GestureDetector(
    onTap: () {
      if (index == 3) {
        // Navigate to Profile Page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
      } else {
        setState(() {
          _currentBottomNavIndex = index;
        });
        _showSnackBar(context, '$label diklik');
      }
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF2196F3) : kPrimaryText,
          size: 24,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isSelected ? const Color(0xFF2196F3) : kPrimaryText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
