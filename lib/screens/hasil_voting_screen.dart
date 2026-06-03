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
  bool _isLoading = true;
  String? _error;

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

    final pilketos = await ApiService.getHasilVoting('pilketos');
    final pilketum = await ApiService.getHasilVoting('pilketum');

    setState(() {
      _pilketosResult = pilketos;
      _pilketumResult = pilketum;
      _isLoading = false;
      if (pilketos == null && pilketum == null) {
        _error = 'Gagal memuat hasil voting';
      }
    });
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
          // Total Suara Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF0355C4)]),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.how_to_vote_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Suara Masuk', style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('${result.totalSuara}', style: GoogleFonts.inter(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rank Cards
          ...result.kandidat.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            int maxSuara = result.kandidat.first.suara > 0 ? result.kandidat.first.suara : 1;
            double percentage = item.suara / maxSuara;
            double persenDisplay = result.totalSuara > 0 ? (item.suara / result.totalSuara) * 100 : 0;

            return _buildRankCard(
              rank: index + 1,
              nama: item.nama,
              suara: item.suara,
              persenDisplay: persenDisplay,
              percentage: percentage,
              isTop: index == 0 && item.suara > 0,
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildRankCard({
    required int rank,
    required String nama,
    required int suara,
    required double persenDisplay,
    required double percentage,
    required bool isTop,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isTop ? Border.all(color: AppColors.primary, width: 2) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isTop ? 0.08 : 0.04), blurRadius: isTop ? 12 : 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isTop ? AppColors.primary : const Color(0xFFE3EBF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('$rank', style: GoogleFonts.inter(color: isTop ? Colors.white : AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(nama, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15, fontWeight: isTop ? FontWeight.bold : FontWeight.w600)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('$suara suara', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                  Text('${persenDisplay.toStringAsFixed(1)}%', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 10,
              child: Stack(
                children: [
                  Container(decoration: BoxDecoration(color: const Color(0xFFE3EBF6), borderRadius: BorderRadius.circular(6))),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: isTop ? AppColors.primary : AppColors.primary.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}