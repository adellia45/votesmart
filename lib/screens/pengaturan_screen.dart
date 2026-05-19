import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'akun_settings_screen.dart';
import 'about_screen.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0245A3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Pengaturan',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Menu Akun ──
          _buildMenuGroup(
            context,
            title: 'Akun',
            children: [
              _buildMenuItem(
                context,
                icon: Icons.login_rounded,
                label: 'Login',
                onTap: () {
                  Navigator.pop(context); // balik ke home dulu
                  // TODO: Navigasi ke login jika dari sini
                },
              ),
              _buildMenuItem(
                context,
                icon: Icons.settings_rounded,
                label: 'Pengaturan Akun',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AkunSettingsScreen()),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Menu Aplikasi ──
          _buildMenuGroup(
            context,
            title: 'Aplikasi',
            children: [
              _buildMenuItem(
                context,
                icon: Icons.info_outline_rounded,
                label: 'Tentang Aplikasi',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget group menu (misal: "Akun", "Aplikasi")
  Widget _buildMenuGroup(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF0245A3),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  /// Widget item menu
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0245A3).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF0245A3), size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}