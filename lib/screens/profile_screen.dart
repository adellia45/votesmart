import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'home_screen.dart'; // Sesuaikan import HomeScreen mu

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  VoteStatusModel? _voteStatus;
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _fetchVoteStatus();
  }

  Future<void> _fetchVoteStatus() async {
    final status = await ApiService.checkVoteStatus(widget.user.id);
    if (mounted) {
      setState(() {
        _voteStatus = status;
        _isLoadingStatus = false;
      });
    }
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
        title: Text('Profile Saya', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ═══ HEADER BIRU (FOTO + NAMA + NIS) ═══
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30, bottom: 50, left: 24, right: 24),
              decoration: const BoxDecoration(
                color: Color(0xFF0245A3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 60),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.user.username, 
                    style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NIS: ${widget.user.nisNuptk ?? '-'}',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            // ═══ KARTU STATUS & PILIHAN ═══
            Transform.translate(
              offset: const Offset(0, -25),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // Status Voting
                    if (!_isLoadingStatus && _voteStatus != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _voteStatus!.sudahSemua ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _voteStatus!.sudahSemua ? Icons.check_circle_rounded : Icons.info_outline_rounded, 
                              color: _voteStatus!.sudahSemua ? const Color(0xFF16A34A) : const Color(0xFFD97706), 
                              size: 20
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _voteStatus!.sudahSemua ? 'Sudah Voting Semua' : 'Belum Voting Semua',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700, 
                                fontSize: 14, 
                                color: _voteStatus!.sudahSemua ? const Color(0xFF166534) : const Color(0xFF92400E),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Title Pilihan
                    Text('Pilihan Saya', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color:  Color(0xFF141B34))),
                    const SizedBox(height: 16),

                    // Kartu Pilketos
                    _buildChoiceCard(
                      title: 'Pilketos',
                      status: _isLoadingStatus ? null : (_voteStatus?.pilketos ?? false),
                      nama: _voteStatus?.pilketosNama,
                      foto: _voteStatus?.pilketosFoto,
                      colorAccent: const Color(0xFF0245A3),
                      colorBg: const Color(0xFFDBEAFE),
                    ),
                    
                    const SizedBox(height: 16),

                    // Kartu Pilketum
                    _buildChoiceCard(
                      title: 'Pilketum',
                      status: _isLoadingStatus ? null : (_voteStatus?.pilketum ?? false),
                      nama: _voteStatus?.pilketumNama,
                      foto: _voteStatus?.pilketumFoto,
                      colorAccent: const Color(0xFF7C3AED),
                      colorBg: const Color(0xFFEDE9FE),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ═══ TOMBOL KELUAR ═══
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFDC2626)),
                  label: const Text('Keluar', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDC2626), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── WIDGET KARTU PILIHAN CALON ──
  Widget _buildChoiceCard({
    required String title,
    required bool? status,
    String? nama,
    String? foto,
    required Color colorAccent,
    required Color colorBg,
  }) {
    bool isLoading = status == null;
    bool sudahMemilih = status == true;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: sudahMemilih ? const Color(0xFFDCFCE7) : const Color(0xFFE5E7EB), 
          width: 2,
        ),
      ),
      child: Row(
        children: [
          // Foto / Icon
          if (sudahMemilih && foto != null && foto!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                foto!, width: 60, height: 75, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildDefaultIcon(colorAccent, colorBg),
              ),
            )
          else
            _buildDefaultIcon(colorAccent, colorBg),

          const SizedBox(width: 16),

          // Info Calon
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xFF64748B))),
                const SizedBox(height: 6),
                if (isLoading)
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF9CA3AF)),
                  )
                else if (sudahMemilih && nama != null)
                  Text(
                    nama, 
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: const Color(0xFF141B34)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text('Belum memilih', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400], fontStyle: FontStyle.italic)),
              ],
            ),
          ),

          // Status Icon
          if (!isLoading)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sudahMemilih ? const Color(0xFFDCFCE7) : const Color(0xFFF3F4F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                sudahMemilih ? Icons.check_rounded : Icons.remove_rounded,
                color: sudahMemilih ? const Color(0xFF16A34A) : Colors.grey[400],
                size: 24,
              ),
            ),
        ],
      ),
    );
  }

  // ── DEFAULT ICON (KALAU GA ADA FOTO) ──
  Widget _buildDefaultIcon(Color colorAccent, Color colorBg) {
    return Container(
      width: 60,
      height: 75,
      decoration: BoxDecoration(
        color: colorBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.how_to_vote_rounded, color: colorAccent, size: 28),
    );
  }
}