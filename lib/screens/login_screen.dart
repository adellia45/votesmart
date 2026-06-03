import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'pilih_voting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nisnController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _nisnFocus = FocusNode();
  bool _isLoading = false;
  bool _obscureNisn = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _nisnController.dispose();
    _usernameFocus.dispose();
    _nisnFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _nisnController.text.isEmpty) {
      CommonWidgets.showSnackBar(context, 'Username dan NISN wajib diisi!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final user = await ApiService.loginPemilih(
      _usernameController.text.trim(),
      _nisnController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (user != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PilihVotingScreen(user: user)),
        );
      }
    } else {
      if (mounted) {
        CommonWidgets.showErrorDialog(
          context: context,
          title: 'Login Gagal',
          message: 'Username atau NISN tidak ditemukan. Silakan coba lagi.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CommonWidgets.buildAppBar(
          title: 'Login Pemilih',
          context: context,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.how_to_vote_rounded, size: 40, color: AppColors.primary),
              ),
              
              const SizedBox(height: 24),
              Text(
                'Selamat Datang',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Masukkan Nama Pengguna dan NISN Anda',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Username Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _usernameFocus.hasFocus ? AppColors.primary : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
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
              
              // NISN Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NISN', style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _nisnFocus.hasFocus ? AppColors.primary : const Color(0xFFE5E7EB),
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: _nisnController,
                      focusNode: _nisnFocus,
                      obscureText: _obscureNisn,
                      keyboardType: TextInputType.number,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 15, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Masukkan NISN',
                        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Icon(Icons.badge_outlined, color: _nisnFocus.hasFocus ? AppColors.primary : Colors.grey, size: 22),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: GestureDetector(
                            onTap: () => setState(() => _obscureNisn = !_obscureNisn),
                            child: Icon(
                              _obscureNisn ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 22,
                            ),
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
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
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
              
              const SizedBox(height: 16),
              
              Text(
                'Hubungi admin jika Anda lupa NISN',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}