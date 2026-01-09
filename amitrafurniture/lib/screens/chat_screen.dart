import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text':
          'Halo! Selamat datang di A Mitra Furniture. Ada yang bisa kami bantu?',
      'isUser': false,
      'time': '09:00',
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isUser': true,
        'time': timeString,
      });
    });

    final userMessage = _messageController.text.toLowerCase();
    _messageController.clear();

    // Auto scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Auto reply after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      String reply = '';

      if (userMessage.contains('harga') || userMessage.contains('berapa')) {
        reply =
            'Untuk informasi harga produk, Anda bisa melihat langsung di katalog kami atau menanyakan produk spesifik yang Anda minati.';
      } else if (userMessage.contains('ongkir') ||
          userMessage.contains('pengiriman') ||
          userMessage.contains('kirim')) {
        reply =
            'Kami menyediakan 3 pilihan pengiriman:\n- Reguler: Rp 15.000 (3-5 hari)\n- Express: Rp 35.000 (1-2 hari)\n- Same Day: Rp 50.000 (hari yang sama)';
      } else if (userMessage.contains('bayar') ||
          userMessage.contains('pembayaran') ||
          userMessage.contains('payment')) {
        reply =
            'Kami menerima pembayaran melalui:\n- Transfer Bank (BCA, Mandiri, BNI, BRI)\n- E-Wallet (GoPay, OVO, DANA, ShopeePay)\n- COD (Cash on Delivery)';
      } else if (userMessage.contains('terima kasih') ||
          userMessage.contains('thanks') ||
          userMessage.contains('thank you')) {
        reply =
            'Sama-sama! Jangan ragu untuk bertanya jika ada yang ingin ditanyakan lagi. 😊';
      } else if (userMessage.contains('garansi') ||
          userMessage.contains('warranty')) {
        reply =
            'Semua produk kami dilengkapi dengan garansi 1 tahun untuk kerusakan manufaktur. Garansi tidak berlaku untuk kerusakan akibat pemakaian yang tidak wajar.';
      } else if (userMessage.contains('stok') ||
          userMessage.contains('ready') ||
          userMessage.contains('tersedia')) {
        reply =
            'Untuk ketersediaan stok produk tertentu, mohon sebutkan nama produknya. Atau Anda bisa cek langsung di halaman produk kami.';
      } else if (userMessage.contains('custom') ||
          userMessage.contains('pesan') ||
          userMessage.contains('order khusus')) {
        reply =
            'Ya, kami juga menerima pesanan custom sesuai kebutuhan Anda. Silakan hubungi customer service kami untuk diskusi lebih lanjut.';
      } else if (userMessage.contains('hai') ||
          userMessage.contains('halo') ||
          userMessage.contains('hello') ||
          userMessage.contains('hi')) {
        reply = 'Halo! Ada yang bisa kami bantu?';
      } else {
        reply =
            'Terima kasih atas pertanyaannya. Tim customer service kami akan segera membantu Anda. Untuk respon lebih cepat, Anda bisa hubungi kami di:\n📱 WhatsApp: 0812-3456-7890\n📧 Email: info@amitrafurniture.com';
      }

      if (mounted) {
        setState(() {
          _messages.add({
            'text': reply,
            'isUser': false,
            'time': timeString,
          });
        });

        // Auto scroll after reply
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3D9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.store,
                color: Color(0xFF2196F3),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'A Mitra Furniture',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Customer Service',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.support_agent,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF2196F3) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message['text'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser ? Colors.white : Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message['time'],
                    style: TextStyle(
                      fontSize: 10,
                      color: isUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Ketik pesan...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 14),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF2196F3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
