import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'data_kandidat_screen.dart'; // BENAR: Pakai DataKandidatScreen
import 'hasil_voting_screen.dart';  // BENAR: Pakai HasilVotingScreen
import 'pengaturan_screen.dart';
import '../login_page.dart'; // ← RAHASIA: Import halaman Admin (naik 1 folder ke lib/)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF01367A), Color(0xFF0245A3), Color(0xFF0355C4)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 0, bottom: 80,
                child: _buildCartun(path: 'assets/images/kartun_kiri.png', width: isWide ? 200 : 130),
              ),
              Positioned(
                right: 0, bottom: 80,
                child: _buildCartun(path: 'assets/images/kartun_kanan.png', width: isWide ? 200 : 130),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // ── LOGO (KLIK UNTUK MASUK ADMIN) ──
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginPage()));
                        },
                        child: Image.asset(
                          'assets/images/logo_smk4.png',
                          width: 80, height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                              ),
                              child: const Icon(Icons.school, size: 40, color: Colors.white),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),
                      Text('PEMILIHAN KETUA OSIS\n& KETUA MPK', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white, fontSize: isWide ? 24 : 18, fontWeight: FontWeight.bold, height: 1.3, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text('Masa Bakti 2026 - 2027', style: GoogleFonts.inter(color: const Color(0xFF90CAF9), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                      ),
                      const SizedBox(height: 16),
                      Text('Gunakan hak suaramu dengan bijak! Pemilihan ini dilakukan secara digital untuk menentukan pemimpin OSIS dan MPK periode selanjutnya.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 13, height: 1.5)),
                      const SizedBox(height: 32),

                      // Tombol Masuk
                      _buildButton(
                        label: 'Masuk',
                        icon: Icons.login_rounded,
                        isPrimary: true,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                        },
                      ),
                      const SizedBox(height: 14),

                      // Tombol Data Kandidat
                      _buildButton(
                        label: 'Data Kandidat',
                        icon: Icons.people_rounded,
                        isPrimary: false,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const DataKandidatScreen()));
                        },
                      ),
                      const SizedBox(height: 14),

                      // Tombol Hasil Voting
                      _buildButton(
                        label: 'Hasil Voting',
                        icon: Icons.bar_chart_rounded,
                        isPrimary: false,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HasilVotingScreen()));
                        },
                      ),
                      const SizedBox(height: 14),

                      // Tombol Pengaturan
                      _buildButton(
                        label: 'Pengaturan',
                        icon: Icons.settings_rounded,
                        isPrimary: false,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PengaturanScreen()));
                        },
                      ),
                      const SizedBox(height: 32),
                      Text('e-voting SMKN 4 Bogor 2026', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.4), fontSize: 11, letterSpacing: 1)),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required IconData icon, required bool isPrimary, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isPrimary ? Colors.white : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: isPrimary ? null : Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: isPrimary ? const Color(0xFF0245A3) : Colors.white.withOpacity(0.9)),
              const SizedBox(width: 12),
              Text(label, style: GoogleFonts.inter(color: isPrimary ? const Color(0xFF0245A3) : Colors.white.withOpacity(0.9), fontSize: 15, fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartun({required String path, required double width}) {
    final height = width * (277 / 415);
    return Image.asset(path, width: width, height: height, fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Opacity(opacity: 0.3, child: Container(width: width, height: height, color: Colors.transparent, child: const Center(child: Icon(Icons.person, size: 60, color: Colors.white))));
      },
    );
  }
}