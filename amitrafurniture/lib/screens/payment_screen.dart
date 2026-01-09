import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'paymentsuccess_screen.dart';
import 'waitingpayment_screen.dart';
import 'cart_screen.dart';
import '../providers/order_provider.dart';
import '../services/supabase_service.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentMethod;
  final String? selectedBank;
  final String? selectedEWallet;
  final double totalAmount;
  final Map<String, String>? accountInfo;
  final List<CartItem> cartItems;
  final Map<String, dynamic>? shippingOption;

  const PaymentScreen({
    Key? key,
    required this.paymentMethod,
    this.selectedBank,
    this.selectedEWallet,
    required this.totalAmount,
    this.accountInfo,
    required this.cartItems,
    this.shippingOption,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentStatus = 'Menunggu Pembayaran';
  bool _isUploading = false;

  String get paymentMethodName {
    if (widget.paymentMethod == 'bank_transfer') {
      return widget.accountInfo?['name'] ?? 'Transfer Bank';
    } else if (widget.paymentMethod == 'e_wallet') {
      return widget.accountInfo?['name'] ?? 'E-Wallet';
    } else {
      return 'COD (Cash on Delivery)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3D9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PEMBAYARAN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Pembayaran
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    paymentStatus,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_formatPrice(widget.totalAmount)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Metode Pembayaran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            widget.paymentMethod == 'bank_transfer'
                                ? Icons.account_balance
                                : widget.paymentMethod == 'e_wallet'
                                    ? Icons.account_balance_wallet
                                    : Icons.money,
                            color: Colors.blue.shade700,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            paymentMethodName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Icon(Icons.check_circle, color: Colors.green, size: 28),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Informasi Rekening/Nomor (hanya untuk transfer bank dan e-wallet)
            if (widget.paymentMethod != 'cod') ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.paymentMethod == 'bank_transfer'
                          ? 'Nomor Rekening Tujuan'
                          : 'Nomor E-Wallet',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.accountInfo?['account'] ??
                                    widget.accountInfo?['phone'] ??
                                    '-',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  letterSpacing: 2,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _copyToClipboard(
                                      widget.accountInfo?['account'] ??
                                          widget.accountInfo?['phone'] ??
                                          '');
                                },
                                icon: const Icon(Icons.copy, size: 20),
                                tooltip: 'Salin',
                                color: Colors.blue,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'a.n. ${widget.accountInfo?['holder'] ?? 'A Mitra Furniture'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Instruksi Pembayaran
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Instruksi Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionCard(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informasi Penting
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Penting!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Pastikan jumlah yang ditransfer sesuai dengan total pembayaran. Sistem akan otomatis memverifikasi pembayaran Anda.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildInstructionCard() {
    List<String> instructions = [];

    if (widget.paymentMethod == 'bank_transfer') {
      instructions = [
        'Buka aplikasi mobile banking Anda',
        'Pilih menu Transfer ke Bank ${widget.accountInfo?['name']?.replaceAll(' Virtual Account', '')}',
        'Masukkan nomor rekening yang tertera di atas',
        'Masukkan jumlah transfer sesuai total pembayaran',
        'Konfirmasi pembayaran',
        'Sistem akan otomatis memverifikasi pembayaran Anda',
      ];
    } else if (widget.paymentMethod == 'e_wallet') {
      instructions = [
        'Buka aplikasi ${widget.accountInfo?['name']}',
        'Pilih menu Transfer atau Kirim Uang',
        'Masukkan nomor yang tertera di atas',
        'Masukkan jumlah sesuai total pembayaran',
        'Konfirmasi pembayaran',
        'Sistem akan otomatis memverifikasi pembayaran Anda',
      ];
    } else {
      instructions = [
        'Siapkan uang tunai sesuai total pembayaran',
        'Bayar kepada kurir saat barang diterima',
        'Pastikan memeriksa kondisi barang sebelum membayar',
        'Simpan struk pembayaran dari kurir',
      ];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: instructions
            .asMap()
            .entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading ? null : _confirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.paymentMethod == 'cod'
                      ? Colors.green
                      : Colors.blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isUploading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.paymentMethod == 'cod'
                            ? 'Konfirmasi Pesanan'
                            : 'Konfirmasi Pembayaran',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmPayment() async {
    final supabaseService = SupabaseService();
    final currentUser = supabaseService.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User tidak ditemukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    final deadline = DateTime.now().add(const Duration(hours: 24));

    // Generate UUID untuk order ID
    const uuid = Uuid();
    final orderId = uuid.v4();

    final orderData = {
      'id': orderId,
      'user_id': currentUser.id,
      'total_amount': widget.totalAmount,
      'status':
          'pending', // Status pesanan (pending/processing/shipped/delivered)
      'payment_method': widget.paymentMethod,
      'shipping_address': 'Alamat pengiriman', // Default shipping address
      'phone': '081234567890', // Default phone number
      'notes': '',
      'created_at': DateTime.now().toIso8601String(),
    };

    // Simpan order ke database
    try {
      await supabaseService.createOrder(orderData);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat pesanan: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simpan order items dengan detail produk lengkap
    try {
      print('=== Creating order items ===');
      print('Cart items count: ${widget.cartItems.length}');

      // Debug: Print cart items details
      for (var item in widget.cartItems) {
        print(
            'Cart item - ID: ${item.id}, Name: ${item.name}, Qty: ${item.quantity}, Price: ${item.price}');
      }

      final orderItems = widget.cartItems.map((item) {
        final orderItem = {
          'order_id': orderId,
          'product_id': item.id, // id di CartItem adalah product_id
          'quantity': item.quantity,
          'price': item.price.toDouble(),
        };
        print('Order item prepared: ${orderItem.toString()}');
        return orderItem;
      }).toList();

      if (orderItems.isEmpty) {
        print('⚠️ WARNING: No order items to create!');
        throw Exception('Tidak ada item untuk disimpan');
      }

      print('Creating ${orderItems.length} order items...');
      await supabaseService.createOrderItems(orderItems);
      print('✅ Order items created successfully');
    } catch (e) {
      print('❌ Error creating order items: $e');
      // Don't return here, continue to clear cart and show success
      // Show warning but don't block the flow
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Peringatan: Ada masalah saat menyimpan detail pesanan: $e'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }

    // Clear cart after successful order creation
    try {
      print('Clearing cart for user: ${currentUser.id}');
      await supabaseService.clearCart(currentUser.id);
      print('✅ Cart cleared successfully');
    } catch (e) {
      print('Warning: Failed to clear cart: $e');
    }

    // Tutup loading
    Navigator.pop(context);

    // For COD, go directly to success
    if (widget.paymentMethod == 'cod') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
        (route) => false,
      );
      return;
    }

    // For other payment methods, go to waiting payment screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingPaymentScreen(
          orderId: orderId,
          paymentMethod: widget.paymentMethod,
          totalAmount: widget.totalAmount,
          accountInfo: widget.accountInfo,
          deadline: deadline,
        ),
      ),
      (route) => false,
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nomor berhasil disalin: $text'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
