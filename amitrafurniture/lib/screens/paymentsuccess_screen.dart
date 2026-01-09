import 'package:flutter/material.dart';
import 'orders_screen.dart';
import 'chat_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3D9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PEMBAYARAN',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon with Badge Style
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Outer Badge Circle
                        Center(
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 3,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check,
                                size: 50,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Badge Edges
                        Positioned(
                          top: 5,
                          left: 25,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          top: 5,
                          right: 25,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          bottom: 5,
                          left: 25,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 25,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          top: 15,
                          left: 10,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          top: 15,
                          right: 10,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 10,
                          child: _buildBadgeEdge(),
                        ),
                        Positioned(
                          bottom: 15,
                          right: 10,
                          child: _buildBadgeEdge(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Success Message
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Terimakasih atas pembelian anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to orders screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3D9FF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Lihat Pesanan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFB3D9FF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, Icons.person_outline, false, null),
                _buildNavItem(context, Icons.chat_bubble_outline, false,
                    const ChatScreen()),
                _buildNavItem(
                    context, Icons.shopping_cart_outlined, false, null),
                _buildNavItem(
                    context, Icons.notifications_outlined, false, null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeEdge() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, bool isActive, Widget? screen) {
    return InkWell(
      onTap: screen != null
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 28,
          color: isActive ? Colors.blue[900] : Colors.black54,
        ),
      ),
    );
  }
}

// Cara penggunaan:
// Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => const PaymentSuccessScreen(),
//   ),
// );
