import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'kandidat_screen.dart';
import 'thankyou_screen.dart';
import 'my_profile_screen.dart';
import 'home_screen.dart';

class PilihVotingScreen extends StatefulWidget {
  final UserModel user;
  const PilihVotingScreen({super.key, required this.user});

  @override
  State<PilihVotingScreen> createState() => _PilihVotingScreenState();
}

class _PilihVotingScreenState extends State<PilihVotingScreen> {
  bool _sudahPilketos = false;
  bool _sudahPilketum = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cekStatusVote();
  }

  Future<void> _cekStatusVote() async {
    final status = await ApiService.checkVoteStatus(widget.user.id);
    if (status != null && mounted) {
      setState(() {
        _sudahPilketos = status.pilketos;
        _sudahPilketum = status.pilketum;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Halo, ${widget.user.username}',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Silakan pilih voting',
                        style: GoogleFonts.inter(color: Colors.white.withOpacity(0.7), fontSize: 15),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Pilih Voting:',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),

                      // Tombol Pilketos
                      _buildVotingButton(
                        label: 'Pilketos',
                        icon: Icons.how_to_vote_outlined,
                        sudahVote: _sudahPilketos,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
  builder: (context) => KandidatScreen(
    kategori: 'pilketos',
    user: widget.user,
  ),
),
                          );

                          if (result != null && result['voted'] == true) {
                            _cekStatusVote();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouScreen(
                                  kategoriLabel: 'Pilketos 2026',
                                  namaKandidat: result['nama'],
                                  user: widget.user,
                                ),
                              ),
                            );
                          } else {
                            _cekStatusVote();
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tombol Pilketum
                      _buildVotingButton(
                        label: 'Pilketum',
                        icon: Icons.groups_outlined,
                        sudahVote: _sudahPilketum,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
  builder: (context) => KandidatScreen(
    kategori: 'pilketum',
    user: widget.user,
  ),
),
                          );

                          if (result != null && result['voted'] == true) {
                            _cekStatusVote();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ThankYouScreen(
                                  kategoriLabel: 'Pilketum 2026',
                                  namaKandidat: result['nama'],
                                  user: widget.user,
                                ),
                              ),
                            );
                          } else {
                            _cekStatusVote();
                          }
                        },
                      ),
                      const Spacer(),

                      // Status info & Tombol Profile
                      Center(
                        child: Column(
                          children: [
                            if (_sudahPilketos || _sudahPilketum)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  _sudahPilketos && _sudahPilketum
                                      ? '✅ Kamu sudah selesai voting'
                                      : '✅ Kamu sudah memilih ${_sudahPilketos ? "Pilketos" : "Pilketum"}',
                                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12),
                                ),
                              ),
                            if (_sudahPilketos && _sudahPilketum) ...[
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfileScreen(user: widget.user)));
                                  },
                                  icon: const Icon(Icons.person_rounded, size: 20),
                                  label: Text('Lihat Profile Saya', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1.5),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Text('e-voting SMKN 4 Bogor 2026', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5), fontSize: 11, letterSpacing: 1)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildVotingButton({
    required String label,
    required IconData icon,
    required bool sudahVote,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: sudahVote ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: sudahVote ? Colors.white.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: sudahVote ? Colors.white.withOpacity(0.15) : Colors.white, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: sudahVote ? Colors.white.withOpacity(0.4) : AppColors.primary),
              const SizedBox(width: 16),
              Text(label, style: GoogleFonts.inter(color: sudahVote ? Colors.white.withOpacity(0.4) : AppColors.primary, fontSize: 18, fontWeight: sudahVote ? FontWeight.w400 : FontWeight.bold)),
              const Spacer(),
              if (sudahVote)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                      const SizedBox(width: 6),
                      Text('Sudah', style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                )
              else
                const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}