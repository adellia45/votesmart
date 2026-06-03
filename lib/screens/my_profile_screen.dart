import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

class MyProfileScreen extends StatefulWidget {
  final UserModel user;
  const MyProfileScreen({super.key, required this.user});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  bool _isLoading = true;
  VoteStatusModel? _voteStatus;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final status = await ApiService.checkVoteStatus(widget.user.id);
    if (mounted) {
      setState(() {
        _voteStatus = status;
        _isLoading = false;
        if (status == null) _error = 'Gagal memuat data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonWidgets.buildAppBar(
        title: 'Profile Saya',
        context: context,
      ),
      body: _isLoading
          ? CommonWidgets.buildLoading()
          : _error != null
          ? CommonWidgets.buildError(message: _error!, onRetry: _fetchData)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Foto & Nama
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3EBF6),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.user.username,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'NIS: ${widget.user.nisNuptk ?? '-'}',
                        style: GoogleFonts.inter(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Status Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _voteStatus?.sudahSemua == true
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _voteStatus?.sudahSemua == true
                              ? Icons.check_circle
                              : Icons.hourglass_empty,
                          size: 16,
                          color: _voteStatus?.sudahSemua == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _voteStatus?.sudahSemua == true
                              ? 'Sudah Voting Semua'
                              : 'Belum Selesai Voting',
                          style: GoogleFonts.inter(
                            color: _voteStatus?.sudahSemua == true
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

                // Detail Status
                CommonWidgets.buildCard(
                  child: Column(
                    children: [
                      _buildStatusRow(
                        'Pilketos',
                        _voteStatus?.pilketos ?? false,
                        _voteStatus?.pilketosNama,
                      ),
                      const Divider(height: 24),
                      _buildStatusRow(
                        'Pilketum',
                        _voteStatus?.pilketum ?? false,
                        _voteStatus?.pilketumNama,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Keluar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await CommonWidgets.showConfirmDialog(
                        context: context,
                        title: 'Keluar',
                        message: 'Apakah kamu yakin ingin keluar?',
                        isDanger: true,
                        confirmText: 'Ya, Keluar',
                      );
                      if (confirm && mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                          (route) => false,
                        );
                      }
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildStatusRow(String label, bool sudah, String? namaKandidat) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.how_to_vote_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                sudah ? 'Memilih: ${namaKandidat ?? "-"}' : 'Belum memilih',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        Icon(
          sudah ? Icons.check_circle : Icons.cancel,
          color: sudah ? Colors.green : Colors.grey,
          size: 24,
        ),
      ],
    );
  }
}
