import 'package:amitrafurniture/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

// Export CartScreen untuk digunakan di main.dart
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CartPage();
  }
}

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<String> selectedItems = {}; // Track selected cart item IDs

  @override
  void initState() {
    super.initState();
    // Load cart items dari Supabase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser != null) {
        context.read<CartProvider>().loadCart(authProvider.currentUser!.id);
      }
    });
  }

  void _toggleSelectAll(List cartItems) {
    setState(() {
      if (selectedItems.length == cartItems.length) {
        selectedItems.clear();
      } else {
        selectedItems = cartItems.map((item) => item.id as String).toSet();
      }
    });
  }

  void _deleteSelected(
      BuildContext context, CartProvider cartProvider, String userId) async {
    if (selectedItems.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Item Terpilih?'),
        content: Text(
            'Yakin ingin menghapus ${selectedItems.length} item dari keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (final itemId in selectedItems) {
        await cartProvider.removeFromCart(userId, itemId);
      }
      setState(() {
        selectedItems.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CartProvider, AuthProvider>(
      builder: (context, cartProvider, authProvider, child) {
        if (authProvider.currentUser == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFE3F2FD),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text('Keranjang Saya',
                  style: TextStyle(color: Colors.black)),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text('Silakan login terlebih dahulu'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        }

        if (cartProvider.isLoading) {
          return Scaffold(
            backgroundColor: const Color(0xFFE3F2FD),
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text('Keranjang Saya',
                  style: TextStyle(color: Colors.black)),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final cartItems = cartProvider.cartItems;
        final hasItems = cartItems.isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFFE3F2FD),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Keranjang Saya',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              if (hasItems && selectedItems.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteSelected(
                      context, cartProvider, authProvider.currentUser!.id),
                  tooltip: 'Hapus Terpilih',
                ),
              if (hasItems)
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Semua?'),
                        content:
                            const Text('Yakin ingin mengosongkan keranjang?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              cartProvider
                                  .clearCart(authProvider.currentUser!.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'HAPUS SEMUA',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
            ],
          ),
          body: !hasItems
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      const Text('Keranjang Anda kosong',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Select All Checkbox
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Checkbox(
                            value: selectedItems.length == cartItems.length &&
                                cartItems.isNotEmpty,
                            onChanged: (value) => _toggleSelectAll(cartItems),
                            activeColor: Colors.blue,
                          ),
                          const Text(
                            'Pilih Semua',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (selectedItems.isNotEmpty) ...[
                            const Spacer(),
                            Text(
                              '${selectedItems.length} dipilih',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Checkbox
                                  Checkbox(
                                    value: selectedItems.contains(item.id),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedItems.add(item.id);
                                        } else {
                                          selectedItems.remove(item.id);
                                        }
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  // Product Image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: item.product.image.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              item.product.image,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Icon(Icons.image,
                                                    color: Colors.grey[400]);
                                              },
                                            ),
                                          )
                                        : Icon(Icons.chair,
                                            size: 40, color: Colors.grey[400]),
                                  ),
                                  const SizedBox(width: 12),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.product.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          item.product.price,
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.blue),
                                        ),
                                        const SizedBox(height: 12),
                                        // Quantity Controls
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (item.quantity > 1) {
                                                  await cartProvider
                                                      .updateQuantity(
                                                    authProvider
                                                        .currentUser!.id,
                                                    item.id,
                                                    item.quantity - 1,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[300]!),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(Icons.remove,
                                                    size: 16),
                                              ),
                                            ),
                                            Container(
                                              width: 40,
                                              alignment: Alignment.center,
                                              child: Text('${item.quantity}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await cartProvider
                                                    .updateQuantity(
                                                  authProvider.currentUser!.id,
                                                  item.id,
                                                  item.quantity + 1,
                                                );
                                              },
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey[300]!),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: const Icon(Icons.add,
                                                    size: 16),
                                              ),
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () async {
                                                await cartProvider
                                                    .removeFromCart(
                                                  authProvider.currentUser!.id,
                                                  item.id,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Bottom Bar with Total and Checkout
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Total:',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                    'Rp ${cartProvider.totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CheckoutScreen(
                                        selectedItems: cartItems
                                            .map((item) => CartItem(
                                                  id: item.product.id
                                                      .toString(),
                                                  name: item.product.name,
                                                  price: int.parse(item
                                                      .product.price
                                                      .replaceAll('Rp', '')
                                                      .replaceAll('.', '')
                                                      .trim()),
                                                  quantity: item.quantity,
                                                  isSelected: true,
                                                  imageUrl: item.product.image,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A90E2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Checkout',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

// CartItem model untuk checkout (digunakan oleh CheckoutScreen yang sudah ada)
class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  bool isSelected;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.isSelected,
    required this.imageUrl,
  });
}
