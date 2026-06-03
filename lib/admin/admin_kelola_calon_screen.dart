import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'admin_form_calon_screen.dart';

class AdminKelolaCalonScreen extends StatefulWidget {
  const AdminKelolaCalonScreen({super.key});

  @override
  State<AdminKelolaCalonScreen> createState() => _AdminKelolaCalonScreenState();
}

class _AdminKelolaCalonScreenState extends State<AdminKelolaCalonScreen>
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
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
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
    });
  }

  Future<void> _deleteKandidat(KandidatModel kandidat) async {
    final confirm = await CommonWidgets.showConfirmDialog(
      context: context,
      title: 'Hapus Calon?',
      message: 'Apakah Anda yakin ingin menghapus ${kandidat.nama}?',
      isDanger: true,
      confirmText: 'Hapus',
    );

    if (!confirm) return;

    // Hapus misi terlebih dahulu (jika ada endpoint terpisah)
    // Kemudian hapus kandidat
    final success = await ApiService.hapusKandidat(kandidat.id);

    if (success && mounted) {
      CommonWidgets.showSnackBar(context, '${kandidat.nama} berhasil dihapus!');
      _fetchData();
    } else if (mounted) {
      CommonWidgets.showSnackBar(context, 'Gagal menghapus calon', isError: true);
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
        title: Text('Kelola Calon', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final kategori = _tabController.index == 0 ? 'pilketos' : 'pilketum';
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminFormCalonScreen(kategori: kategori)),
          );
          if (result == true) {
            _fetchData();
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text('Tambah Calon', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _isLoading
          ? CommonWidgets.buildLoading()
          : _error != null
              ? CommonWidgets.buildError(message: _error!, onRetry: _fetchData)
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildList(_pilketosList, 'pilketos'),
                    _buildList(_pilketumList, 'pilketum'),
                  ],
                ),
    );
  }

  Widget _buildList(List<KandidatModel> list, String kategori) {
    if (list.isEmpty) {
      return CommonWidgets.buildEmpty(message: 'Belum ada calon $kategori');
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final kandidat = list[index];
        return _buildCard(kandidat);
      },
    );
  }

  Widget _buildCard(KandidatModel kandidat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: kandidat.foto != null && kandidat.foto!.isNotEmpty
                ? Image.network(kandidat.foto!, width: 52, height: 52, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildAvatar(kandidat))
                : _buildAvatar(kandidat),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(kandidat.nama, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(kandidat.visi, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Actions
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminFormCalonScreen(kategori: kandidat.kategori, kandidat: kandidat)),
                    );
                    if (result == true) {
                      _fetchData();
                    }
                  },
                  icon: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 20),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () => _deleteKandidat(kandidat),
                  icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20),
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(KandidatModel kandidat) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), shape: BoxShape.circle),
      child: Center(child: Text(kandidat.nama[0], style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary))),
    );
  }
}