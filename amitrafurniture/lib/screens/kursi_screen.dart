import 'package:flutter/material.dart';

class KursiScreen extends StatelessWidget {
  const KursiScreen({super.key});

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
                    'KURSI',
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
                _buildKursiCard(
                  context,
                  'KURSI KAYU JATI',
                  'Rp.400.000',
                  'assets/images/kursikayujati.jpeg',
                  {
                    'name': 'KURSI KAYU JATI',
                    'price': 'Rp.400.000',
                    'image': 'assets/images/kursikayujati.jpeg',
                    'description':
                        'Kursi Kayu Jati Elegan\n\nKursi ini terbuat dari kayu jati berkualitas tinggi yang terkenal akan kekuatan dan ketahanannya terhadap rayap serta cuaca. Desainnya sederhana namun elegan, cocok untuk berbagai ruangan seperti ruang tamu, ruang makan, atau ruang kerja.',
                    'specs': [
                      'Bahan: Kayu Jati Solid',
                      'Finishing: Natural / Glossy',
                      'Dimensi: 45 cm (lebar) × 45 cm (panjang) × 85 cm (tinggi)',
                      'Warna: Cokelat Kayu Natural',
                      'Kapasitas: Maksimal hingga 100 kg',
                    ],
                    'kelebihan': [
                      'Material kuat dan tahan lama',
                      'Desain minimalis cocok untuk berbagai interior',
                      'Permukaan halus dan nyaman saat digunakan',
                    ]
                  },
                ),
                _buildKursiCard(
                  context,
                  'KURSI ROTAN',
                  'Rp.650.000',
                  'assets/images/kursirotan.jpeg',
                  {
                    'name': 'KURSI ROTAN',
                    'price': 'Rp.650.000',
                    'image': 'assets/images/kursirotan.jpeg',
                    'description':
                        'Kursi Rotan Premium\n\nKursi rotan dengan anyaman berkualitas tinggi yang kuat dan fleksibel. Desain modern dengan kaki kayu solid memberikan kesan natural dan hangat.',
                    'specs': [
                      'Bahan: Rotan Alami + Kayu Solid',
                      'Finishing: Natural Varnish',
                      'Dimensi: 50 cm (lebar) × 50 cm (panjang) × 90 cm (tinggi)',
                      'Warna: Cokelat Natural',
                      'Kapasitas: Maksimal hingga 90 kg',
                    ],
                    'kelebihan': [
                      'Ringan namun kuat',
                      'Anyaman rapi dan detail',
                      'Sirkulasi udara baik',
                    ]
                  },
                ),
                // Produk kursi baru ditambahkan di sini
                _buildKursiCard(
                  context,
                  'KURSI ERGONOMIS',
                  'Rp.550.000',
                  'assets/images/kursisantai.jpeg',
                  {
                    'name': 'KURSI ERGONOMIS',
                    'price': 'Rp.550.000',
                    'image': 'assets/images/kursisantai.jpeg',
                    'description':
                        'Kursi Ergonomis Modern\n\nKursi desain ergonomis yang dirancang khusus untuk kenyamanan duduk dalam waktu lama. Dilengkapi dengan sandaran punggung yang mengikuti kontur tubuh dan bantalan duduk yang empuk.',
                    'specs': [
                      'Bahan: Mesh breathable + Busa high density',
                      'Rangka: Baja tubular kuat',
                      'Dimensi: 55 cm (lebar) × 55 cm (panjang) × 95 cm (tinggi)',
                      'Warna: Hitam, Abu-abu, Biru',
                      'Kapasitas: Maksimal hingga 120 kg',
                      'Fitur: Sandaran adjustable, armrest',
                    ],
                    'kelebihan': [
                      'Desain ergonomis untuk kesehatan tulang belakang',
                      'Material breathable dan nyaman',
                      'Tinggi dan sandaran dapat diatur',
                      'Cocok untuk kerja dan gaming',
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

  Widget _buildKursiCard(
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
              builder: (context) => DetailKursiScreen(kursi: detailData),
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
              // Image Container
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
                          Icons.chair,
                          size: 60,
                          color: Colors.brown,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Content Container
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
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailKursiScreen(kursi: detailData),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFACD2FF),
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Detail',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
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
        ),
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

class DetailKursiScreen extends StatelessWidget {
  final Map<String, dynamic> kursi;

  const DetailKursiScreen({super.key, required this.kursi});

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
                  // Image Container
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset(
                          kursi['image'] ??
                              'assets/images/products/kursi_kayu_jati.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.chair,
                              size: 120,
                              color: Colors.brown,
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Product Name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      kursi['name'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      kursi['price'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Deskripsi Produk:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      kursi['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spesifikasi Produk
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Spesifikasi Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Specs List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (kursi['specs'] as List<String>).map((spec) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Text(
                                  spec,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kelebihan
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Kelebihan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Kelebihan List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          (kursi['kelebihan'] as List<String>).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ', style: TextStyle(fontSize: 14)),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add to Cart Button
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
                                  '${kursi['name']} ditambahkan ke keranjang'),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text(
                          '+ Keranjang',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFACD2FF),
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
