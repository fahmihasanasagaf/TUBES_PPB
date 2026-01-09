import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/supabase_service.dart';
import 'cart_screen.dart' show CartItem;
import 'checkout_screen.dart';

class RanjangScreen extends StatefulWidget {
  const RanjangScreen({super.key});

  @override
  State<RanjangScreen> createState() => _RanjangScreenState();
}

class _RanjangScreenState extends State<RanjangScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF),
      body: Column(
        children: [
          // Custom App Bar
          Container(
            color: const Color(0xFF86BBF9),
            padding:
                const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'RANJANG',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                // Gambar pengaturan dihapus dari sini
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
              children: [
                _buildRanjangCard(
                  context,
                  'RANJANG MODERN',
                  'Rp.850.000',
                  'assets/images/dan4.jpg',
                  {
                    'name': 'RANJANG MODERN',
                    'price': 'Rp.850.000',
                    'image': 'assets/images/dan4.jpg',
                    'description':
                        'Ranjang dengan desain modern minimalis yang cocok untuk kamar tidur kontemporer. Rangka kayu solid yang kokoh dan tahan lama.\n\nDesain headboard yang elegan memberikan kesan mewah pada kamar tidur. Ukuran queen size yang nyaman untuk 2 orang.\n\nDilengkapi dengan penyangga kasur yang kuat dan stabil.',
                    'specs': [
                      'Material: Kayu Solid + MDF',
                      'Finishing: Duco/Melamine',
                      'Ukuran: 160 cm x 200 cm (Queen Size)',
                      'Tinggi Headboard: 120 cm',
                      'Berat: ±45 kg',
                      'Warna: Putih, Walnut, Natural',
                      'Termasuk: Rangka + Headboard',
                    ],
                    'kelebihan': [
                      'Desain modern elegan',
                      'Rangka sangat kokoh',
                      'Headboard tinggi nyaman',
                      'Mudah dirakit',
                      'Ukuran queen size',
                    ]
                  },
                ),
                _buildRanjangCard(
                  context,
                  'RANJANG SUSUN TINGKAT',
                  'Rp.1.200.000',
                  'assets/images/dan3.jpg',
                  {
                    'name': 'RANJANG SUSUN TINGKAT',
                    'price': 'Rp.1.200.000',
                    'image': 'assets/images/dan3.jpg',
                    'description':
                        'Ranjang susun tingkat yang praktis dan space-saving. Ideal untuk kamar anak atau kost yang memiliki ruang terbatas.\n\nDilengkapi dengan tangga yang aman dan nyaman untuk naik ke tingkat atas. Pengaman samping pada tingkat atas untuk keamanan ekstra.\n\nKonstruksi kayu solid yang sangat kuat dan aman untuk anak-anak.',
                    'specs': [
                      'Material: Kayu Pinus Solid',
                      'Finishing: Natural/Duco',
                      'Ukuran per kasur: 90 cm x 200 cm (Single)',
                      'Tinggi Total: 180 cm',
                      'Berat: ±60 kg',
                      'Kapasitas: Max 100 kg per tingkat',
                      'Termasuk: Tangga + Pengaman',
                    ],
                    'kelebihan': [
                      'Hemat ruangan',
                      'Sangat kokoh dan aman',
                      'Tangga terintegrasi',
                      'Pengaman safety rail',
                      'Multifungsi untuk anak',
                    ]
                  },
                ),
                _buildRanjangCard(
                  context,
                  'RANJANG MINIMALIS',
                  'Rp.650.000',
                  'assets/images/ranjang minimalis.jpeg',
                  {
                    'name': 'RANJANG MINIMALIS',
                    'price': 'Rp.650.000',
                    'image': 'assets/images/ranjang minimalis.jpeg',
                    'description':
                        'Ranjang minimalis dengan desain simpel dan fungsional. Cocok untuk kamar tidur dengan konsep minimalis modern.\n\nTanpa headboard sehingga lebih compact dan mudah diatur. Rangka kayu yang kuat dengan finishing natural.\n\nHarga terjangkau dengan kualitas yang tetap bagus dan awet.',
                    'specs': [
                      'Material: Kayu Solid',
                      'Finishing: Natural Varnish',
                      'Ukuran: 120 cm x 200 cm (Single XL)',
                      'Tinggi: 30 cm dari lantai',
                      'Berat: ±25 kg',
                      'Warna: Natural Wood',
                      'Termasuk: Rangka saja',
                    ],
                    'kelebihan': [
                      'Desain super minimalis',
                      'Harga terjangkau',
                      'Compact dan space-saving',
                      'Mudah dipindahkan',
                      'Cocok untuk segala usia',
                    ]
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildRanjangCard(
    BuildContext context,
    String name,
    String price,
    String imagePath,
    Map<String, dynamic> detailData,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRanjangScreen(ranjang: detailData),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF5F5F5),
                        child: const Icon(
                          Icons.bed,
                          size: 60,
                          color: Colors.brown,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 28,
                              child: OutlinedButton(
                                onPressed: () =>
                                    _addToCart(name, price, imagePath),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2196F3),
                                  side: const BorderSide(
                                      color: Color(0xFF2196F3), width: 1.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child:
                                    const Icon(Icons.shopping_cart, size: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 28,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _buyNow(name, price, imagePath),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2196F3),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                                child: const Text(
                                  'Beli',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCart(String name, String price, String imagePath) async {
    final supabaseService = SupabaseService();
    final currentUser = supabaseService.currentUser;

    if (currentUser == null) {
      _showLoginDialog();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Menambahkan ke keranjang...'),
          ],
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'LIHAT',
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }

  void _buyNow(String name, String price, String imagePath) {
    final supabaseService = SupabaseService();
    final currentUser = supabaseService.currentUser;

    if (currentUser == null) {
      _showLoginDialog();
      return;
    }

    final cartItem = CartItem(
      id: name.replaceAll(' ', '_').toLowerCase(),
      name: name,
      price: _parsePrice(price),
      quantity: 1,
      isSelected: true,
      imageUrl: imagePath,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          selectedItems: [cartItem],
        ),
      ),
    );
  }

  int _parsePrice(String priceString) {
    final numericString = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numericString) ?? 0;
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
            'Anda harus login terlebih dahulu untuk menambahkan produk ke keranjang atau melakukan pembelian.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
            ),
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFACD2FF),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon:
                const Icon(Icons.home_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined,
                color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon:
                const Icon(Icons.person_outline, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Detail Screen
class DetailRanjangScreen extends StatelessWidget {
  final Map<String, dynamic> ranjang;

  const DetailRanjangScreen({super.key, required this.ranjang});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF86BBF9),
            padding:
                const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Detail Produk',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFF86BBF9), width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          ranjang['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.bed,
                                size: 120, color: Colors.brown);
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ranjang['name'],
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      ranjang['price'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Deskripsi Produk:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(ranjang['description'],
                        style: const TextStyle(fontSize: 14, height: 1.5),
                        textAlign: TextAlign.justify),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Spesifikasi Produk',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (ranjang['specs'] as List<String>).map((spec) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(
                                  child: Text(spec,
                                      style: const TextStyle(
                                          fontSize: 14, height: 1.4))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Kelebihan',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (ranjang['kelebihan'] as List<String>).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(
                                  child: Text(item,
                                      style: const TextStyle(
                                          fontSize: 14, height: 1.4))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    '${ranjang['name']} ditambahkan ke keranjang'),
                                backgroundColor: Colors.green),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('+ Keranjang',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFACD2FF),
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
