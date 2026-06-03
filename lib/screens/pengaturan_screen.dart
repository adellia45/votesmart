import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import 'about_screen.dart';

class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Pengaturan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          Text('Pengaturan Aplikasi', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          
          _buildMenuCard(context, items: [
            _MenuItem(icon: Icons.help_outline_rounded, title: 'Panduan Penggunaan', screen: const _PanduanScreen()),
            _MenuItem(icon: Icons.shield_outlined, title: 'Kebijakan Privasi', screen: const _PrivasiScreen()),
            _MenuItem(icon: Icons.info_outline_rounded, title: 'Tentang Aplikasi', screen: const AboutScreen()),
            _MenuItem(icon: Icons.update_outlined, title: 'Versi Aplikasi', screen: const _VersiScreen()),
            // DIPERBAIKI: Icon warna dipisah, tidak pakai const langsung
          ]),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required List<_MenuItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: items.map((item) {
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.screen)),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                          // DIPERBAIKI: Warna icon diambil dari parameter class
                          child: Icon(item.icon, color: item.iconColor ?? AppColors.primary, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Text(item.title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary))),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
                      ],
                    ),
                  ),
                ),
              ),
              if (item != items.last) const Divider(height: 1, indent: 72, color: Color(0xFFE5E7EB)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final Color? iconColor; // DITAMBAHKAN
  final String title;
  final Widget screen;
  // DIPERBAIKI: Hapus const karena ada parameter nullable
  _MenuItem({required this.icon, this.iconColor, required this.title, required this.screen});
}

// ==========================================
// SUB HALAMAN 1: PANDUAN PENGGUNAAN
// ==========================================
class _PanduanScreen extends StatelessWidget {
  const _PanduanScreen();

  // DIPERBAIKI: Tipe data String (bukan String?)
  final List<Map<String, String>> steps = const [
    {'title': 'Login Akun', 'desc': 'Masuk menggunakan Username dan NISN yang sudah terdaftar oleh panitia.'},
    {'title': 'Pilih Kategori', 'desc': 'Pilih menu voting yang tersedia (Pilketos atau Pilketum).'},
    {'title': 'Lihat Profil Calon', 'desc': 'Klik kandidat untuk melihat visi, misi, dan profil lengkap mereka.'},
    {'title': 'Lakukan Voting', 'desc': 'Tekan tombol "Pilih" pada kandidat pilihanmu. Voting tidak bisa diubah.'},
    {'title': 'Selesai', 'desc': 'Setelah memilih, sistem akan otomatis menyimpan suara dan mengunci pilihanmu.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, centerTitle: true,
        title: Text('Panduan Penggunaan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(16), // DIPERBAIKI
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))]
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text('${index + 1}', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(steps[index]['title']!, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)), // DIPERBAIKI !
                      const SizedBox(height: 4),
                      Text(steps[index]['desc']!, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.4)), // DIPERBAIKI !
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// SUB HALAMAN 2: KEBIJAKAN PRIVASI
// ==========================================
class _PrivasiScreen extends StatelessWidget {
  const _PrivasiScreen();

  // DIPERBAIKI: Tipe data String
  final List<Map<String, String>> policies = const [
    {'title': 'Pengumpulan Data', 'desc': 'Aplikasi hanya mengumpulkan data NISN dan pilihan voting yang bersifat rahasia.'},
    {'title': 'Keamanan Server', 'desc': 'Data pemilih tersimpan di server lokal sekolah yang dilindungi.'},
    {'title': 'Penggunaan Data', 'desc': 'Data hanya digunakan untuk keperluan rekapitulasi suara OSIS/MPK.'},
    {'title': 'Hak Pengguna', 'desc': 'Pengguna berhak untuk menanyakan status voting mereka kepada panitia.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, centerTitle: true,
        title: Text('Kebijakan Privasi', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: policies.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(16), // DIPERBAIKI
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.lock_rounded, color: Color(0xFFEF4444), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(policies[index]['title']!, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)), // DIPERBAIKI !
                  ],
                ),
                const SizedBox(height: 8),
                Text(policies[index]['desc']!, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.5)), // DIPERBAIKI !
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// SUB HALAMAN 3: TENTANG APLIKASI (Pakai AboutScreen asli)
// ==========================================
// (Karena kita sudah punya file about_screen.dart yang lengkap)

// ==========================================
// SUB HALAMAN 4: VERSI APLIKASI
// ==========================================
class _VersiScreen extends StatelessWidget {
  const _VersiScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary, foregroundColor: Colors.white, elevation: 0, centerTitle: true,
        title: Text('Versi Aplikasi', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(16), // DIPERBAIKI
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
              ),
              child: Column(
                children: [
                  const Icon(Icons.system_update_rounded, color: AppColors.primary, size: 50),
                  const SizedBox(height: 16),
                  Text('Versi 1.0.0', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                    child: Text('Versi Terbaru', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                  ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(16), // DIPERBAIKI
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Riwayat Pembarikan', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _buildUpdateLog('v1.0.0 (Mei 2026)', 'Rilis awal aplikasi e-Voting SMKN 4 Bogor. Fitur dasar voting OSIS dan MPK sudah dapat digunakan.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateLog(String version, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFD), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE3EBF6))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(version, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.4)),
        ],
      ),
    );
  }
}
