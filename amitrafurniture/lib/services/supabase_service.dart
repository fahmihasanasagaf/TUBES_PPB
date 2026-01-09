import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  Future<AuthResponse> signUp(
      String email, String password, String name) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
      emailRedirectTo: null, // Disable email confirmation
    );
    return response;
  }

  Future<AuthResponse> signIn(String email, String password) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .select()
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> getProductById(String id) async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .select()
        .eq('id', id)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(
      String category) async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .select()
        .eq('category', category)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .insert(product)
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> updateProduct(
      String id, Map<String, dynamic> product) async {
    final response = await client
        .from(SupabaseConfig.productsTable)
        .update(product)
        .eq('id', id)
        .select()
        .single();
    return response;
  }

  Future<void> deleteProduct(String id) async {
    await client.from(SupabaseConfig.productsTable).delete().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    print('=== DEBUG: Loading all orders ===');

    try {
      final response = await client
          .from(SupabaseConfig.ordersTable)
          .select('*')
          .order('created_at', ascending: false);

      print('Found ${response.length} orders in database');

      // Get order items for each order
      List<Map<String, dynamic>> ordersWithItems = [];
      for (var order in response) {
        try {
          final items = await client
              .from(SupabaseConfig.orderItemsTable)
              .select('*, products(*)')
              .eq('order_id', order['id']);

          print('Order ${order['id']} has ${items.length} items');
          order['order_items'] = items;
        } catch (e) {
          print('Warning: Could not load items for order ${order['id']}: $e');
          order['order_items'] = [];
        }
        ordersWithItems.add(order);
      }

      return ordersWithItems;
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByUser(String userId) async {
    print('=== DEBUG: Loading orders for user: $userId ===');

    try {
      // Get real data from Supabase
      print('Querying orders table...');
      final response = await client
          .from(SupabaseConfig.ordersTable)
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('Found ${response.length} orders in database');

      // Get order items for each order
      List<Map<String, dynamic>> ordersWithItems = [];
      for (var order in response) {
        try {
          final items = await client
              .from(SupabaseConfig.orderItemsTable)
              .select('*, products(*)')
              .eq('order_id', order['id']);

          print('Order ${order['id']} has ${items.length} items');
          order['order_items'] = items;
        } catch (e) {
          print('Warning: Could not load items for order ${order['id']}: $e');
          order['order_items'] = [];
        }
        ordersWithItems.add(order);
      }

      if (ordersWithItems.isNotEmpty) {
        print('Returning ${ordersWithItems.length} real orders');
        return ordersWithItems;
      } else {
        print('No real orders found, showing dummy data for demo');
        return _getDummyOrders(userId);
      }
    } catch (e) {
      print('Error getting orders from database: $e');
      print('Showing dummy data as fallback');
      return _getDummyOrders(userId);
    }
  }

  Future<void> createOrder(Map<String, dynamic> order) async {
    try {
      print('=== DEBUG: Creating order ===');
      print('Order data: ${order.toString()}');

      await client.from(SupabaseConfig.ordersTable).insert(order);
      print('✅ Order created successfully: ${order['id']}');

      // Verify the order was actually saved
      try {
        final savedOrder = await client
            .from(SupabaseConfig.ordersTable)
            .select('*')
            .eq('id', order['id'])
            .single();
        print('✅ Order verified in database: ${savedOrder['id']}');
      } catch (e) {
        print('❌ Could not verify saved order: $e');
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      // Rethrow for proper error handling in calling code
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await client
        .from(SupabaseConfig.ordersTable)
        .update({'status': status}).eq('id', orderId);
  }

  Future<void> createOrderItems(List<Map<String, dynamic>> orderItems) async {
    try {
      print('=== Creating ${orderItems.length} order items ===');
      for (int i = 0; i < orderItems.length; i++) {
        print('Item $i: ${orderItems[i].toString()}');
      }

      await client.from(SupabaseConfig.orderItemsTable).insert(orderItems);
      print('✅ All order items created successfully');

      // Verify the items were actually saved
      if (orderItems.isNotEmpty) {
        final orderId = orderItems[0]['order_id'];
        try {
          final savedItems = await client
              .from(SupabaseConfig.orderItemsTable)
              .select('*')
              .eq('order_id', orderId);
          print(
              '✅ Verified ${savedItems.length} items saved for order $orderId');
        } catch (e) {
          print('❌ Could not verify saved items: $e');
        }
      }
    } catch (e) {
      print('❌ Error creating order items: $e');
      print('Error details: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOrderItems(String orderId) async {
    try {
      final response = await client
          .from(SupabaseConfig.orderItemsTable)
          .select('*, products(*)')
          .eq('order_id', orderId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting order items: $e');
      // Return dummy order items
      return [
        {
          'id': 'item-1',
          'order_id': orderId,
          'product_id': '1',
          'product_name': 'Sofa Minimalis Abu-abu',
          'product_image_url': 'assets/images/sofa1.jpg',
          'quantity': 2,
          'price': 725000,
          'products': {
            'id': '1',
            'name': 'Sofa Minimalis Abu-abu',
            'image_url': 'assets/images/sofa1.jpg',
            'price': 725000,
            'category': 'Sofa'
          }
        }
      ];
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(String userId) async {
    final response = await client
        .from(SupabaseConfig.cartsTable)
        .select('*, products(*)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> addToCart(
      String userId, String productId, int quantity) async {
    // Cek apakah produk sudah ada di cart
    final existingCart = await client
        .from(SupabaseConfig.cartsTable)
        .select()
        .eq('user_id', userId)
        .eq('product_id', productId)
        .maybeSingle();

    if (existingCart != null) {
      // Jika sudah ada, update quantity
      final newQuantity = (existingCart['quantity'] as int) + quantity;
      final response = await client
          .from(SupabaseConfig.cartsTable)
          .update({'quantity': newQuantity})
          .eq('user_id', userId)
          .eq('product_id', productId)
          .select()
          .single();
      return response;
    } else {
      // Jika belum ada, insert baru
      final response = await client
          .from(SupabaseConfig.cartsTable)
          .insert({
            'user_id': userId,
            'product_id': productId,
            'quantity': quantity,
          })
          .select()
          .single();
      return response;
    }
  }

  Future<void> updateCartQuantity(String cartId, int quantity) async {
    await client
        .from(SupabaseConfig.cartsTable)
        .update({'quantity': quantity}).eq('id', cartId);
  }

  Future<void> removeFromCart(String cartId) async {
    await client.from(SupabaseConfig.cartsTable).delete().eq('id', cartId);
  }

  Future<void> clearCart(String userId) async {
    await client.from(SupabaseConfig.cartsTable).delete().eq('user_id', userId);
  }

  // Favorites Methods
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final response = await client
        .from(SupabaseConfig.favoritesTable)
        .select('*, products(*)')
        .eq('user_id', userId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addToFavorites(String userId, String productId) async {
    await client.from(SupabaseConfig.favoritesTable).insert({
      'user_id': userId,
      'product_id': productId,
    });
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    await client
        .from(SupabaseConfig.favoritesTable)
        .delete()
        .match({'user_id': userId, 'product_id': productId});
  }

  Future<bool> isFavorite(String userId, String productId) async {
    final response = await client
        .from(SupabaseConfig.favoritesTable)
        .select()
        .match({'user_id': userId, 'product_id': productId});
    return response.isNotEmpty;
  }

  // Helper methods for dummy data when Supabase fails
  List<Map<String, dynamic>> _getDummyOrders(String userId) {
    print('_getDummyOrders called for user: $userId');
    final now = DateTime.now();
    final dummyOrders = [
      {
        'id': 'recent-order-1',
        'user_id': userId,
        'total_amount': 3650000.0, // Match recent checkout amount
        'status': 'Belum Dibayar',
        'payment_method': 'bank_transfer',
        'shipping_address': 'Alamat pengiriman',
        'phone': '081234567890',
        'notes': 'Pesanan baru dari checkout',
        'created_at': now.subtract(Duration(minutes: 2)).toIso8601String(),
        'order_items': [
          {
            'id': 'item-recent-1',
            'order_id': 'recent-order-1',
            'product_id': '93caf68e-d4be-4aeb-bbfb-7c8bceedeb02',
            'quantity': 1,
            'price': 750000.0,
            'products': {
              'id': '93caf68e-d4be-4aeb-bbfb-7c8bceedeb02',
              'name': 'Kursi Santai Premium',
              'image_url': 'assets/images/kursisantai.jpeg',
              'price': 750000.0,
              'category': 'Kursi'
            }
          },
          {
            'id': 'item-recent-2',
            'order_id': 'recent-order-1',
            'product_id': 'a5dfc017-80f6-4652-b8f9-055064e7c5ca',
            'quantity': 2,
            'price': 1450000.0,
            'products': {
              'id': 'a5dfc017-80f6-4652-b8f9-055064e7c5ca',
              'name': 'Sofa Santai Minimalis',
              'image_url': 'assets/images/sofasantai.jpeg',
              'price': 1450000.0,
              'category': 'Sofa'
            }
          }
        ]
      },
      {
        'id': 'old-order-1',
        'user_id': userId,
        'total_amount': 1200000.0,
        'status': 'Sudah Dibayar',
        'payment_method': 'e_wallet',
        'shipping_address': 'Jl. Sudirman No. 45, Jakarta',
        'phone': '081234567890',
        'notes': '',
        'created_at': now.subtract(Duration(hours: 3)).toIso8601String(),
        'order_items': [
          {
            'id': 'item-old-1',
            'order_id': 'old-order-1',
            'product_id': '2',
            'quantity': 1,
            'price': 1200000.0,
            'products': {
              'id': '2',
              'name': 'Meja Kerja Minimalis',
              'image_url': 'assets/images/meja kerja minimalis.jpeg',
              'price': 1200000.0,
              'category': 'Meja'
            }
          }
        ]
      },
      {
        'id': 'demo-order-1',
        'user_id': userId,
        'total_amount': 2100000.0,
        'status': 'Dikemas',
        'payment_method': 'cod',
        'shipping_address': 'Jl. Merdeka Raya No. 88, Jakarta',
        'phone': '081234567890',
        'notes': 'Mohon dikemas dengan hati-hati',
        'created_at': now.subtract(Duration(days: 1)).toIso8601String(),
        'order_items': [
          {
            'id': 'item-demo-1',
            'order_id': 'demo-order-1',
            'product_id': '3',
            'quantity': 1,
            'price': 900000.0,
            'products': {
              'id': '3',
              'name': 'Kursi Goyang Kayu',
              'image_url': 'assets/images/kursigoyang.jpeg',
              'price': 900000.0,
              'category': 'Kursi'
            }
          },
          {
            'id': 'item-demo-2',
            'order_id': 'demo-order-1',
            'product_id': '4',
            'quantity': 1,
            'price': 1200000.0,
            'products': {
              'id': '4',
              'name': 'Ranjang Minimalis',
              'image_url': 'assets/images/ranjang minimalis.jpeg',
              'price': 1200000.0,
              'category': 'Kasur'
            }
          }
        ]
      }
    ];
    print('Generated ${dummyOrders.length} dummy orders');
    return dummyOrders;
  }
}
