import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';       // <-- UBAH DARI ../../ JADI ../
import '../models/models.dart';           // <-- UBAH DARI ../../ JADI ../
import '../services/api_service.dart';    // <-- UBAH DARI ../../ JADI ../
import '../widgets/common_widgets.dart';  // <-- UBAH DARI ../../ JADI ../

class AdminDataPemilihScreen extends StatefulWidget {
  const AdminDataPemilihScreen({super.key});

  @override
  State<AdminDataPemilihScreen> createState() => _AdminDataPemilihScreenState();
}

class _AdminDataPemilihScreenState extends State<AdminDataPemilihScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PemilihModel> _pemilihList = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final list = await ApiService.getPemilih();

    setState(() {
      _pemilihList = list;
      _isLoading = false;
      if (list.isEmpty) _error = 'Gagal memuat data pemilih';
    });
  }

  List<PemilihModel> get _filteredList {
    if (_searchQuery.isEmpty) return _pemilihList;
    return _pemilihList.where((p) => p.username.toLowerCase().contains(_searchQuery)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets.buildAppBar(title: 'Data Pemilih', context: context),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Cari nama pemilih...',
                        hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List
          Expanded(
            child: _isLoading
                ? CommonWidgets.buildLoading()
                : _error != null
                    ? CommonWidgets.buildError(message: _error!, onRetry: _fetchData)
                    : _filteredList.isEmpty
                        ? CommonWidgets.buildEmpty(message: 'Pemilih tidak ditemukan')
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            itemCount: _filteredList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final pemilih = _filteredList[index];
                              return _buildPemilihCard(pemilih);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPemilihCard(PemilihModel pemilih) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipOval(
            child: Container(
              width: 48,
              height: 48,
              color: const Color(0xFFE0E7FF),
              child: Icon(Icons.person, color: AppColors.primary, size: 28),
            ),
          ),
          const SizedBox(width: 16),
          // Nama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pemilih.username, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
                if (pemilih.nisNuptk != null)
                  Text('NIS: ${pemilih.nisNuptk}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: pemilih.sudahVoting ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  pemilih.sudahVoting ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: pemilih.sudahVoting ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  pemilih.sudahVoting ? 'Sudah' : 'Belum',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: pemilih.sudahVoting ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}