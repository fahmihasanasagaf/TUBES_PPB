import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool agree = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0E2FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chair_outlined, size: 80, color: Color.fromARGB(255, 54, 156, 251)),
                const Text('Buat Akun',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  'Isi informasi Anda di bawah ini atau daftar dengan akun sosial Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
                _buildTextField('Nama', 'Jhon Doe'),
                const SizedBox(height: 10),
                _buildTextField('Email', 'Example@gmail.com'),
                const SizedBox(height: 10),
                _buildTextField('Kata sandi', '********', isPassword: true),
                Row(
                  children: [
                    Checkbox(
                        value: agree, 
                        onChanged: (v) => setState(() => agree = v!)),
                    const Expanded(
                        child: Text('Setuju dengan syarat & ketentuan')),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: agree ? () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(context, '/verify');
                    }
                  } : null,
                  child: const Text('Daftar',
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                const SizedBox(height: 15),
                const Text('Atau masuk dengan'),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png', height: 40, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                    const SizedBox(width: 20),
                    Image.asset('assets/images/whatsapp.png', height: 40, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Sudah punya akun? ',
                      style: TextStyle(fontSize: 14),
                      children: [
                        TextSpan(
                          text: 'Masuk',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_off, color: Colors.black)
            : null,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label harus diisi';
        }
        return null;
      },
    );
  }
}