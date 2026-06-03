import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'admin_data_calon_screen.dart';
import 'admin_kelola_calon_screen.dart';
import 'admin_data_pemilih_screen.dart';
import 'admin_hasil_voting_screen.dart';
import 'admin_reset_voting_screen.dart';
import '../../screens/home_screen.dart';
import '../../services/api_service.dart'; // <- Ditambahkan untuk koneksi ke database

class AdminDashboardPage extends StatefulWidget { // <- Diubah ke StatefulWidget
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  // State untuk menampung status dari database
  String _statusPengumuman = 'hidden';
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    // Cek status ke database saat halaman pertama kali dibuka
    _cekStatusPengumuman();
  }

  Future<void> _cekStatusPengumuman() async {
    final status = await ApiService.getStatusPengumuman();
    if (mounted) {
      setState(() {
        _statusPengumuman = status;
        _isLoadingStatus = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ══════════════════════════════════════
              // HEADER BIRU
              // ══════════════════════════════════════
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 30, bottom: 40, left: 24, right: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFF0245A3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 30),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Admin Dashboard',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 24),
                    ),
                  ],
                ),
              ),

              // ══════════════════════════════════════
              // SELAMAT DATANG
              // ══════════════════════════════════════
              Transform.translate(
                offset: const Offset(0, -20),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: const Text(
                    'Selamat Datang, Admin!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF141B34)),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ══════════════════════════════════════
              // MENU VERTIKAL
              // ══════════════════════════════════════
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildMenuButton(
                      icon: Icons.how_to_vote_rounded,
                      title: 'Data Calon',
                      subtitle: 'Lihat daftar calon kandidat',
                      iconBgColor: const Color(0xFFDBEAFE),
                      iconColor: const Color(0xFF0245A3),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDataCalonScreen()));
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildMenuButton(
                      icon: Icons.people_rounded,
                      title: 'Kelola Calon',
                      subtitle: 'Tambah, edit, hapus data calon',
                      iconBgColor: const Color(0xFFFEF3C7),
                      iconColor: const Color(0xFFD97706),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminKelolaCalonScreen()));
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildMenuButton(
                      icon: Icons.person_search_rounded,
                      title: 'Data Pemilih',
                      subtitle: 'Lihat data pemilih terdaftar',
                      iconBgColor: const Color(0xFFEDE9FE),
                      iconColor: const Color(0xFF7C3AED),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDataPemilihScreen()));
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildMenuButton(
                      icon: Icons.bar_chart_rounded,
                      title: 'Hasil Voting',
                      subtitle: 'Lihat perolehan suara',
                      iconBgColor: const Color(0xFFD1FAE5),
                      iconColor: const Color(0xFF059669),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminHasilVotingScreen()));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ══════════════════════════════════════
              // TOMBOL UMUMKAN / SEMBUNYIKAN (DINAMIS)
              // ══════════════════════════════════════
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    // Disable tombol sementara saat mengecek status awal
                    onPressed: _isLoadingStatus ? null : () => _showAnnounceDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _statusPengumuman == 'hidden' ? const Color(0xFF0245A3) : Colors.blueGrey,
                      disabledBackgroundColor: Colors.grey,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: _isLoadingStatus 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Icon(
                            _statusPengumuman == 'hidden' ? Icons.campaign_rounded : Icons.visibility_off_rounded,
                            color: Colors.white, 
                            size: 20
                          ),
                    label: Text(
                      _isLoadingStatus 
                          ? 'Memuat status...' 
                          : (_statusPengumuman == 'hidden' ? 'Umumkan Hasil Voting' : 'Sembunyikan Hasil Dari User'),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ══════════════════════════════════════
              // TOMBOL RESET VOTING (PINK)
              // ══════════════════════════════════════
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                color: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminResetVotingScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC4899),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.restart_alt, color: Colors.white, size: 20),
                    label: const Text(
                      'Reset Voting',
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconBgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15, color: const Color(0xFF141B34)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12, color: const Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  // DIALOG KONFIRMASI (UDAH ADA API NYA)
  // ══════════════════════════════════════
  void _showAnnounceDialog(BuildContext context) {
    bool isHidden = _statusPengumuman == 'hidden';
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isHidden ? Icons.campaign_rounded : Icons.visibility_off_rounded, 
                color: isHidden ? const Color(0xFF0245A3) : Colors.blueGrey, 
                size: 60
              ),
              const SizedBox(height: 16),
              Text(
                isHidden ? 'Umumkan Hasil Voting?' : 'Sembunyikan Hasil Voting?',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF141B34)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isHidden 
                    ? 'Admin ingin mengumumkannya? Ini akan Mempublikasikan Hasil Voting!' 
                    : 'Admin ingin menyembunyikannya? User tidak bisa melihat hasil voting lagi.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC4899),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context); // Tutup dialog konfirmasi
                          
                          // 💡 KIRIM PERINTAH KE DATABASE
                          String statusBaru = isHidden ? 'visible' : 'hidden';
                          bool sukses = await ApiService.updateStatusPengumuman(statusBaru);
                          
                          if (sukses && mounted) {
                            setState(() {
                              _statusPengumuman = statusBaru; // Update tampilan tombol langsung
                            });
                            _showSuccessDialog(context, isHidden: isHidden);
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Gagal mengubah status pengumuman'), backgroundColor: Colors.red),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isHidden ? const Color(0xFF0245A3) : Colors.blueGrey,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(isHidden ? 'Ya, Umumkan' : 'Ya, Sembunyikan', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, {required bool isHidden}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 60),
              const SizedBox(height: 16),
              const Text(
                'Berhasil!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF141B34)),
              ),
              const SizedBox(height: 8),
              Text(
                isHidden 
                    ? 'Hasil voting telah berhasil dipublikasikan.' 
                    : 'Hasil voting telah berhasil disembunyikan.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0245A3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}