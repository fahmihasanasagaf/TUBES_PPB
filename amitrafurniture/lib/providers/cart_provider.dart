import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final _supabaseService = SupabaseService();
  List<CartItemModel> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CartItemModel> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get itemCount => _cartItems.length;

  double get totalAmount {
    return _cartItems.fold(0.0, (sum, item) {
      // Parse price string "Rp 500.000" to double
      final priceString = item.product.price.replaceAll(RegExp(r'[^0-9]'), '');
      final price = double.tryParse(priceString) ?? 0;
      return sum + (price * item.quantity);
    });
  }

  Future<void> loadCart(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await _supabaseService.getCartItems(userId);
      _cartItems = data.map((json) => CartItemModel.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat keranjang: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(String userId, String productId, int quantity) async {
    try {
      await _supabaseService.addToCart(userId, productId, quantity);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambah ke keranjang: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateQuantity(
      String userId, String cartId, int quantity) async {
    try {
      await _supabaseService.updateCartQuantity(cartId, quantity);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal update jumlah: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFromCart(String userId, String cartId) async {
    try {
      await _supabaseService.removeFromCart(cartId);
      await loadCart(userId);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal hapus item: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> clearCart(String userId) async {
    try {
      await _supabaseService.clearCart(userId);
      _cartItems = [];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengosongkan keranjang: $e';
      notifyListeners();
      return false;
    }
  }
}
