import 'package:flutter/material.dart';
import 'admin_dashboard_screen.dart';
import 'admin_products_screen.dart';
import 'admin_orders_screen.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Admin AMitra',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'admin@amitrafurniture.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Settings List
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.person_outline,
                    title: 'Profil Admin',
                    subtitle: 'Edit informasi profil',
                    onTap: () {
                      _showProfileEditDialog();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.store_outlined,
                    title: 'Informasi Toko',
                    subtitle: 'Kelola informasi toko',
                    onTap: () {
                      _showStoreInfoDialog();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifikasi',
                    subtitle: 'Pengaturan notifikasi',
                    onTap: () {
                      _showNotificationSettings();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'Pengiriman',
                    subtitle: 'Atur metode pengiriman',
                    onTap: () {
                      _showShippingSettings();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.payment_outlined,
                    title: 'Pembayaran',
                    subtitle: 'Atur metode pembayaran',
                    onTap: () {
                      _showPaymentSettings();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // System Settings
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildSettingItem(
                    icon: Icons.security_outlined,
                    title: 'Keamanan',
                    subtitle: 'Password & keamanan akun',
                    onTap: () {
                      _showSecuritySettings();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.help_outline,
                    title: 'Bantuan',
                    subtitle: 'FAQ dan dukungan',
                    onTap: () {
                      _showHelpDialog();
                    },
                  ),
                  _buildDivider(),
                  _buildSettingItem(
                    icon: Icons.info_outline,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {
                      _showAboutDialog();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Keluar'),
                        content: const Text('Apakah Anda yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/admin_login',
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Keluar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminDashboardScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminProductsScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminOrdersScreen()),
            );
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download_outlined),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 72,
      color: Colors.grey.shade200,
    );
  }

  // Dialog untuk Edit Profil Admin
  void _showProfileEditDialog() {
    final nameController = TextEditingController(text: 'Admin AMitra');
    final emailController =
        TextEditingController(text: 'admin@amitrafurniture.com');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil Admin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk Informasi Toko
  void _showStoreInfoDialog() {
    final storeNameController =
        TextEditingController(text: 'A Mitra Furniture');
    final addressController =
        TextEditingController(text: 'Jl. Merdeka No. 123, Jakarta');
    final phoneController = TextEditingController(text: '+62 21 1234567');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informasi Toko'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: storeNameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Toko',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Informasi toko berhasil diperbarui')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk Pengaturan Notifikasi
  void _showNotificationSettings() {
    bool emailNotif = true;
    bool pushNotif = true;
    bool smsNotif = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Pengaturan Notifikasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Email Notifikasi'),
                subtitle: const Text('Terima notifikasi via email'),
                value: emailNotif,
                onChanged: (value) => setState(() => emailNotif = value),
              ),
              SwitchListTile(
                title: const Text('Push Notifikasi'),
                subtitle: const Text('Notifikasi di aplikasi'),
                value: pushNotif,
                onChanged: (value) => setState(() => pushNotif = value),
              ),
              SwitchListTile(
                title: const Text('SMS Notifikasi'),
                subtitle: const Text('Terima notifikasi via SMS'),
                value: smsNotif,
                onChanged: (value) => setState(() => smsNotif = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Pengaturan notifikasi disimpan')),
                );
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog untuk Pengaturan Pengiriman
  void _showShippingSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Metode Pengiriman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Metode pengiriman yang tersedia:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildShippingOption('JNE', 'Estimasi 2-3 hari', true),
            _buildShippingOption('J&T Express', 'Estimasi 1-2 hari', true),
            _buildShippingOption('SiCepat', 'Estimasi 2-4 hari', true),
            _buildShippingOption('Pickup Sendiri', 'Gratis', true),
            const SizedBox(height: 16),
            const Text(
                'Biaya pengiriman akan dihitung otomatis berdasarkan jarak dan berat barang.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOption(String name, String description, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk Pengaturan Pembayaran
  void _showPaymentSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Metode Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Metode pembayaran yang diterima:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildPaymentOption(
                'Transfer Bank', 'BCA, Mandiri, BNI, BRI', true),
            _buildPaymentOption(
                'E-Wallet', 'GoPay, OVO, DANA, ShopeePay', true),
            _buildPaymentOption('COD', 'Bayar di tempat', true),
            _buildPaymentOption(
                'Virtual Account', 'VA BCA, Mandiri, BNI', false),
            const SizedBox(height: 16),
            const Text(
                'Pastikan informasi rekening sudah benar untuk menghindari kesalahan transfer.',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Metode pembayaran diperbarui')),
              );
            },
            child: const Text('Kelola'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String name, String description, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.cancel,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk Pengaturan Keamanan
  void _showSecuritySettings() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keamanan Akun'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password berhasil diubah')),
              );
            },
            child: const Text('Ubah Password'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk Bantuan
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan & Dukungan'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('📱 Hubungi Customer Service', '+62 21 1234567'),
              const SizedBox(height: 12),
              _buildHelpItem('📧 Email Support', 'support@amitrafurniture.com'),
              const SizedBox(height: 12),
              _buildHelpItem('💬 WhatsApp', '+62 812 3456 7890'),
              const SizedBox(height: 20),
              const Text('FAQ:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildFaqItem('Cara mengelola produk?',
                  'Gunakan menu Produk untuk menambah, edit, atau hapus produk.'),
              _buildFaqItem('Cara melihat laporan?',
                  'Buka menu Statistik untuk melihat laporan penjualan.'),
              _buildFaqItem('Cara mengatur pengiriman?',
                  'Gunakan menu Pengaturan > Pengiriman untuk mengatur metode pengiriman.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String subtitle) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(subtitle, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Q: $question',
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          Text('A: $answer',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Dialog untuk Tentang Aplikasi
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.weekend, size: 60, color: Colors.blue),
            const SizedBox(height: 16),
            const Text(
              'A Mitra Furniture Admin',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Versi 1.0.0', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            const Text(
              'Aplikasi admin untuk mengelola toko furniture online A Mitra. Kelola produk, pesanan, dan pengaturan toko dengan mudah.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text('© 2026 A Mitra Furniture',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
