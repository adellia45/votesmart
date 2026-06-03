import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      CommonWidgets.showSnackBar(context, 'Username dan password wajib diisi!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final admin = await ApiService.loginAdmin(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (admin != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboardPage()),
        );
      }
        } else {
      if (mounted) {
        // DEBUG: Tambahkan print ini sementara
        print('ADMIN NULL! Ada error tersembunyi'); 
        CommonWidgets.showErrorDialog(
          context: context,
          title: 'Login Gagal',
          message: 'Coba cek bagian Debug Console di VS Code!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: MediaQuery.of(context).size.height * 0.1,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: const Icon(Icons.shield_rounded, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 28),
                Text('Selamat Datang Admin!', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 24, color: AppColors.textPrimary, height: 1.3), textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text('Masuk ke akun Anda untuk melanjutkan', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textSecondary, height: 1.5), textAlign: TextAlign.center),
                const SizedBox(height: 36),

                // Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Username', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _usernameFocus.hasFocus ? AppColors.primary : const Color(0xFFE5E7EB), width: 1.5),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        focusNode: _usernameFocus,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Masukkan username',
                          hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Icon(Icons.person_outline_rounded, color: _usernameFocus.hasFocus ? AppColors.primary : Colors.grey, size: 22),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _passwordFocus.hasFocus ? AppColors.primary : const Color(0xFFE5E7EB), width: 1.5),
                      ),
                      child: TextField(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        obscureText: _obscurePassword,
                        style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15, color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Masukkan password',
                          hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Icon(Icons.lock_outline_rounded, color: _passwordFocus.hasFocus ? AppColors.primary : Colors.grey, size: 22),
                          ),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(14),
                            child: GestureDetector(
                              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.grey, size: 22),
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Masuk Sekarang', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white)),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('atau', style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.grey))),
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Kembali ke Menu Utama', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}