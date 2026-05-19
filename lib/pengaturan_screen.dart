import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// PERHATIKAN NAMA CLASS INI BERUBAH JADI PengaturanScreen
class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

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
          'Tentang Aplikasi',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_smk4.png',
                    width: 80, height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: const Color(0xFFE3EBF6), shape: BoxShape.circle),
                        child: const Icon(Icons.school, size: 40, color: Color(0xFF0245A3)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('VoteSmartK4', style: GoogleFonts.inter(color: const Color(0xFF0245A3), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  Text('e-Voting SMKN 4 Bogor', style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 14)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFE3EBF6), borderRadius: BorderRadius.circular(20)),
                    child: Text('Versi 1.0.0', style: GoogleFonts.inter(color: const Color(0xFF0245A3), fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.groups_rounded, color: const Color(0xFF0245A3).withOpacity(0.7), size: 20),
                      const SizedBox(width: 10),
                      Text('Tim Penyumbang', style: GoogleFonts.inter(color: const Color(0xFF0245A3), fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 24, color: Color(0xFFE3EBF6)),
                  _buildTeamMember(name: 'Adellia Indra', role: 'Flutter Developer', email: 'adellia.smk4@sch.id', github: 'github.com/adelliaindra'),
                  _buildTeamMember(name: 'Nama Anggota 2', role: 'UI/UX Designer', email: 'anggota2.smk4@sch.id', github: 'github.com/anggota2'),
                  _buildTeamMember(name: 'Nama Anggota 3', role: 'Backend Developer', email: 'anggota3.smk4@sch.id', github: 'github.com/anggota3'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('© 2026 SMK Negeri 4 Bogor\nSemua hak dilindungi.', textAlign: TextAlign.center, style: GoogleFonts.inter(color: Colors.grey[400], fontSize: 12, height: 1.5)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({required String name, required String role, required String email, required String github}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EBF6), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: const Color(0xFF0245A3).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.person_rounded, size: 26, color: Color(0xFF0245A3)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.inter(color: const Color(0xFF1A1A2E), fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFF0245A3).withOpacity(0.08), borderRadius: BorderRadius.circular(6)),
                  child: Text(role, style: GoogleFonts.inter(color: const Color(0xFF0245A3), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
                Row(children: [Icon(Icons.email_outlined, size: 14, color: Colors.grey[500]), const SizedBox(width: 6), Expanded(child: Text(email, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 12), overflow: TextOverflow.ellipsis))]),
                const SizedBox(height: 6),
                Row(children: [Icon(Icons.code, size: 14, color: Colors.grey[500]), const SizedBox(width: 6), Expanded(child: Text(github, style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 12), overflow: TextOverflow.ellipsis))]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}