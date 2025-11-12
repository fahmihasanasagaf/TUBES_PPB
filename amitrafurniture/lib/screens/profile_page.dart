import 'package:flutter/material.dart';
import 'customer_service_page.dart';
import 'order_history_page.dart';
import 'beli_lagi_page.dart'; // Import halaman BeliLagiPage
import 'favorit_saya_page.dart'; // Import halaman FavoritSayaPage

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _navigateToOrderHistory(BuildContext context, int initialTab) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderHistoryPage(initialTab: initialTab),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          'Pengguna',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PESANAN SAYA SECTION
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Pesanan Saya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Belum Bayar - bisa diklik
                          GestureDetector(
                            onTap: () {
                              _navigateToOrderHistory(context, 0);
                            },
                            child: _buildOrderStatus('Belum Bayar', Icons.payment, true),
                          ),
                          // Dikemas - bisa diklik
                          GestureDetector(
                            onTap: () {
                              _navigateToOrderHistory(context, 1);
                            },
                            child: _buildOrderStatus('Dikemas', Icons.inventory_2, false),
                          ),
                          // Dikirim - bisa diklik
                          GestureDetector(
                            onTap: () {
                              _navigateToOrderHistory(context, 2);
                            },
                            child: _buildOrderStatus('Dikirim', Icons.local_shipping, false),
                          ),
                          // Diberi Penilaian - bisa diklik
                          GestureDetector(
                            onTap: () {
                              _navigateToOrderHistory(context, 3);
                            },
                            child: _buildOrderStatus('Diberi Penilaian', Icons.star_border, false),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryPage(),
                            ),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Lihat Riwayat Pesanan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // AKTIVITAS SAYA SECTION
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Aktivitas Saya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Beli Lagi - bisa diklik
                    _buildClickableItem(
                      'Beli Lagi',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BeliLagiPage(),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    // Favorit Saya - bisa diklik
                    _buildClickableItem(
                      'Favorit Saya',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FavoritSayaPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // BANTUAN SECTION
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Bantuan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildClickableItem(
                  'Customer Service',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CustomerServicePage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // UBAH PROFIL SECTION
              const Padding(
                padding: EdgeInsets.only(left: 8, bottom: 8),
                child: Text(
                  'Ubah Profil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Nama - bisa diklik
                    _buildClickableItem(
                      'Nama fahmi',
                      onTap: () {
                        _showEditDialog(context, 'Nama', 'fahmi');
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    // No. Handphone - bisa diklik
                    _buildClickableItem(
                      'No.Handphone ******91',
                      onTap: () {
                        _showEditDialog(context, 'No. Handphone', '081234567891');
                      },
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    // Email - bisa diklik
                    _buildClickableItem(
                      'Email s****2@gmail.com',
                      onTap: () {
                        _showEditDialog(context, 'Email', 's****2@gmail.com');
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // SIMPAN BUTTON
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profil berhasil disimpan'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderStatus(String text, IconData icon, bool isBold) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildClickableItem(String text, {VoidCallback? onTap}) {
    return ListTile(
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black54,
      ),
      onTap: onTap,
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue) {
    TextEditingController controller = TextEditingController(text: currentValue);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Masukkan $field baru',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Simpan perubahan
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$field berhasil diubah'),
                    duration: const Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}