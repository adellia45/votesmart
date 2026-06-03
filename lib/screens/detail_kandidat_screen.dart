import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';

class DetailKandidatScreen extends StatelessWidget {
  final String title;
  final KandidatModel kandidat;
  final bool canVote;
  final VoidCallback? onVotePressed;

  const DetailKandidatScreen({
    super.key,
    required this.title,
    required this.kandidat,
    required this.canVote,
    this.onVotePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0245A3),
        foregroundColor: Colors.white,
        title: Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bagian Foto dan Nama Utama
            _buildHeaderProfile(),
            const SizedBox(height: 24),

            // 2. KONDISI SAKTI: Memisahkan Tampilan Berdasarkan Nilai 'canVote'
            canVote 
                ? _buildKontenVisiMisi() // Tampil jika user masuk dari menu VOTING
                : _buildKontenBiodata(),  // Tampil jika user masuk dari menu CALON KANDIDAT
                
            const SizedBox(height: 40),

            // 3. Tombol Vote (Hanya muncul jika canVote bernilai true)
            if (canVote && onVotePressed != null)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: onVotePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), // Warna hijau sukses
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Gunakan Hak Pilih (Vote)', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderProfile() {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: kandidat.foto != null && kandidat.foto!.isNotEmpty
                ? Image.network(kandidat.foto!, width: 120, height: 150, fit: BoxFit.cover)
                : Container(
                    width: 120, height: 150, 
                    color: const Color(0xFF0245A3), 
                    child: const Icon(Icons.person, size: 50, color: Colors.white),
                  ),
          ),
          const SizedBox(height: 16),
          Text(
            kandidat.nama,
            style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF141B34)),
          ),
          if (kandidat.kelas != null) ...[
            const SizedBox(height: 4),
            Text('Kelas: ${kandidat.kelas}', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600])),
          ],
        ],
      ),
    );
  }

  // TAMPILAN KHUSUS MENU VOTING (VISI & MISI)
  Widget _buildKontenVisiMisi() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Visi',
          icon: Icons.lightbulb_rounded,
          child: Text(
            kandidat.visi.isNotEmpty ? kandidat.visi : 'Visi belum diisi.',
            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF4B5563), height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Misi',
          icon: Icons.assignment_rounded,
          child: kandidat.misi.isEmpty
              ? Text('Misi belum diisi.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: kandidat.misi.map((misiItem) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0245A3))),
                          Expanded(
                            child: Text(misiItem, style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF4B5563), height: 1.5)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  // TAMPILAN KHUSUS MENU CALON KANDIDAT (BIODATA & PENGALAMAN)
  Widget _buildKontenBiodata() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Biodata Diri',
          icon: Icons.badge_rounded,
          child: Column(
            children: [
              _buildBioRow('Jenis Kelamin', kandidat.jenisKelamin),
              _buildBioRow('TTL', kandidat.ttl),
              _buildBioRow('No. HP', kandidat.noHp),
              _buildBioRow('Email', kandidat.email),
              _buildBioRow('Alamat', kandidat.alamat),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Pengalaman',
          icon: Icons.history_edu_rounded,
          child: kandidat.pengalaman.isEmpty
              ? Text('Belum ada riwayat pengalaman.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: kandidat.pengalaman.map((exp) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('- $exp', style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF4B5563))),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF0245A3)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF141B34))),
            ],
          ),
          const Divider(height: 24, thickness: 1),
          child,
        ],
      ),
    );
  }

  Widget _buildBioRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 110, child: Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]))),
          Text(':  ', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          Expanded(child: Text(value ?? '-', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: const Color(0xFF141B34)))),
        ],
      ),
    );
  }
}