import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import '../widgets/common_widgets.dart';
import 'detail_kandidat_screen.dart';

class DataKandidatScreen extends StatefulWidget {
  const DataKandidatScreen({super.key});

  @override
  State<DataKandidatScreen> createState() => _DataKandidatScreenState();
}

class _DataKandidatScreenState extends State<DataKandidatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KandidatModel> _pilketosList = [];
  List<KandidatModel> _pilketumList = [];
  bool _isLoading = true;
  String? _error;

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
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final pilketos = await ApiService.getKandidat('pilketos');
    final pilketum = await ApiService.getKandidat('pilketum');

    setState(() {
      _pilketosList = pilketos;
      _pilketumList = pilketum;
      _isLoading = false;
      if (pilketos.isEmpty && pilketum.isEmpty) {
        _error = 'Gagal memuat data kandidat';
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
        title: Text('Data Kandidat', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
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
              ? CommonWidgets.buildError(message: _error!, onRetry: _fetchAllKandidat)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildKandidatList(_pilketosList, 'Pilketos'),
                    _buildKandidatList(_pilketumList, 'Pilketum'),
                  ],
                ),
    );
  }

  Widget _buildKandidatList(List<KandidatModel> list, String kategori) {
    if (list.isEmpty) {
      return CommonWidgets.buildEmpty(message: 'Belum ada data kandidat $kategori');
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

  Widget _buildKandidatCard(KandidatModel kandidat, String kategori) {
    final profileTitle = kategori == 'Pilketos' ? 'Calon Ketua OSIS' : 'Calon Ketua MPK';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Nomor urut
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.inter(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Foto
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: kandidat.foto != null && kandidat.foto!.isNotEmpty
                ? Image.network(
                    kandidat.foto!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
                  )
                : _buildAvatarPlaceholder(),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kandidat.nama, style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(profileTitle, style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 12)),
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
  builder: (context) => DetailKandidatScreen(
    title: 'Profile $profileTitle',
    kandidat: kandidat,
    canVote: false,
  ),
),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Lihat', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  int get index => 0;

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EBF6),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(Icons.person, size: 26, color: AppColors.primary.withOpacity(0.5)),
    );
  }
}