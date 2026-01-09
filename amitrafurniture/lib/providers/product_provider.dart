import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  final _supabaseService = SupabaseService();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _supabaseService.getProducts();
      _products = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat produk: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProductsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _supabaseService.getProductsByCategory(category);
      _products = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat produk: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Map<String, dynamic> product) async {
    try {
      await _supabaseService.addProduct(product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah produk: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> product) async {
    try {
      await _supabaseService.updateProduct(id, product);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal update produk: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await _supabaseService.deleteProduct(id);
      await loadProducts();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal hapus produk: $e';
      notifyListeners();
      return false;
    }
  }
}
