import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'profile_screen.dart';

class DataKandidatScreen extends StatefulWidget {
  const DataKandidatScreen({super.key});

  @override
  State<DataKandidatScreen> createState() => _DataKandidatScreenState();
}

class _DataKandidatScreenState extends State<DataKandidatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> _pilketosList = [];
  List<Map<String, dynamic>> _pilketumList = [];
  bool _isLoading = true;
  String? _error;

  final String _baseUrl = 'http://localhost:8080/latihanvotesmartk4_api';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchAllKandidat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllKandidat() async {
    try {
      // Fetch Pilketos
      final resPilketos = await http.get(
        Uri.parse('$_baseUrl/get_kandidat.php?kategori=pilketos'),
      );
      final dataPilketos = jsonDecode(resPilketos.body);
      if (dataPilketos['success']) {
        _pilketosList = List<Map<String, dynamic>>.from(dataPilketos['data']);
      }

      // Fetch Pilketum
      final resPilketum = await http.get(
        Uri.parse('$_baseUrl/get_kandidat.php?kategori=pilketum'),
      );
      final dataPilketum = jsonDecode(resPilketum.body);
      if (dataPilketum['success']) {
        _pilketumList = List<Map<String, dynamic>>.from(dataPilketum['data']);
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
          'Data Kandidat',
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
                labelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
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
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0245A3)),
            )
          : _error != null
              ? _buildError()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildKandidatList(_pilketosList, 'Pilketos'),
                    _buildKandidatList(_pilketumList, 'Pilketum'),
                  ],
                ),
    );
  }

  /// Widget error
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(_error!, style: GoogleFonts.inter(color: Colors.grey[600])),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchAllKandidat,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0245A3)),
            child: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Widget list kandidat per kategori
  Widget _buildKandidatList(List<Map<String, dynamic>> list, String kategori) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          'Belum ada data kandidat',
          style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final kandidat = list[index];
        return _buildKandidatCard(kandidat, kategori);
      },
    );
  }

  /// Widget kartu kandidat
  Widget _buildKandidatCard(Map<String, dynamic> kandidat, String kategori) {
    final profileTitle = kategori == 'Pilketos'
        ? 'Calon Ketua OSIS'
        : 'Calon Ketua MPK';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Nomor urut
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0245A3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${kandidat["id"]}', // atau bisa pakai index + 1
                style: GoogleFonts.inter(
                  color: const Color(0xFF0245A3),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Foto
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/kandidat1.png',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EBF6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 26,
                    color: const Color(0xFF0245A3).withOpacity(0.5),
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 14),

          // Info kandidat
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kandidat["nama"],
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A1A2E),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  profileTitle,
                  style: GoogleFonts.inter(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Tombol Lihat
          SizedBox(
            height: 36,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      title: 'Profile $profileTitle',
                      kandidatId: kandidat["id"],
                      nama: kandidat["nama"],
                      visi: kandidat["visi"],
                      misi: List<String>.from(kandidat["misi"]),
                      kategori: kategori.toLowerCase(),
                      user: null,    // ← null karena belum login
                      canVote: false, // ← FALSE = tanpa tombol voting
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0245A3),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Lihat',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}