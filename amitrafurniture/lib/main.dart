import 'package:amitrafurniture/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_page.dart';
import 'screens/verify_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'screens/customer_service_page.dart';
import 'screens/cart_screen.dart';
import 'screens/notification_page.dart';
import 'screens/order_history_page.dart';
import 'screens/sofa_screen.dart';
import 'screens/ranjang_screen.dart';
import 'screens/meja_screen.dart';
import 'screens/login_admin_screen.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/admin_products_screen.dart';
import 'screens/admin_orders_screen.dart';
import 'screens/admin_settings_screen.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Furniture App',
        theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: const Color(0xFFD0E2FF),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomeScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterPage(),
          '/verify': (context) => const VerifyPage(),
          '/home': (context) => const HomePage(),
          '/profile': (context) => const ProfilePage(),
          '/customer_service': (context) => const CustomerServicePage(),
          '/cart': (context) => const CartScreen(),
          '/notification': (context) => NotificationPage(),
          '/order_history': (context) => const OrderHistoryPage(),
          '/sofa': (context) => const SofaScreen(),
          '/ranjang': (context) => const RanjangScreen(),
          '/meja': (context) => const MejaScreen(),
          'checkout': (context) => CheckoutScreen(selectedItems: []),
          '/admin_login': (context) => const LoginAdminScreen(),
          '/admin_dashboard': (context) => const AdminDashboardScreen(),
          '/admin_products': (context) => const AdminProductsScreen(),
          '/admin_orders': (context) => const AdminOrdersScreen(),
          '/admin_settings': (context) => const AdminSettingsScreen(),
        },
      ),
    );
  }
}
