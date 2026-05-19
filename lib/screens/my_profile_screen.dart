import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:votesmartk4/models/user_model.dart';
import 'home_screen.dart';

class MyProfileScreen extends StatefulWidget {
  final UserModel user;
  const MyProfileScreen({super.key, required this.user});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String? _error;

  final String _baseUrl = 'http://localhost:8080/latihanvotesmartk4_api';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_profile.php?user_id=${widget.user.id}'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          _profileData = data['data'];
        });
      } else {
        setState(() {
          _error = data['message'] ?? 'Gagal memuat profile';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Gagal terhubung ke server';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Format tanggal MySQL ke bahasa Indonesia
  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    final date = DateTime.parse(dateStr);
    const bulan = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${bulan[date.month]} ${date.year}';
  }

  String _getKategoriLabel(String kategori) {
    return kategori == 'pilketos' ? 'Pilketos' : 'Pilketum';
  }

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
          'Profile Saya',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0245A3)))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(_error!, style: GoogleFonts.inter(color: Colors.grey[600])),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchProfile,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0245A3)),
                        child: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // ── Foto & Nama ──
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/images/logo_smk4.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3EBF6),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: const Color(0xFF0245A3).withOpacity(0.5),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _profileData?['username'] ?? widget.user.username,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1A1A2E),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'NIS: ${_profileData?['nis_nuptk'] ?? '-'}',
                            style: GoogleFonts.inter(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Status Badge ──
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: _profileData?['sudah_voting'] == true
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _profileData?['sudah_voting'] == true
                                  ? Icons.check_circle
                                  : Icons.hourglass_empty,
                              size: 16,
                              color: _profileData?['sudah_voting'] == true
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _profileData?['sudah_voting'] == true
                                  ? 'Sudah Voting'
                                  : 'Belum Voting',
                              style: GoogleFonts.inter(
                                color: _profileData?['sudah_voting'] == true
                                    ? Colors.green
                                    : Colors.orange,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Statistik ──
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'Total Voting',
                            value: '${_profileData?['total_votes'] ?? 0}',
                            icon: Icons.how_to_vote_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            label: 'Terakhir Voting',
                            value: _formatDate(_profileData?['last_vote_date']),
                            icon: Icons.calendar_today_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Riwayat Voting ──
                    Text(
                      'Riwayat Voting',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1A1A2E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (_profileData?['votes'] == null || (_profileData?['votes'] as List).isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Belum ada riwayat voting',
                            style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      )
                    else
                      ...(_profileData?['votes'] as List).map((vote) {
                        return _buildVoteCard(vote);
                      }),

                    const SizedBox(height: 32),

                    // ── Tombol Keluar ──
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: Text('Keluar', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                              content: Text('Apakah kamu yakin ingin keluar?', style: GoogleFonts.inter()),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Batal', style: GoogleFonts.inter(color: Colors.grey)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context); // tutup dialog
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                                      (route) => route.isFirst,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text('Ya, Keluar', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: Text(
                          'Keluar',
                          style: GoogleFonts.inter(
                            color: Colors.red,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF0245A3), size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: const Color(0xFF1A1A2E),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.grey[500],
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVoteCard(Map<String, dynamic> vote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0245A3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.how_to_vote_rounded,
              color: Color(0xFF0245A3),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getKategoriLabel(vote['kategori']),
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0245A3),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vote['kandidat_nama'] ?? '-',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.green, size: 22),
        ],
      ),
    );
  }
}