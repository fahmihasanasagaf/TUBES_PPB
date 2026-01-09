import 'package:flutter/foundation.dart';
import '../services/supabase_service.dart';

class OrderProvider with ChangeNotifier {
  final _supabaseService = SupabaseService();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadOrders(String userId) async {
    print('=== OrderProvider: Starting loadOrders for user $userId ===');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('OrderProvider: Calling SupabaseService.getOrdersByUser...');
      _orders = await _supabaseService.getOrdersByUser(userId);
      print('OrderProvider: Received ${_orders.length} orders from service');

      // Log each order details
      for (var order in _orders) {
        print(
            'OrderProvider: Order ${order['id']} - ${order['status']} - Total: ${order['total_amount']}');
      }

      if (_orders.isNotEmpty) {
        print('OrderProvider: Orders loaded successfully:');
        for (int i = 0; i < _orders.length; i++) {
          print(
              '  Order $i: ${_orders[i]['id']} - Status: ${_orders[i]['status']} - Items: ${_orders[i]['order_items']?.length ?? 0}');
        }
      } else {
        print('OrderProvider: No orders found - showing empty state');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('OrderProvider: Error loading orders: $e');
      _errorMessage = 'Gagal memuat pesanan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _supabaseService.getOrders();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal memuat pesanan: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    try {
      await _supabaseService.createOrder(orderData);
      return true;
    } catch (e) {
      _errorMessage = 'Gagal membuat pesanan: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await _supabaseService.updateOrderStatus(orderId, status);
      await loadAllOrders();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal update status: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh(String userId) async {
    _errorMessage = null;
    await loadOrders(userId);
  }
}
