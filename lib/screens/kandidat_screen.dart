import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/app_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';
import 'detail_kandidat_screen.dart';

class KandidatScreen extends StatefulWidget {
  final String kategori;
  final UserModel user;

  const KandidatScreen({super.key, required this.kategori, required this.user});

  @override
  State<KandidatScreen> createState() => _KandidatScreenState();
}

class _KandidatScreenState extends State<KandidatScreen> {
  List<KandidatModel> _kandidatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final list = await ApiService.getKandidat(widget.kategori);
    if (mounted) {
      setState(() {
        _kandidatList = list;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.kategori == 'pilketos' ? 'Pemilihan Ketua OSIS' : 'Pemilihan Ketua MPK';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0245A3),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(title, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0245A3)))
          : _kandidatList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(50)),
                          child: const Icon(Icons.how_to_vote_rounded, size: 48, color: Color(0xFF0245A3)),
                        ),
                        const SizedBox(height: 20),
                        Text('Belum ada calon', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  itemCount: _kandidatList.length,
                  itemBuilder: (context, index) {
                    return _buildCalonCard(_kandidatList[index], index + 1);
                  },
                ),
    );
  }

  Widget _buildCalonCard(KandidatModel calon, int noUrut) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailKandidatScreen(
                  title: 'Profile Calon ${widget.kategori == 'pilketos' ? 'Ketos' : 'Ketum'}',
                  kandidat: calon,
                  canVote: true,
                                  onVotePressed: () async {
                  // 1. Panggil API Voting
                  bool success = await ApiService.submitVote(
                    widget.user.id,
                    calon.id,
                    widget.kategori,
                  );

                  if (success && mounted) {
                    // 2. Pop dari halaman Detail Calon
                    Navigator.pop(context);
                    
                    // 3. Pop dari halaman Daftar Calon (Balik ke menu Pilih Voting)
                    Navigator.pop(context);

                    // Opsional: Tampilkan snackbar berhasil
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Berhasil memilih calon!'),
                        backgroundColor: Color(0xFF059669),
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal melakukan voting'),
                        backgroundColor: Color(0xFFEF4444),
                      ),
                    );
                  }
                },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: calon.foto != null && calon.foto!.isNotEmpty
                      ? Image.network(calon.foto!, width: 68, height: 85, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildDefaultAvatar(calon, noUrut))
                      : _buildDefaultAvatar(calon, noUrut),
                ),
                const SizedBox(width: 14),
                Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // No. Urut + Nama
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0245A3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'No. $noUrut',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: const Color(0xFF0245A3),
              ),
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              calon.nama,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: const Color(0xFF141B34),
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 8),

      // Visi Singkat
      Text(
        calon.visi,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: const Color(0xFF6B7280),
          height: 1.4,
        ),
      ),

      const SizedBox(height: 10),

      // Badge Misi
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.format_list_bulleted_rounded,
              size: 12,
              color: Color(0xFF16A34A),
            ),
            const SizedBox(width: 5),
            Text(
              '${calon.misi.length} Misi',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 11,
                color: const Color(0xFF16A34A),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(KandidatModel calon, int noUrut) {
    return Container(
      width: 68,
      height: 85,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0245A3), Color(0xFF0369D1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(calon.nama.isNotEmpty ? calon.nama[0].toUpperCase() : '?', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text('$noUrut', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}