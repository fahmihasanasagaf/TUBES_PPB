import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/supabase_service.dart';
import 'admin_dashboard_screen.dart';
import 'admin_products_screen.dart';
import 'admin_settings_screen.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;
  int _pendingCount = 0;
  int _processingCount = 0;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final ordersData = await _supabaseService.getOrders();
      _orders = ordersData;
      _calculateStats();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat pesanan: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _calculateStats() {
    _pendingCount = _orders.where((o) => o['status'] == 'pending').length;
    _processingCount = _orders.where((o) => o['status'] == 'processing').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tracking Pesanan'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      '$_pendingCount',
                      'Menunggu Konfirmasi',
                      Colors.grey.shade100,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      '$_processingCount',
                      'Diproses',
                      Colors.yellow.shade100,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Tracking Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tracking Pengiriman',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _loadOrders,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order List
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _orders.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(Icons.inbox_outlined,
                                        size: 64, color: Colors.grey.shade400),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Belum ada pesanan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _orders.length,
                              itemBuilder: (context, index) {
                                final order = _orders[index];
                                return _buildOrderCard(order);
                              },
                            ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) return;
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
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const AdminSettingsScreen()),
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
            icon: Icon(Icons.download),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    // Get order items
    final orderItems = order['order_items'] as List<dynamic>? ?? [];

    // Format date
    String formattedDate = 'N/A';
    if (order['created_at'] != null) {
      try {
        final date = DateTime.parse(order['created_at']);
        formattedDate = DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        formattedDate = order['created_at'].toString();
      }
    }

    // Get status display
    final status = order['status'] ?? 'pending';
    String statusDisplay = '';
    Color statusColor = Colors.grey;

    switch (status.toLowerCase()) {
      case 'pending':
        statusDisplay = 'Menunggu Konfirmasi';
        statusColor = Colors.orange;
        break;
      case 'processing':
        statusDisplay = 'Diproses';
        statusColor = Colors.blue;
        break;
      case 'shipped':
        statusDisplay = 'Dikirim';
        statusColor = Colors.green;
        break;
      case 'delivered':
        statusDisplay = 'Selesai';
        statusColor = Colors.teal;
        break;
      case 'cancelled':
        statusDisplay = 'Dibatalkan';
        statusColor = Colors.red;
        break;
      default:
        statusDisplay = status;
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['order_number'] ?? order['id'] ?? 'N/A',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.shopping_bag_outlined,
                  size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${orderItems.length} item',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Rp ${_formatPrice(order['total_amount']?.toDouble() ?? 0)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showOrderDetail(order);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade50,
                foregroundColor: Colors.blue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Lihat Detail'),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    // Get order items
    final orderItems = order['order_items'] as List<dynamic>? ?? [];

    // Format date
    String formattedDate = 'N/A';
    if (order['created_at'] != null) {
      try {
        final date = DateTime.parse(order['created_at']);
        formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);
      } catch (e) {
        formattedDate = order['created_at'].toString();
      }
    }

    // Get status display
    final status = order['status'] ?? 'pending';
    String statusDisplay = '';

    switch (status.toLowerCase()) {
      case 'pending':
        statusDisplay = 'Menunggu Konfirmasi';
        break;
      case 'processing':
        statusDisplay = 'Diproses';
        break;
      case 'shipped':
        statusDisplay = 'Dikirim';
        break;
      case 'delivered':
        statusDisplay = 'Selesai';
        break;
      case 'cancelled':
        statusDisplay = 'Dibatalkan';
        break;
      default:
        statusDisplay = status;
    }

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
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Detail Pesanan ${order['order_number'] ?? order['id'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Order Info
                  _buildDetailRow('Tanggal', formattedDate),
                  _buildDetailRow('Status', statusDisplay),
                  _buildDetailRow('Metode Pembayaran',
                      _getPaymentMethodDisplay(order['payment_method'] ?? '')),
                  _buildDetailRow('Metode Pembayaran',
                      _getPaymentMethodText(order['payment_method'] ?? '-')),
                  _buildDetailRow('Total',
                      'Rp ${_formatPrice(order['total_amount']?.toDouble() ?? 0)}'),
                  const Divider(height: 32),

                  // Product Info
                  const Text(
                    'Produk Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // List order items
                  if (orderItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Text(
                          'Tidak ada item',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    ...orderItems.map((item) {
                      final product = item['products'];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            // Product placeholder
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.shopping_bag,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product != null
                                        ? (product['name'] ?? 'Produk')
                                        : 'Produk',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item['quantity'] ?? 0} item × Rp ${_formatPrice(item['price']?.toDouble() ?? 0)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Subtotal: Rp ${_formatPrice((item['quantity'] ?? 0) * (item['price']?.toDouble() ?? 0))}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
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

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _printInvoice(order),
                          icon: const Icon(Icons.print, size: 18),
                          label: const Text('Cetak Invoice'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showUpdateStatusDialog(order),
                          icon: const Icon(Icons.sync, size: 18),
                          label: const Text('Update Status'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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

  void _showUpdateStatusDialog(Map<String, dynamic> order) {
    final orderId = order['id'];
    String currentStatus =
        (order['status'] ?? 'pending').toString().toLowerCase();

    // Normalize current status to match dropdown values
    if (!['pending', 'processing', 'shipped', 'delivered', 'cancelled']
        .contains(currentStatus)) {
      currentStatus = 'pending'; // Default to pending if status is unknown
    }

    String selectedStatus = currentStatus;

    final statusOptions = [
      {'value': 'pending', 'label': 'Menunggu Konfirmasi'},
      {'value': 'processing', 'label': 'Diproses'},
      {'value': 'shipped', 'label': 'Dikirim'},
      {'value': 'delivered', 'label': 'Selesai'},
      {'value': 'cancelled', 'label': 'Dibatalkan'},
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Update Status Pesanan'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pesanan: ${order['order_number'] ?? orderId}'),
                const SizedBox(height: 16),
                const Text(
                  'Pilih Status Baru:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedStatus,
                      items: statusOptions.map((status) {
                        return DropdownMenuItem<String>(
                          value: status['value'],
                          child: Text(status['label'] as String),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),
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
                onPressed: selectedStatus == currentStatus
                    ? null
                    : () async {
                        Navigator.pop(context);
                        Navigator.pop(context); // Close detail modal

                        try {
                          await _supabaseService.updateOrderStatus(
                              orderId, selectedStatus);
                          await _loadOrders();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Status pesanan berhasil diupdate'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Gagal update status: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Update'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _printInvoice(Map<String, dynamic> order) {
    Navigator.pop(context); // Close detail modal

    // Format date
    String formattedDate = 'N/A';
    if (order['created_at'] != null) {
      try {
        final date = DateTime.parse(order['created_at']);
        formattedDate = DateFormat('dd MMM yyyy HH:mm').format(date);
      } catch (e) {
        formattedDate = order['created_at'].toString();
      }
    }

    final orderItems = order['order_items'] as List<dynamic>? ?? [];

    // Build invoice text
    String invoice = '''
========================================
        INVOICE - A MITRA FURNITURE
========================================

Order Number: ${order['order_number'] ?? order['id']}
Tanggal: $formattedDate

----------------------------------------
DETAIL PESANAN
----------------------------------------
''';

    for (var item in orderItems) {
      final product = item['products'];
      final productName =
          product != null ? (product['name'] ?? 'Produk') : 'Produk';
      final qty = item['quantity'] ?? 0;
      final price = item['price']?.toDouble() ?? 0;
      final subtotal = qty * price;

      invoice += '\n$productName\n';
      invoice +=
          '$qty x Rp ${_formatPrice(price)} = Rp ${_formatPrice(subtotal)}\n';
    }

    invoice += '''
----------------------------------------
TOTAL: Rp ${_formatPrice(order['total_amount']?.toDouble() ?? 0)}
----------------------------------------

Metode Pembayaran: ${_getPaymentMethodDisplay(order['payment_method'] ?? '')}
Status Pesanan: ${order['status'] ?? 'pending'}

Alamat Pengiriman:
${order['shipping_address'] ?? '-'}

Telepon: ${order['phone'] ?? '-'}

========================================
     Terima kasih atas pesanan Anda!
========================================
''';

    // Show invoice preview
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Invoice Preview'),
          ],
        ),
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: SelectableText(
              invoice,
              style: const TextStyle(
                fontFamily: 'Courier',
                fontSize: 12,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Copy to clipboard
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invoice berhasil disalin!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.check, size: 18),
            label: const Text('OK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(Map<String, dynamic> order) {
    final orderId = order['id'];
    final currentStatus = order['status'] ?? 'pending';

    // Determine next status
    String nextStatus = '';
    switch (currentStatus.toLowerCase()) {
      case 'pending':
        nextStatus = 'processing';
        break;
      case 'processing':
        nextStatus = 'shipped';
        break;
      case 'shipped':
        nextStatus = 'delivered';
        break;
      default:
        nextStatus = currentStatus;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Update Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pesanan: ${order['order_number'] ?? orderId}'),
            Text('Status saat ini: $currentStatus'),
            Text('Status baru: $nextStatus'),
            const SizedBox(height: 16),
            const Text(
              'Status pesanan akan diupdate.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.pop(context); // Close detail modal too

              try {
                await _supabaseService.updateOrderStatus(orderId, nextStatus);
                await _loadOrders(); // Reload orders

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Status pesanan berhasil diupdate'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal update status: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  String _getPaymentMethodDisplay(String method) {
    switch (method.toLowerCase()) {
      case 'cod':
        return 'Cash on Delivery (COD)';
      case 'bank_transfer':
        return 'Transfer Bank';
      case 'e_wallet':
        return 'E-Wallet';
      default:
        return method;
    }
  }

  String _getPaymentMethodText(String method) {
    return _getPaymentMethodDisplay(method);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
