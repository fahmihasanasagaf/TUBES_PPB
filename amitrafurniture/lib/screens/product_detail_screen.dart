import 'package:flutter/material.dart';
import '../models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  // Simulasi stok produk - UPDATED dengan data yang sama seperti di HomePage
  final Map<String, int> productStock = {
    'Kursi Goyang': 8,
    'Kursi Santai': 15,
    'Ranjang Susun Tingkat': 4,
    'Ranjang Modern': 6,
    'Laci Modern Retro': 7,
    'Buffet Jati Laci': 3,
    'Sofa Metal Feet': 5,
    'Lorenz Seater Sofa': 2,
  };

  // Counter untuk jumlah produk yang ingin ditambahkan
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final stock = productStock[widget.product.name] ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFACD2FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image - DIPERBESAR
            Container(
              width: double.infinity,
              height: 350, // Dinaikkan dari 300
              color: Colors.grey[50],
              child: Center(
                child: Image.asset(
                  widget.product.image,
                  height: 280, // Dinaikkan dari 250
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.chair_outlined,
                      size: 140, // Dinaikkan dari 120
                      color: Colors.grey[400],
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Price
                  Text(
                    widget.product.price,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF86BBF9),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stock Info
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: stock > 0 ? Colors.green[50] : Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: stock > 0 ? Colors.green[300]! : Colors.red[300]!,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          stock > 0 ? Icons.check_circle : Icons.cancel,
                          size: 18,
                          color: stock > 0 ? Colors.green[700] : Colors.red[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          stock > 0 ? 'Stok tersedia: $stock unit' : 'Stok habis',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: stock > 0 ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quantity Selector (hanya muncul jika ada stok)
                  if (stock > 0) ...[
                    const Text(
                      'Jumlah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: const Color(0xFF86BBF9),
                          iconSize: 32,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: quantity < stock
                              ? () {
                                  setState(() {
                                    quantity++;
                                  });
                                }
                              : null,
                          icon: const Icon(Icons.add_circle_outline),
                          color: const Color(0xFF86BBF9),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Maks: $stock',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Product Description
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),

                  // Product Specifications
                  const Text(
                    'Spesifikasi Produk',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Gunakan specifications langsung dari model, bukan legacy properties
                  ...widget.product.specifications.map((spec) => 
                    _buildSpecItem('• $spec')
                  ).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: stock > 0
                  ? () {
                      _addToCart(context);
                    }
                  : null,
              icon: const Icon(Icons.shopping_cart_outlined, size: 22),
              label: Text(
                stock > 0 ? '+ Keranjang ($quantity)' : 'Stok Habis',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: stock > 0 ? const Color(0xFF2196F3) : Colors.grey,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[800],
          height: 1.5,
        ),
      ),
    );
  }

  void _addToCart(BuildContext context) {
    final stock = productStock[widget.product.name] ?? 0;

    if (quantity > stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jumlah melebihi stok yang tersedia ($stock unit)'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Kurangi stok (dalam aplikasi nyata, ini harus update ke database)
    setState(() {
      productStock[widget.product.name] = stock - quantity;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$quantity ${widget.product.name} ditambahkan ke keranjang'),
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

    // Reset quantity ke 1
    setState(() {
      quantity = 1;
    });
  }
}