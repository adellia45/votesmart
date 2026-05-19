import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HasilVotingScreen extends StatefulWidget {
  const HasilVotingScreen({super.key});

  @override
  State<HasilVotingScreen> createState() => _HasilVotingScreenState();
}

class _HasilVotingScreenState extends State<HasilVotingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _pilketosList = [];
  int _totalPilketos = 0;

  List<Map<String, dynamic>> _pilketumList = [];
  int _totalPilketum = 0;

  bool _isLoading = true;
  String? _error;

  final String _baseUrl = 'http://localhost:8080/latihanvotesmartk4_api';

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
    try {
      final res1 = await http.get(
        Uri.parse('$_baseUrl/get_results.php?kategori=pilketos'),
      );
      final data1 = jsonDecode(res1.body);
      if (data1['success']) {
        _pilketosList = List<Map<String, dynamic>>.from(data1['data']['kandidat']);
        _totalPilketos = data1['data']['total_suara'];
      }

      final res2 = await http.get(
        Uri.parse('$_baseUrl/get_results.php?kategori=pilketum'),
      );
      final data2 = jsonDecode(res2.body);
      if (data2['success']) {
        _pilketumList = List<Map<String, dynamic>>.from(data2['data']['kandidat']);
        _totalPilketum = data2['data']['total_suara'];
      }

      setState(() {});
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
          'Hasil Voting',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF0245A3),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: const Color(0xFF0245A3),
                unselectedLabelColor: Colors.white.withOpacity(0.7),
                tabs: const [
                  Tab(text: 'Pilketos'),
                  Tab(text: 'Pilketum'),
                ],
              ),
            ),
          ),
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
                        onPressed: _fetchResults,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0245A3)),
                        child: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildResultContent(_pilketosList, _totalPilketos),
                    _buildResultContent(_pilketumList, _totalPilketum),
                  ],
                ),
    );
  }

  Widget _buildResultContent(List<Map<String, dynamic>> list, int totalSuara) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data',
          style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
        ),
      );
    }

    int maxSuara = list[0]['suara'] > 0 ? list[0]['suara'] : 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0245A3), Color(0xFF0355C4)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0245A3).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
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
                    Text(
                      'Total Suara Masuk',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalSuara',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          ...list.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;
            int suara = item['suara'] ?? 0;
            double percentage = maxSuara > 0 ? (suara / maxSuara) : 0;

            return _buildRankCard(
              rank: index + 1,
              nama: item['nama'],
              suara: suara,
              totalSuara: totalSuara,
              percentage: percentage,
              isTop: index == 0 && suara > 0,
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
    required int totalSuara,
    required double percentage,
    required bool isTop,
  }) {
    double persenDisplay = totalSuara > 0 ? (suara / totalSuara) * 100 : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isTop
            ? Border.all(color: const Color(0xFF0245A3), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isTop ? 0.08 : 0.04),
            blurRadius: isTop ? 12 : 6,
            offset: const Offset(0, 3),
          ),
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
                  color: isTop
                      ? const Color(0xFF0245A3)
                      : const Color(0xFFE3EBF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: GoogleFonts.inter(
                      color: isTop ? Colors.white : const Color(0xFF0245A3),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  nama,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E),
                    fontSize: 15,
                    fontWeight: isTop ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$suara suara',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1A1A2E),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${persenDisplay.toStringAsFixed(1)}%',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
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
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3EBF6),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: percentage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      decoration: BoxDecoration(
                        color: isTop
                            ? const Color(0xFF0245A3)
                            : const Color(0xFF0245A3).withOpacity(0.5),
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