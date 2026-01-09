import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../providers/auth_provider.dart';
import 'waitingpayment_screen.dart';

class OrdersScreen extends StatefulWidget {
  final String? initialTab;

  const OrdersScreen({Key? key, this.initialTab}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late String selectedTab;
  final List<String> tabs = [
    'Semua',
    'Belum Dibayar',
    'Sudah Dibayar',
    'Dikemas',
    'Dikirim',
    'Selesai'
  ];

  @override
  void initState() {
    super.initState();
    selectedTab = widget.initialTab ?? 'Semua';
    _loadOrders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload orders when screen becomes active again
    _loadOrders();
  }

  void _loadOrders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        context.read<OrderProvider>().refresh(authProvider.currentUser!.id);
      }
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrderProvider, AuthProvider>(
      builder: (context, orderProvider, authProvider, child) {
        // Debug info
        print('OrdersScreen build - isLoading: ${orderProvider.isLoading}');
        print(
            'OrdersScreen build - orders count: ${orderProvider.orders.length}');
        print('OrdersScreen build - error: ${orderProvider.errorMessage}');
        print('OrdersScreen build - selected tab: $selectedTab');
        print(
            'OrdersScreen build - current user: ${authProvider.currentUser?.id}');

        if (authProvider.currentUser == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFFB3D9FF),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('PESANAN SAYA'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Silakan login terlebih dahulu'),
                ],
              ),
            ),
          );
        }

        if (orderProvider.isLoading) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFFB3D9FF),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('PESANAN SAYA'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Debug: Show error if exists
        if (orderProvider.errorMessage != null) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: const Color(0xFFB3D9FF),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('PESANAN SAYA'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text('Error: ${orderProvider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      if (authProvider.currentUser != null) {
                        context
                            .read<OrderProvider>()
                            .refresh(authProvider.currentUser!.id);
                      }
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

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
              'PESANAN SAYA',
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
              _buildTabBar(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildOrderList(orderProvider.orders)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedTab == tabs[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFF2196F3),
              backgroundColor: Colors.grey[200],
              onSelected: (bool value) {
                setState(() {
                  selectedTab = tabs[index];
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> allOrders) {
    List<Map<String, dynamic>> filteredOrders;

    if (selectedTab == 'Semua') {
      filteredOrders = allOrders;
    } else if (selectedTab == 'Belum Dibayar' ||
        selectedTab == 'Sudah Dibayar') {
      filteredOrders = allOrders
          .where((order) => order['status']?.toString() == selectedTab)
          .toList();
    } else {
      filteredOrders = allOrders
          .where((order) => order['status']?.toString() == selectedTab)
          .toList();
    }

    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(filteredOrders[index]);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    // Format tanggal dari created_at
    String formattedDate = 'Baru saja';
    if (order['created_at'] != null) {
      try {
        final createdAt = DateTime.parse(order['created_at']);
        final now = DateTime.now();
        final difference = now.difference(createdAt);

        if (difference.inDays == 0) {
          formattedDate = 'Hari ini';
        } else if (difference.inDays == 1) {
          formattedDate = 'Kemarin';
        } else if (difference.inDays < 7) {
          formattedDate = '${difference.inDays} hari lalu';
        } else {
          formattedDate =
              '${createdAt.day} ${_getMonthName(createdAt.month)} ${createdAt.year}';
        }
      } catch (e) {
        formattedDate = 'Tanggal tidak valid';
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['id']?.toString() ?? 'No ID',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (order['deadline'] != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 12, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              'Bayar sebelum ${order['deadline']}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusChip(
                        order['status']?.toString() ?? 'Belum Dibayar'),
                    if (order['paymentStatus'] != null) ...[
                      const SizedBox(height: 6),
                      _buildPaymentStatusChip(
                          order['paymentStatus']?.toString() ??
                              'Belum Dibayar'),
                    ],
                  ],
                ),
              ],
            ),
            if (order['notes'] != null &&
                order['notes'].toString().trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.note_outlined,
                        size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Catatan: ${order['notes']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const Divider(height: 24),

            // Order Items
            ...((order['order_items'] ?? []) as List).map<Widget>((item) {
              final product = item['products'] ?? {};
              final productName = product['name'] ?? 'Produk';
              final productImage =
                  product['image_url'] ?? product['image'] ?? '';
              final quantity = item['quantity'] ?? 1;
              final price = item['price'] ?? 0;

              // Format price using the same method
              final formattedPrice = _formatCurrency(price.toDouble());

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey[200]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: productImage.isNotEmpty
                            ? (productImage.startsWith('http')
                                ? Image.network(
                                    productImage,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        color: Colors.grey[100],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.blue[300]!),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[100],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.weekend,
                                              size: 30,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Furniture',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    productImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[100],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.weekend,
                                              size: 30,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Furniture',
                                              style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ))
                            : Container(
                                color: Colors.grey[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.weekend,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Furniture',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$quantity x $formattedPrice',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),

            const Divider(height: 24),

            // Total and Payment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pembayaran',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatCurrency(order['total_amount']?.toDouble() ?? 0),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ],
                ),
                Text(
                  order['payment']?.toString() ?? 'Tidak diketahui',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action Buttons
            Row(
              children: [
                if (order['status']?.toString() == 'Belum Dibayar') ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _navigateToPayment(order);
                      },
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Bayar Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showOrderDetail(order);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                      side: const BorderSide(color: Color(0xFF2196F3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Detail'),
                  ),
                ),
                if (order['status']?.toString() == 'Dikirim') ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _confirmReceived(order);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Terima'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final statusText = status ?? 'Belum Dibayar';
    Color color;
    switch (statusText) {
      case 'Belum Dibayar':
        color = Colors.red;
        break;
      case 'Dikemas':
        color = Colors.orange;
        break;
      case 'Dikirim':
        color = Colors.blue;
        break;
      case 'Selesai':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildPaymentStatusChip(String? status) {
    final statusText = status ?? 'Belum Dibayar';
    Color color;

    // Handle COD status
    if (statusText == 'Bayar di Tempat' ||
        statusText.toLowerCase().contains('cod')) {
      color = Colors.blue;
    } else if (statusText == 'Sudah Dibayar') {
      color = Colors.green;
    } else {
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    final orderItems = (order['order_items'] ?? []) as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  const Text(
                    'Detail Pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Info
                  Text(
                      'ID Pesanan: ${order['id']?.toString() ?? 'Tidak ada ID'}'),
                  const SizedBox(height: 8),
                  Text('Tanggal: ${_formatDate(order['created_at'])}'),
                  const SizedBox(height: 8),
                  Text(
                      'Status: ${order['status']?.toString() ?? 'Tidak diketahui'}'),
                  const SizedBox(height: 8),
                  Text(
                      'Metode Pembayaran: ${_getPaymentMethodName(order['payment_method']?.toString())}'),
                  const SizedBox(height: 8),
                  Text(
                      'Total: ${_formatCurrency(order['total_amount']?.toDouble() ?? 0)}'),

                  const Divider(height: 32),

                  // Order Items
                  const Text(
                    'Produk:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (orderItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Tidak ada produk',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    )
                  else
                    ...orderItems.map((item) {
                      final product = item['products'] ?? {};
                      final productName = product['name'] ?? 'Produk';
                      final productImage = product['image_url'] ?? '';
                      final quantity = item['quantity'] ?? 1;
                      final price = item['price'] ?? 0;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: productImage.isNotEmpty
                                    ? Image.network(
                                        productImage,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.weekend,
                                              size: 30,
                                              color: Colors.grey[400]);
                                        },
                                      )
                                    : Icon(Icons.weekend,
                                        size: 30, color: Colors.grey[400]),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$quantity x ${_formatCurrency(price.toDouble())}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToPayment(Map<String, dynamic> order) {
    // Get payment method info
    final paymentMethod = order['payment_method'] ?? '';
    Map<String, String>? accountInfo;

    // Determine account info based on payment method
    if (paymentMethod.contains('bca') || paymentMethod.contains('BCA')) {
      accountInfo = {
        'id': 'bca',
        'name': 'BCA Virtual Account',
        'account': '8810 5566 9912',
        'holder': 'A Mitra Furniture'
      };
    } else if (paymentMethod.contains('mandiri') ||
        paymentMethod.contains('Mandiri')) {
      accountInfo = {
        'id': 'mandiri',
        'name': 'Mandiri Virtual Account',
        'account': '1440 0088 7733',
        'holder': 'A Mitra Furniture'
      };
    } else if (paymentMethod.contains('bni') || paymentMethod.contains('BNI')) {
      accountInfo = {
        'id': 'bni',
        'name': 'BNI Virtual Account',
        'account': '0998 8877 6655',
        'holder': 'A Mitra Furniture'
      };
    } else if (paymentMethod.contains('bri') || paymentMethod.contains('BRI')) {
      accountInfo = {
        'id': 'bri',
        'name': 'BRI Virtual Account',
        'account': '0055 1122 3344',
        'holder': 'A Mitra Furniture'
      };
    } else if (paymentMethod.contains('gopay') ||
        paymentMethod.contains('GoPay')) {
      accountInfo = {'id': 'gopay', 'name': 'GoPay', 'phone': '081234567890'};
    } else if (paymentMethod.contains('ovo') || paymentMethod.contains('OVO')) {
      accountInfo = {'id': 'ovo', 'name': 'OVO', 'phone': '081234567890'};
    } else if (paymentMethod.contains('dana') ||
        paymentMethod.contains('DANA')) {
      accountInfo = {'id': 'dana', 'name': 'DANA', 'phone': '081234567890'};
    } else if (paymentMethod.contains('shopeepay') ||
        paymentMethod.contains('ShopeePay')) {
      accountInfo = {
        'id': 'shopeepay',
        'name': 'ShopeePay',
        'phone': '081234567890'
      };
    }

    // Calculate deadline (24 hours from created_at)
    DateTime deadline = DateTime.now().add(const Duration(hours: 24));
    if (order['created_at'] != null) {
      try {
        final createdAt = DateTime.parse(order['created_at']);
        deadline = createdAt.add(const Duration(hours: 24));
      } catch (e) {
        // Use default deadline
      }
    }

    final totalAmount = (order['total_amount'] ?? 0).toDouble();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingPaymentScreen(
          orderId: order['id']?.toString() ?? '',
          paymentMethod: paymentMethod,
          totalAmount: totalAmount,
          accountInfo: accountInfo,
          deadline: deadline,
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Tidak diketahui';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return 'Tidak diketahui';
    }
  }

  String _getPaymentMethodName(String? method) {
    if (method == null) return 'Tidak diketahui';
    switch (method.toLowerCase()) {
      case 'cod':
        return 'Cash on Delivery (COD)';
      case 'bank_transfer':
        return 'Transfer Bank';
      case 'bca':
        return 'BCA Virtual Account';
      case 'mandiri':
        return 'Mandiri Virtual Account';
      case 'bni':
        return 'BNI Virtual Account';
      case 'bri':
        return 'BRI Virtual Account';
      case 'gopay':
        return 'GoPay';
      case 'ovo':
        return 'OVO';
      case 'dana':
        return 'DANA';
      case 'shopeepay':
        return 'ShopeePay';
      default:
        return method;
    }
  }

  void _confirmReceived(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Penerimaan'),
        content: const Text(
          'Apakah Anda sudah menerima pesanan ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Belum'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                order['status'] = 'Selesai';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pesanan telah dikonfirmasi diterima'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Sudah'),
          ),
        ],
      ),
    );
  }
}
