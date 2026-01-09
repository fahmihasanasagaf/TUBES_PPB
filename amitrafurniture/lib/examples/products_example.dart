import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ProductsWithSupabase extends StatefulWidget {
  const ProductsWithSupabase({super.key});

  @override
  State<ProductsWithSupabase> createState() => _ProductsWithSupabaseState();
}

class _ProductsWithSupabaseState extends State<ProductsWithSupabase> {
  final _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _supabaseService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_products.isEmpty) {
      return const Center(child: Text('Tidak ada produk'));
    }

    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ListTile(
          title: Text(product['name'] ?? ''),
          subtitle: Text('Rp ${product['price'] ?? 0}'),
          leading: product['image_url'] != null
              ? Image.network(product['image_url'], width: 50, height: 50)
              : const Icon(Icons.image),
          onTap: () {
            // Navigate to product detail
          },
        );
      },
    );
  }
}

Future<void> addProductExample() async {
  final supabaseService = SupabaseService();

  final productData = {
    'name': 'Kursi Baru',
    'price': 1500000,
    'description': 'Kursi yang nyaman',
    'category': 'Kursi',
    'stock': 10,
  };

  try {
    await supabaseService.addProduct(productData);
    print('Product added successfully');
  } catch (e) {
    print('Error adding product: $e');
  }
}
