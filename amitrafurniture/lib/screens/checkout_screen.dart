import 'package:amitrafurniture/screens/cart_screen.dart';
import 'package:amitrafurniture/screens/paymentsuccess_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkout App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CheckoutScreen(selectedItems: <CartItem>[]),
    );
  }
}

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;

  const CheckoutScreen({
    Key? key,
    required this.selectedItems,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = '';
  String? selectedBankTransfer;
  String? selectedEWallet;

  // Data untuk Transfer Bank
  final List<Map<String, String>> bankTransferOptions = [
    {'id': 'bca', 'name': 'BCA Virtual Account'},
    {'id': 'mandiri', 'name': 'Mandiri Virtual Account'},
    {'id': 'bni', 'name': 'BNI Virtual Account'},
    {'id': 'bri', 'name': 'BRI Virtual Account'},
  ];

  // Data untuk E-Wallet
  final List<Map<String, String>> eWalletOptions = [
    {'id': 'gopay', 'name': 'GoPay'},
    {'id': 'ovo', 'name': 'OVO'},
    {'id': 'dana', 'name': 'DANA'},
    {'id': 'shopeepay', 'name': 'ShopeePay'},
  ];

  double getTotalPrice() {
    if (widget.selectedItems.isEmpty) return 0.0;
    return widget.selectedItems
        .fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  int getTotalItems() {
    if (widget.selectedItems.isEmpty) return 0;
    return widget.selectedItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = getTotalPrice();
    final shippingCost = 0.0;
    final total = subtotal + shippingCost;

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
          'CHECKOUT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(),
                  const Divider(
                    height: 1,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildProductSection(),
                  const Divider(
                    height: 1,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildShippingSection(),
                  const Divider(
                    height: 1,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildPaymentMethodSection(),
                  const Divider(
                    height: 1,
                    thickness: 8,
                    color: Color(0xFFF5F5F5),
                  ),
                  _buildPaymentSummary(subtotal, shippingCost, total),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomButton(total),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'GISELMA FIRMANSYAH',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '| (+62) 857 3618 3301',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'JALAN BUKIT TINGGI, NO. 21, RW 03/RW 02 PISANG KAPI.ING MERDEKA RT 02/04 WATUMAS PURWAKERJA, PURWOKERTO, TUNJUNGAN BANYUMAS, JAWA TENGAH, ID 53114',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildProductSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A Mitra Furniture Official Store',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Tampilkan semua produk yang dipilih dari cart
          if (widget.selectedItems.isEmpty)
            // Jika tidak ada item, tampilkan placeholder
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.chair_outlined, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tidak ada produk',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            // Tampilkan semua item dari cart
            ...widget.selectedItems.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image dengan asset
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.chair_outlined,
                              color: Colors.grey,
                              size: 30,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp.${_formatPrice(item.price.toDouble())}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'X${item.quantity}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }).toList(),

          // Total Produk
          if (widget.selectedItems.isNotEmpty) ...[
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total ${getTotalItems()} Produk',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Rp.${_formatPrice(getTotalPrice())}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildShippingSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildShippingRow('Pesan Untuk Penjual', 'Tinggalkan Pesan'),
          const SizedBox(height: 12),
          _buildShippingRow('Opsi Pengiriman', 'Lihat semua'),
        ],
      ),
    );
  }

  Widget _buildShippingRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Transfer Bank
          _buildPaymentOption(
            'bank_transfer',
            Icons.account_balance,
            'Transfer Bank',
          ),

          // Sub-options untuk Transfer Bank
          if (selectedPayment == 'bank_transfer') ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 36),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: bankTransferOptions.map((bank) {
                  return _buildSubOption(
                    bank['id']!,
                    bank['name']!,
                    selectedBankTransfer,
                    (value) {
                      setState(() {
                        selectedBankTransfer = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],

          const Divider(height: 24),

          // E-wallet
          _buildPaymentOption(
            'e_wallet',
            Icons.account_balance_wallet_outlined,
            'E-wallet',
          ),

          // Sub-options untuk E-Wallet
          if (selectedPayment == 'e_wallet') ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 36),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                children: eWalletOptions.map((wallet) {
                  return _buildSubOption(
                    wallet['id']!,
                    wallet['name']!,
                    selectedEWallet,
                    (value) {
                      setState(() {
                        selectedEWallet = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],

          const Divider(height: 24),

          // COD
          _buildPaymentOption('cod', Icons.money, 'COD'),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, IconData icon, String label) {
    final isSelected = selectedPayment == value;
    return InkWell(
      onTap: () {
        setState(() {
          selectedPayment = value;
          if (value != 'bank_transfer') selectedBankTransfer = null;
          if (value != 'e_wallet') selectedEWallet = null;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubOption(
    String id,
    String name,
    String? selectedValue,
    Function(String) onSelect,
  ) {
    final isSelected = selectedValue == id;
    return InkWell(
      onTap: () => onSelect(id),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(Icons.payment, size: 20, color: Colors.blue[700]),
            const SizedBox(width: 12),
            Expanded(child: Text(name, style: const TextStyle(fontSize: 13))),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(double subtotal, double shipping, double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rincian Pembayaran',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Subtotal Pesanan', subtotal),
          const SizedBox(height: 8),
          _buildSummaryRow('Subtotal Pengiriman', shipping),
          const Divider(height: 24),
          _buildSummaryRow('Total Pembayaran', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.black87,
          ),
        ),
        Text(
          'Rp.${_formatPrice(amount)}',
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? Colors.blue : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(double total) {
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
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: widget.selectedItems.isEmpty
                ? null
                : () {
                    String message = '';
                    Color bgColor = Colors.red;

                    if (selectedPayment.isEmpty) {
                      message = '⚠️ Pilih metode pembayaran terlebih dahulu!';
                    } else if (selectedPayment == 'bank_transfer' &&
                        selectedBankTransfer == null) {
                      message = '⚠️ Pilih bank untuk transfer!';
                    } else if (selectedPayment == 'e_wallet' &&
                        selectedEWallet == null) {
                      message = '⚠️ Pilih e-wallet yang akan digunakan!';
                    } else {
                      // Validasi berhasil, navigate ke success screen
                      String paymentMethod = '';
                      if (selectedPayment == 'bank_transfer') {
                        paymentMethod = bankTransferOptions.firstWhere(
                          (e) => e['id'] == selectedBankTransfer,
                        )['name']!;
                      } else if (selectedPayment == 'e_wallet') {
                        paymentMethod = eWalletOptions.firstWhere(
                          (e) => e['id'] == selectedEWallet,
                        )['name']!;
                      } else {
                        paymentMethod = 'COD (Cash on Delivery)';
                      }

                      // Navigate to success screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentSuccessScreen(),
                        ),
                      );
                      return; // Exit early to skip showing snackbar
                    }

                    // Show error snackbar only if validation failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        duration: const Duration(seconds: 3),
                        backgroundColor: bgColor,
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'BUAT PESANAN',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
