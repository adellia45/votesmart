import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'admin_edit_biodata_screen.dart';// Buat Edit Biodata

class AdminDataCalonScreen extends StatefulWidget {
  const AdminDataCalonScreen({super.key});

  @override
  State<AdminDataCalonScreen> createState() => _AdminDataCalonScreenState();
}

class _AdminDataCalonScreenState extends State<AdminDataCalonScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KandidatModel> _pilketosList = [];
  List<KandidatModel> _pilketumList = [];
  bool _isLoading = true;

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
    setState(() => _isLoading = true);
    final pilketos = await ApiService.getKandidat('pilketos');
    final pilketum = await ApiService.getKandidat('pilketum');
    if (mounted) {
      setState(() {
        _pilketosList = pilketos;
        _pilketumList = pilketum;
        _isLoading = false;
      });
    }
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0245A3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Data Calon', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: const Color(0xFF0245A3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF0245A3).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
                  unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
                  padding: const EdgeInsets.all(4),
                  tabs: const [
                    Tab(text: 'Calon Ketua OSIS'),
                    Tab(text: 'Calon Ketua MPK'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
            floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final kategori = _tabController.index == 0 ? 'pilketos' : 'pilketum';
          // ✅ GANTI: Sekarang pakai AdminEditBiodataScreen (tanpa kandidat = mode tambah)
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminEditBiodataScreen(kategori: kategori)),
          );
          if (result == true) _fetchData();
        },
        backgroundColor: const Color(0xFF0245A3),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        icon: const Icon(Icons.person_add_rounded, color: Colors.white, size: 20),
        label: Text('Tambah Calon', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(_pilketosList),
          _buildList(_pilketumList),
        ],
      ),
    );
  }

  Widget _buildList(List<KandidatModel> list) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF0245A3)));
    }

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.how_to_vote_rounded, size: 48, color: Color(0xFF0245A3)),
              ),
              const SizedBox(height: 20),
              Text('Belum ada calon', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Tekan tombol "Tambah Calon"', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[400])),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFF0245A3),
      onRefresh: _fetchData,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: list.length,
        itemBuilder: (context, index) {
          // ✅ FIX: Dipindah ke Widget terpisah biar TabController-nya aman
          return ProfilCard(
            calon: list[index],
            noUrut: index + 1,
                onEdit: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ✅ FIX: Tambahkan kategori dan hapus spasi sebelum kurung
                      builder: (_) => AdminEditBiodataScreen(
                        kandidat: list[index],
                        kategori: list[index].kategori,
                      ),
                    ),
                  );
                  if (result == true) _fetchData();
                },
            onDelete: () => _deleteKandidat(list[index]),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// WIDGET TERPISAH UNTUK KARTU PROFIL (PUNYA TAB CONTROLLER SENDIRI)
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// WIDGET TERPISAH UNTUK KARTU PROFIL
// ═══════════════════════════════════════════════════════════════
class ProfilCard extends StatefulWidget {
  final KandidatModel calon;
  final int noUrut;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfilCard({
    super.key,
    required this.calon,
    required this.noUrut,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ProfilCard> createState() => _ProfilCardState();
}

class _ProfilCardState extends State<ProfilCard> with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          // ── HEADER: FOTO + NAMA + KELAS ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0245A3),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: widget.calon.foto != null && widget.calon.foto!.isNotEmpty
                      ? Image.network(widget.calon.foto!, width: 80, height: 100, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildAvatar())
                      : _buildAvatar(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.calon.nama, style: GoogleFonts.inter(fontWeight: FontWeight.w800, fontSize: 20, color: Colors.white)),
                      const SizedBox(height: 4),
                      if (widget.calon.kelas != null && widget.calon.kelas!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(widget.calon.kelas!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white)),
                        ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: widget.onEdit,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: widget.onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEF4444).withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

                   // ── INFO KONTAK (AMAN DARI OVERFLOW) ──
          if (widget.calon.alamat != null || widget.calon.noHp != null || widget.calon.email != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFFF8FAFC),
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 16,
                runSpacing: 8,
                children: [
                  if (widget.calon.alamat != null && widget.calon.alamat!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150),
                          child: Text(
                            widget.calon.alamat!,
                            style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  if (widget.calon.noHp != null && widget.calon.noHp!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.phone_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          widget.calon.noHp!,
                          style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF64748B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  if (widget.calon.email != null && widget.calon.email!.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.email_rounded, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 4),
                        Text(
                          widget.calon.email!,
                          style: GoogleFonts.inter(fontSize: 11, color: Color(0xFF64748B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
            ),

          // ── INNER TAB BAR ──
          Container(
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _innerTabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFF0245A3),
              unselectedLabelColor: const Color(0xFF94A3B8),
              labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 12),
              padding: const EdgeInsets.all(4),
              tabs: const [
                Tab(text: 'Biodata'),
                Tab(text: 'Pengalaman'),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // ── INNER TAB VIEW ──
          Container(
            height: 280,
            child: TabBarView(
              controller: _innerTabController,
              children: [
                _buildBiodataTab(),
                _buildPengalamanTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── TAB BIODATA ──
  Widget _buildBiodataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.calon.tentang != null && widget.calon.tentang!.isNotEmpty) ...[
            _buildSectionTitle(Icons.person_rounded, 'Tentang Kandidat', const Color(0xFF0245A3), const Color(0xFFDBEAFE)),
            const SizedBox(height: 8),
            _buildInfoBox(widget.calon.tentang!),
            const SizedBox(height: 16),
          ],

          _buildSectionTitle(Icons.school_rounded, 'Riwayat Pendidikan', const Color(0xFF7C3AED), const Color(0xFFEDE9FE)),
          const SizedBox(height: 8),
          _buildInfoRow('Sekolah', widget.calon.kelas ?? '-'),
          const SizedBox(height: 14),

          _buildSectionTitle(Icons.cake_rounded, 'Detail Pribadi', const Color(0xFF059669), const Color(0xFFD1FAE5)),
          const SizedBox(height: 8),
          _buildInfoRow('Tanggal Lahir', widget.calon.ttl ?? '-'),
          const SizedBox(height: 10),
          _buildInfoRow('Jenis Kelamin', widget.calon.jenisKelamin ?? '-'),
          const SizedBox(height: 16),

          if (widget.calon.keahlian != null && widget.calon.keahlian!.isNotEmpty) ...[
            _buildSectionTitle(Icons.star_rounded, 'Keahlian', const Color(0xFFD97706), const Color(0xFFFEF3C7)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.calon.keahlian!.split(',').map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(skill.trim(), style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF92400E))),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ── TAB PENGALAMAN ──
  Widget _buildPengalamanTab() {
    if (widget.calon.pengalaman.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_history_rounded, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text('Belum ada pengalaman', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.calon.pengalaman.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.work_rounded, size: 14, color: Color(0xFF0245A3)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.calon.pengalaman[index],
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF334155), height: 1.4),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── WIDGET HELPER ──
  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.calon.nama[0].toUpperCase(), style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 4),
          Text('${widget.noUrut}', style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, Color iconColor, Color bgColor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 14, color: iconColor),
        ),
        const SizedBox(width: 8),
        Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13, color: const Color(0xFF141B34))),
      ],
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF475569), height: 1.5)),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(value, style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF141B34), fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}