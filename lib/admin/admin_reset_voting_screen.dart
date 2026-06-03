import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

class AdminResetVotingScreen extends StatefulWidget {
  const AdminResetVotingScreen({super.key});

  @override
  State<AdminResetVotingScreen> createState() => _AdminResetVotingScreenState();
}

class _AdminResetVotingScreenState extends State<AdminResetVotingScreen> {
  bool _isSuccess = false;
  bool _isLoading = false;
  String _successMessage = ''; // ← Variabel baru untuk menampung pesan dinamis

  Future<void> _resetVoting(String kategori) async {
    setState(() => _isLoading = true);

    final success = await ApiService.resetVoting(kategori);

    setState(() => _isLoading = false);

    if (success && mounted) {
      setState(() {
        _isSuccess = true;
        // Menentukan pesan sukses berdasarkan kategori yang dipilih
        if (kategori == 'all') {
          _successMessage = 'Semua data hasil voting berhasil dihapus!';
        } else if (kategori == 'pilketos') {
          _successMessage = 'Data hasil voting Pilketos berhasil dihapus!';
        } else if (kategori == 'pilketum') {
          _successMessage = 'Data hasil voting Pilketum berhasil dihapus!';
        }
      });
    } else if (mounted) {
      CommonWidgets.showSnackBar(context, 'Gagal mereset voting', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membaca text theme dasar untuk optimasi GoogleFonts
    final TextStyle baseStyle = GoogleFonts.inter();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.buildAppBar(title: 'Reset Voting', context: context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: _isLoading
              ? CommonWidgets.buildLoading()
              : SingleChildScrollView( // Mencegah overflow pada device berlayar kecil
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_isSuccess) ...[
                        const Icon(Icons.error_outline, color: AppColors.error, size: 80),
                        const SizedBox(height: 24),
                        Text(
                          'Data hasil voting yang dipilih akan dihapus permanen!',
                          textAlign: TextAlign.center,
                          style: baseStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Apakah Anda yakin ingin mereset data?',
                          textAlign: TextAlign.center,
                          style: baseStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: Text('Batal', style: baseStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => _resetVoting('all'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.pink,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: Text('Reset Semua', style: baseStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => _resetVoting('pilketos'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.pink),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('Reset Pilketos Saja', style: baseStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.pink)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => _resetVoting('pilketum'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.pink),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('Reset Pilketum Saja', style: baseStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.pink)),
                          ),
                        ),
                      ],

                      if (_isSuccess) ...[
                        const Icon(Icons.check_circle, color: AppColors.success, size: 80),
                        const SizedBox(height: 24),
                        Text(
                          _successMessage, // ← Menampilkan pesan dinamis di sini
                          textAlign: TextAlign.center,
                          style: baseStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text('Kembali ke Dashboard', style: baseStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}