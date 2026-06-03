import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';

class HasilVotingScreen extends StatefulWidget {
  const HasilVotingScreen({super.key});

  @override
  State<HasilVotingScreen> createState() => _HasilVotingScreenState();
}

class _HasilVotingScreenState extends State<HasilVotingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HasilVotingModel? _pilketosResult;
  HasilVotingModel? _pilketumResult;
  String _statusPengumuman = 'hidden';
  bool _isLoading = true;
  String? _error;

  final List<Color> _chartColors = const [
    Color(0xFF0245A3), 
    Color(0xFFEF4444), 
    Color(0xFFF59E0B), 
    Color(0xFF10B981), 
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _muatDataUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _muatDataUser() async {
    setState(() { 
      _isLoading = true; 
      _error = null;
    });
    
    try {
      // 1. Cek status di database dulu lewat API
      final status = await ApiService.getStatusPengumuman();
      
      setState(() {
        _statusPengumuman = status;
      });

      // 2. Jika sudah diumumkan (visible), baru ambil data voting
      if (_statusPengumuman == 'visible') {
        final pilketos = await ApiService.getHasilVoting('pilketos');
        final pilketum = await ApiService.getHasilVoting('pilketum');
        setState(() {
          _pilketosResult = pilketos;
          _pilketumResult = pilketum;
        });
      }
      
      setState(() { _isLoading = false; });
    } catch (e) {
      setState(() {
        _error = "Gagal memuat hasil voting";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Hasil Pemilihan', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        bottom: _statusPengumuman == 'visible' 
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: AppColors.primary,
                  child: CommonWidgets.buildCategoryTabBar(controller: _tabController),
                ),
              )
            : null, // Sembunyikan tab jika hasil masih dikunci
      ),
      body: _isLoading 
          ? CommonWidgets.buildLoading()
          : _error != null
              ? CommonWidgets.buildError(message: _error!, onRetry: _muatDataUser)
              : _statusPengumuman == 'hidden'
                  ? _buildTampilanTerkunci() // 🔒 Tampilan Gembok
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTampilanGrafikHasil(_pilketosResult),
                        _buildTampilanGrafikHasil(_pilketumResult),
                      ],
                    ), // 📊 Tampilan Grafik Asli
    );
  }

  // WIDGET TAMPILAN JIKA VOTING BELUM DIUMUMKAN OLEH ADMIN
  Widget _buildTampilanTerkunci() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_clock_rounded, 
                size: 72,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hasil Voting Belum Diumumkan',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Proses pemungutan suara masih berlangsung atau sedang dalam tahap rekapitulasi oleh panitia. Silakan kembali lagi nanti setelah diumumkan oleh admin.',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTampilanGrafikHasil(HasilVotingModel? result) {
    if (result == null || result.kandidat.isEmpty) {
      return CommonWidgets.buildEmpty(message: 'Belum ada data hasil voting');
    }

    return RefreshIndicator(
      onRefresh: _muatDataUser,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card Info Ringkas Total Suara Masuk Untuk User
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.analytics_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Suara Sah Terhitung', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
                      Text('${result.totalSuara} Suara', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Utama Grafik Batang Berwarna Sisi User
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Grafik Presentase Perolehan', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                  const SizedBox(height: 20),
                  ...result.kandidat.asMap().entries.map((entry) {
                    int index = entry.key;
                    var item = entry.value;
                    Color itemColor = index < _chartColors.length ? _chartColors[index] : Colors.grey;
                    
                    double barPercent = result.totalSuara > 0 ? item.suara / result.totalSuara : 0.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.nama, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
                              Text('${(barPercent * 100).toStringAsFixed(1)}%', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: itemColor)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                Container(height: 24, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 800),
                                  height: 24,
                                  width: MediaQuery.of(context).size.width * 0.8 * barPercent,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [itemColor, itemColor.withOpacity(0.8)]),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}