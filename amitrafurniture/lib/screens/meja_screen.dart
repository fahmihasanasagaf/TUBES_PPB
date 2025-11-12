import 'package:flutter/material.dart';

class MejaScreen extends StatelessWidget {
  const MejaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF),
      body: Column(
        children: [
          // Custom App Bar
          Container(
            color: const Color(0xFF86BBF9),
            padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'MEJA',
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
                _buildMejaCard(
                  context,
                  'LACI MODERN RETRO',
                  'Rp.450.000',
                  'assets/images/products/laci_modern.jpg',
                  {
                    'name': 'LACI MODERN RETRO',
                    'price': 'Rp.450.000',
                    'image': 'assets/images/products/laci_modern.jpg',
                    'description': 'Laci modern dengan desain retro yang unik dan eye-catching. Cocok untuk menyimpan berbagai barang dengan rapi dan terorganisir.\n\nDilengkapi dengan 4 laci berukuran sedang yang cukup untuk menyimpan pakaian, dokumen, atau barang-barang lainnya.\n\nMaterial kayu solid berkualitas tinggi dengan finishing natural yang tahan lama.',
                    'specs': [
                      'Material: Kayu Jati/Mahoni Solid',
                      'Finishing: Natural Varnish',
                      'Jumlah Laci: 4 laci',
                      'Ukuran: Panjang 80 cm x Lebar 40 cm x Tinggi 90 cm',
                      'Berat: ±18 kg',
                      'Warna: Natural Wood',
                      'Handle: Metal antik',
                    ],
                    'kelebihan': [
                      'Desain retro unik',
                      'Kapasitas penyimpanan besar',
                      'Material solid dan kokoh',
                      'Mudah dibersihkan',
                      'Multifungsi',
                    ]
                  },
                ),
                _buildMejaCard(
                  context,
                  'BUFFET JATI LACI',
                  'Rp.750.000',
                  'assets/images/products/buffet_jati.jpg',
                  {
                    'name': 'BUFFET JATI LACI',
                    'price': 'Rp.750.000',
                    'image': 'assets/images/products/buffet_jati.jpg',
                    'description': 'Buffet kayu jati dengan 6 laci yang luas dan fungsional. Desain klasik elegan yang cocok untuk ruang makan atau ruang tamu.\n\nDapat digunakan untuk menyimpan peralatan makan, taplak meja, atau barang-barang lainnya dengan rapi.\n\nKayu jati pilihan dengan serat indah dan warna natural yang hangat.',
                    'specs': [
                      'Material: Kayu Jati Premium Solid',
                      'Finishing: Glossy Natural',
                      'Jumlah Laci: 6 laci besar',
                      'Ukuran: Panjang 120 cm x Lebar 45 cm x Tinggi 85 cm',
                      'Berat: ±30 kg',
                      'Warna: Cokelat Jati Natural',
                      'Handle: Kayu carved',
                    ],
                    'kelebihan': [
                      'Material kayu jati premium',
                      'Kapasitas super besar',
                      'Desain klasik mewah',
                      'Sangat kokoh dan awet',
                      'Serat kayu natural indah',
                    ]
                  },
                ),
                _buildMejaCard(
                  context,
                  'MEJA KERJA MINIMALIS',
                  'Rp.550.000',
                  'assets/images/products/meja_kerja.jpg',
                  {
                    'name': 'MEJA KERJA MINIMALIS',
                    'price': 'Rp.550.000',
                    'image': 'assets/images/products/meja_kerja.jpg',
                    'description': 'Meja kerja dengan desain minimalis modern yang cocok untuk home office atau ruang belajar.\n\nPermukaan meja yang luas memberikan ruang kerja yang nyaman. Dilengkapi dengan laci untuk menyimpan alat tulis dan dokumen.\n\nKaki meja yang kuat dan stabil memberikan kenyamanan saat bekerja.',
                    'specs': [
                      'Material: Kayu solid + MDF',
                      'Finishing: Matte/Glossy',
                      'Jumlah Laci: 2 laci samping',
                      'Ukuran: Panjang 120 cm x Lebar 60 cm x Tinggi 75 cm',
                      'Berat: ±20 kg',
                      'Warna: Natural, Putih, Walnut',
                      'Kapasitas: Max 50 kg',
                    ],
                    'kelebihan': [
                      'Desain minimalis modern',
                      'Permukaan luas',
                      'Kokoh dan stabil',
                      'Mudah dirakit',
                      'Harga terjangkau',
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

  Widget _buildMejaCard(
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
              builder: (context) => DetailMejaScreen(meja: detailData),
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
                          Icons.table_bar,
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
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailMejaScreen(meja: detailData),
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
            icon: const Icon(Icons.home_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black, size: 24),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// Detail Screen
class DetailMejaScreen extends StatelessWidget {
  final Map<String, dynamic> meja;

  const DetailMejaScreen({super.key, required this.meja});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F4FF),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF86BBF9),
            padding: const EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
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
                      border: Border.all(color: const Color(0xFF86BBF9), width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        child: Image.asset(
                          meja['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.table_bar, size: 120, color: Colors.brown);
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      meja['name'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      meja['price'],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Deskripsi Produk:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(meja['description'], style: const TextStyle(fontSize: 14, height: 1.5), textAlign: TextAlign.justify),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Spesifikasi Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (meja['specs'] as List<String>).map((spec) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(spec, style: const TextStyle(fontSize: 14, height: 1.4))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Kelebihan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (meja['kelebihan'] as List<String>).map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• '),
                              Expanded(child: Text(item, style: const TextStyle(fontSize: 14, height: 1.4))),
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
                            SnackBar(content: Text('${meja['name']} ditambahkan ke keranjang'), backgroundColor: Colors.green),
                          );
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('+ Keranjang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFACD2FF),
                          foregroundColor: Colors.black,
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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