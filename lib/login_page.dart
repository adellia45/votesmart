import 'package:flutter/material.dart';
import 'dashboard_page.dart'; // Memanggil file halaman dashboard

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: size.height * 0.1,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E5CFF),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E5CFF).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Selamat Datang Admin!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Color(0xFF141B34),
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masuk ke akun Anda untuk melanjutkan',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 36),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Username', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF141B34))),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _usernameFocus.hasFocus ? const Color(0xFF2E5CFF) : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFF141B34)),
                        decoration: InputDecoration(
                          hintText: 'Masukkan username Anda',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF9CA3AF)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Icon(Icons.person_outline_rounded, color: _usernameFocus.hasFocus ? const Color(0xFF2E5CFF) : const Color(0xFF9CA3AF), size: 22),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Password', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF141B34))),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _passwordFocus.hasFocus ? const Color(0xFF2E5CFF) : const Color(0xFFE5E7EB),
                          width: 1.5,
                        ),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Color(0xFF141B34)),
                        decoration: InputDecoration(
                          hintText: 'Masukkan password Anda',
                          hintStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF9CA3AF)),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Icon(Icons.lock_outline_rounded, color: _passwordFocus.hasFocus ? const Color(0xFF2E5CFF) : const Color(0xFF9CA3AF), size: 22),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: GestureDetector(
                              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF9CA3AF), size: 22),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text('Lupa Password?', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF2E5CFF))),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    // NAVIGASI KE DASHBOARD
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5CFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text('Masuk Sekarang', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('atau', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Color(0xFF9CA3AF)))),
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}