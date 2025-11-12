import 'package:flutter/material.dart';
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




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      },
    );
  }
}
