import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'profile_screen.dart';
import 'package:votesmartk4/models/user_model.dart';

class KandidatScreen extends StatefulWidget {
  final String title;
  final String kategori;
  final UserModel user; // ← TAMBAHKAN INI

  const KandidatScreen({
    super.key,
    required this.title,
    required this.kategori,
    required this.user, // ← TAMBAHKAN INI
  });

  @override
  State<KandidatScreen> createState() => _KandidatScreenState();
}

class _KandidatScreenState extends State<KandidatScreen> {
  List<Map<String, dynamic>> _kandidatList = [];
  bool _isLoading = true;
  String? _error;
  final String _baseUrl = 'http://localhost:8080/latihanvotesmartk4_api';

  @override
  void initState() {
    super.initState();
    _fetchKandidat();
  }

  Future<void> _fetchKandidat() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/get_kandidat.php?kategori=${widget.kategori}'),
      );
      final data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          _kandidatList = List<Map<String, dynamic>>.from(data['data']);
        });
      } else {
        setState(() {
          _error = data['message'] ?? 'Gagal memuat data';
        });
      }
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
          widget.title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
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
                        onPressed: _fetchKandidat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0245A3),
                        ),
                        child: Text('Coba Lagi', style: GoogleFonts.inter(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _kandidatList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final kandidat = _kandidatList[index];
                    return _buildKandidatCard(context, kandidat);
                  },
                ),
    );
  }

  Widget _buildKandidatCard(BuildContext context, Map<String, dynamic> kandidat) {
    final profileTitle = widget.kategori == 'pilketos'
        ? 'Profile Calon Ketos'
        : 'Profile Calon Ketum';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              'assets/images/kandidat1.png', // fallback
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3EBF6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: const Color(0xFF0245A3).withOpacity(0.5),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              kandidat["nama"],
              style: GoogleFonts.inter(
                color: const Color(0xFF1A1A2E),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 38,
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      title: profileTitle,
                      kandidatId: kandidat["id"],
                      nama: kandidat["nama"],
                      visi: kandidat["visi"],
                      misi: List<String>.from(kandidat["misi"]),
                      kategori: widget.kategori,
                      user: widget.user, // ← TAMBAHKAN INI
                    ),
                  ),
                );

                // Kalau user sudah voting, pop kandidat screen juga
                if (result != null && result['voted'] == true) {
                  if (!mounted) return;
                  Navigator.pop(context, result);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0245A3),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Lihat Profile',
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