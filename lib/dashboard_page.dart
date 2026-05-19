import 'package:flutter/material.dart';
import 'login_page.dart';
import 'kelola_calon_page.dart';
import 'hasil_voting_page.dart';
import 'data_pemilih_page.dart';
import 'reset_voting_page.dart';
import 'data_calon_page.dart';
import 'data_voting.dart'; // Import data voting

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.shield_rounded, color: Colors.white, size: 28),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Admin Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const AdminLoginPage()),
                          );
                        },
                        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text(
                  'Selamat Datang Admin!',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF141B34),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildMenuItem(context, Icons.manage_accounts_outlined, 'Kelola Calon', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const KelolaCalonPage()));
                      }),
                      _buildMenuItem(context, Icons.how_to_reg_outlined, 'Data Pemilih', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DataPemilihPage()));
                      }),
                      _buildMenuItem(context, Icons.poll_outlined, 'Hasil Voting', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const HasilVotingPage()));
                      }),
                      _buildMenuItem(context, Icons.assignment_ind_outlined, 'Data Calon', () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const DataCalonPage()));
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => _showAnnounceDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0245A3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Umumkan Voting',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ResetVotingPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEC4899),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Reset Voting',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAnnounceDialog(BuildContext context) {
    // ── CEK DULU DATA VOTINGNYA MASIH ADA ATAU UDAH DI-RESET ──
    if (!hasVotingData) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 60),
                  const SizedBox(height: 16),
                  const Text(
                    'Gagal Mengumumkan!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF141B34)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Data hasil voting kosong. Silakan lakukan voting terlebih dahulu sebelum mengumumkan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0245A3),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
      return; // Berhenti disini, jangan lanjut ke bawah
    }

    // ── JIKA DATA MASIH ADA, TAMPILKAN DIALOG KONFIRMASI BIASA ──
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.campaign_rounded, color: Color(0xFF0245A3), size: 60),
                const SizedBox(height: 16),
                const Text(
                  'Umumkan Hasil Voting?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xFF141B34)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin ingin mengumumkannya? Ini akan Mempublikasikan Hasil Voting!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
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
                          onPressed: () {
                            Navigator.pop(context);
                            _showSuccessDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0245A3),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Ya', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
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
                const Text(
                  'Hasil voting telah berhasil dipublikasikan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0245A3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Kembali', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0245A3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: const Color(0xFF0245A3)),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF141B34),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}