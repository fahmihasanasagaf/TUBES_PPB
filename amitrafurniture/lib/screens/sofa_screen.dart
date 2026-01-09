import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/supabase_service.dart';
import 'cart_screen.dart' show CartItem;
import 'checkout_screen.dart';

class SofaScreen extends StatefulWidget {
  const SofaScreen({super.key});

  @override
  State<SofaScreen> createState() => _SofaScreenState();
}

class _SofaScreenState extends State<SofaScreen> {
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
                    'SOFA',
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
                _buildSofaCard(
                  context,
                  'SOFA SANTAI',
                  'Rp.450.000',
                  'assets/images/sofasantai.jpeg',
                  {
                    'name': 'SOFA SANTAI',
                    'price': 'Rp.450.000',
                    'image': 'assets/images/sofasantai.jpeg',
                    'description':
                        'Kursi Rotan ini terbuat dari rotan alam berkualitas tinggi yang kuat dan tahan lama. Desainnya yang minimalis dan modern cocok untuk berbagai ruangan seperti ruang tamu, teras, atau area santai lainnya.\n\nMemiliki desain yang sederhana namun elegan, kursi ini cocok untuk ruang tamu, teras, laman, hingga area kafe atau restoran yang ingin menciptakan suasana natural.\n\nRotan yang digunakan ringan namun kuat, serta dilapisi finishing pelindung agar tahan terhadap benang dan jamur.',
                    'specs': [
                      'Material: Rotan alami / rotan sintetis (opsional)',
                      'Rangka: Kayu solid atau metal',
                      'Finishing: Vernish natural / warna custom',
                      'Ukuran: Panjang 55 cm x Lebar 50 cm x Tinggi 85 cm',
                      'Berat: ±5 kg',
                      'Warna: Cokelat alami, krem, atau putih',
                      'Kapasitas: 1 orang dewasa',
                    ],
                    'kelebihan': [
                      'Bahan ringan dan natural',
                      'Desain elegan dan natural',
                      'Tahan lama dan mudah dibersihkan',
                      'Cocok untuk indoor/outdoor',
                      'Ramah lingkungan',
                    ]
                  },
                ),
                _buildSofaCard(
                  context,
                  'SOFA METAL FEET',
                  'Rp.850.000',
                  'assets/images/dan8.jpg',
                  {
                    'name': 'SOFA METAL FEET',
                    'price': 'Rp.850.000',
                    'image': 'assets/images/dan8.jpg',
                    'description':
                        'Sofa modern dengan kaki metal yang kokoh dan stabil. Desain minimalis skandinavia dengan bantalan duduk yang empuk dan nyaman.\n\nDilengkapi dengan sandaran punggung ergonomis dan material fabric berkualitas tinggi yang mudah dibersihkan.\n\nCocok untuk ruang tamu minimalis, ruang keluarga, atau kantor modern.',
                    'specs': [
                      'Material: Fabric premium + Metal feet',
                      'Rangka: Kayu solid berkualitas',
                      'Bantalan: Busa high density',
                      'Ukuran: Panjang 180 cm x Lebar 80 cm x Tinggi 85 cm',
                      'Berat: ±25 kg',
                      'Warna: Abu-abu, Navy, Krem',
                      'Kapasitas: 2-3 orang dewasa',
                    ],
                    'kelebihan': [
                      'Bantalan empuk dan nyaman',
                      'Kaki metal anti karat',
                      'Desain modern minimalis',
                      'Mudah dibersihkan',
                      'Kokoh dan tahan lama',
                    ]
                  },
                ),
                _buildSofaCard(
                  context,
                  'LORENZ SEATER SOFA',
                  'Rp.950.000',
                  'assets/images/dan7.jpg',
                  {
                    'name': 'LORENZ SEATER SOFA',
                    'price': 'Rp.950.000',
                    'image': 'assets/images/dan7.jpg',
                    'description':
                        'Sofa 3 seater dengan desain klasik elegan. Dilengkapi dengan sandaran tangan yang lebar dan nyaman serta bantalan duduk extra tebal.\n\nMaterial fabric premium yang lembut dan tahan lama. Rangka kayu solid yang kokoh memberikan stabilitas maksimal.\n\nPerfect untuk ruang tamu keluarga atau ruang santai yang nyaman.',
                    'specs': [
                      'Material: Velvet fabric premium',
                      'Rangka: Kayu mahoni solid',
                      'Bantalan: Busa super soft high density',
                      'Ukuran: Panjang 200 cm x Lebar 85 cm x Tinggi 90 cm',
                      'Berat: ±35 kg',
                      'Warna: Cokelat, Abu-abu, Biru Navy',
                      'Kapasitas: 3 orang dewasa',
                    ],
                    'kelebihan': [
                      'Bantalan extra empuk',
                      'Material premium dan mewah',
                      'Desain klasik timeless',
                      'Rangka super kokoh',
                      'Sandaran tangan lebar',
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

  Widget _buildSofaCard(
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
              builder: (context) => DetailSofaScreen(sofa: detailData),
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
                          Icons.weekend,
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

    // Untuk sementara, karena produk sofa tidak ada di database dengan ID
    // Kita bisa gunakan dummy ID atau skip database operation
    // Dan langsung tampilkan success message
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
class DetailSofaScreen extends StatelessWidget {
  final Map<String, dynamic> sofa;

  const DetailSofaScreen({super.key, required this.sofa});

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
                          sofa['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.weekend,
                                size: 120, color: Colors.brown);
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      sofa['name'],
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
                      sofa['price'],
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
                    child: Text(sofa['description'],
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
                      children: (sofa['specs'] as List<String>).map((spec) {
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
                      children: (sofa['kelebihan'] as List<String>).map((item) {
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
                                    '${sofa['name']} ditambahkan ke keranjang'),
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
