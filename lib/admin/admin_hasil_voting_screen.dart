import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

class AdminHasilVotingScreen extends StatefulWidget {
  const AdminHasilVotingScreen({super.key});

  @override
  State<AdminHasilVotingScreen> createState() => _AdminHasilVotingScreenState();
}

class _AdminHasilVotingScreenState extends State<AdminHasilVotingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  HasilVotingModel? _pilketosResult;
  HasilVotingModel? _pilketumResult;
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
    _fetchResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchResults() async {
    setState(() { 
      _isLoading = true; 
      _error = null; 
    });
    
    try {
      final pilketos = await ApiService.getHasilVoting('pilketos');
      final pilketum = await ApiService.getHasilVoting('pilketum');
      
      setState(() {
        _pilketosResult = pilketos;
        _pilketumResult = pilketum;
        if (_pilketosResult == null && _pilketumResult == null) {
          _error = "Gagal mengambil data dari server";
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Terjadi kesalahan sistem";
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
        title: Text('Hasil Voting', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.primary,
            child: CommonWidgets.buildCategoryTabBar(controller: _tabController),
          ),
        ),
      ),
      body: _isLoading
          ? CommonWidgets.buildLoading()
          : _error != null
              ? CommonWidgets.buildError(message: _error!, onRetry: _fetchResults)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildResultContent(_pilketosResult),
                    _buildResultContent(_pilketumResult),
                  ],
                ),
    );
  }

  Widget _buildResultContent(HasilVotingModel? result) {
    if (result == null || result.kandidat.isEmpty) {
      return CommonWidgets.buildEmpty(message: 'Belum ada data hasil voting');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // ── 1. TOTAL SUARA & PARTISIPASI PEMILIH ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.how_to_vote, color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Suara Masuk', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                            const SizedBox(height: 2),
                            Text('${result.totalSuara}', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF059669), size: 14),
                          SizedBox(width: 4),
                          Text('Aktif', style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Partisipasi Pemilih', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                          Text(
                            '${result.totalPemilih > 0 ? ((result.totalSuara / result.totalPemilih) * 100).toStringAsFixed(0) : 0}%',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Sudah ${result.totalSuara} dari ${result.totalPemilih} pemilih', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600])),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: result.totalPemilih > 0 ? result.totalSuara / result.totalPemilih : 0.0,
                          minHeight: 10,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── 2. PEROLEHAN SUARA (GRAFIK BATANG) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Perolehan Suara', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                const SizedBox(height: 20),
                ...result.kandidat.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  Color itemColor = index < _chartColors.length ? _chartColors[index] : Colors.grey;
                  return _buildBarRow(item, result.totalSuara, itemColor);
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── 3. DETAIL PEROLEHAN (LEGEND) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Detail Perolehan', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                const SizedBox(height: 14),
                ...result.kandidat.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  Color itemColor = index < _chartColors.length ? _chartColors[index] : Colors.grey;
                  return _buildLegendRow(item, result.totalSuara, itemColor);
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── 4. TOMBOL RESET VOTING ──
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                String kategori = _tabController.index == 0 ? 'pilketos' : 'pilketum';
                _showResetDialog(kategori);
              },
              icon: const Icon(Icons.restart_alt, color: Colors.white),
              label: const Text('Reset Voting', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBarRow(VoteResultModel candidate, int totalSuara, Color itemColor) {
    double barPercent = totalSuara > 0 ? candidate.suara / totalSuara : 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(candidate.nama, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              Text('${candidate.suara}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: itemColor)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(height: 28, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: 28,
                      width: constraints.maxWidth * barPercent, 
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [itemColor, itemColor.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: barPercent > 0.15
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text('${(barPercent * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            )
                          : null,
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow(VoteResultModel candidate, int totalSuara, Color itemColor) {
    final percentage = totalSuara > 0 ? (candidate.suara / totalSuara * 100).toStringAsFixed(1) : '0.0';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: itemColor, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 10),
          Expanded(child: Text(candidate.nama, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700]))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: itemColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${candidate.suara} ($percentage%)', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: itemColor)),
          ),
        ],
      ),
    );
  }

  // ── DIALOG UNTUK RESET VOTING ──
  void _showResetDialog(String kategori) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Voting'),
        content: Text('Apakah Anda yakin ingin mereset voting $kategori? Seluruh data suara masuk pada kategori ini akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Batal')
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() { _isLoading = true; });
              
              final success = await ApiService.resetVoting(kategori);
              
              if (success && mounted) {
                CommonWidgets.showSnackBar(context, 'Voting $kategori berhasil direset!');
                _fetchResults();
              } else if (mounted) {
                setState(() { _isLoading = false; });
                CommonWidgets.showSnackBar(context, 'Gagal mereset voting', isError: true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.pink),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}