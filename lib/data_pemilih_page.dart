import 'package:flutter/material.dart';

class DataPemilihPage extends StatefulWidget {
  const DataPemilihPage({super.key});

  @override
  State<DataPemilihPage> createState() => _DataPemilihPageState();
}

class _DataPemilihPageState extends State<DataPemilihPage> {
  final TextEditingController _searchController = TextEditingController();

  // Data dummy lebih banyak (20 orang)
  final List<Map<String, dynamic>> _allVoters = [
    {'nama': 'Jacob Jones', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/11.jpg'},
    {'nama': 'Robert Fox', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/men/12.jpg'},
    {'nama': 'Annette Black', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/women/11.jpg'},
    {'nama': 'Cameron Williamson', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/13.jpg'},
    {'nama': 'Eleanor Pena', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/12.jpg'},
    {'nama': 'Albert Flores', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/14.jpg'},
    {'nama': 'Jane Cooper', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/13.jpg'},
    {'nama': 'Kristin Watson', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/women/14.jpg'},
    {'nama': 'Ralph Edwards', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/15.jpg'},
    {'nama': 'Darlene Robertson', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/15.jpg'},
    {'nama': 'Marvin McKinney', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/16.jpg'},
    {'nama': 'Bessie Cooper', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/16.jpg'},
    {'nama': 'Arlene McCoy', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/women/17.jpg'},
    {'nama': 'Jerome Bell', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/18.jpg'},
    {'nama': 'Savannah Nguyen', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/18.jpg'},
    {'nama': 'Theresa Webb', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/women/19.jpg'},
    {'nama': 'Kathryn Murphy', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/women/20.jpg'},
    {'nama': 'Ronald Richards', 'sudahVote': false, 'foto': 'https://randomuser.me/api/portraits/men/20.jpg'},
    {'nama': 'Floyd Miles', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/21.jpg'},
    {'nama': 'Cody Fisher', 'sudahVote': true, 'foto': 'https://randomuser.me/api/portraits/men/22.jpg'},
  ];

  List<Map<String, dynamic>> _filteredVoters = [];

  @override
  void initState() {
    super.initState();
    _filteredVoters = _allVoters; // Awalnya tampilkan semua
    _searchController.addListener(_filterVoters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fungsi untuk memfilter list berdasarkan pencarian
  void _filterVoters() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVoters = _allVoters.where((voter) {
        return voter['nama'].toString().toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5CFF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Data Pemilih',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search Bar ──
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
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF141B34),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Cari nama pemilih...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── List Pemilih ──
          Expanded(
            child: _filteredVoters.isEmpty
                ? const Center(
                    child: Text(
                      'Pemilih tidak ditemukan',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    itemCount: _filteredVoters.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final pemilih = _filteredVoters[index];
                      bool sudahVote = pemilih['sudahVote'];

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                           // ── Avatar ──
ClipOval(
  child: Container(
    width: 48, // Ukuran diameter (sama dengan radius 24 * 2)
    height: 48,
    color: const Color(0xFFE0E7FF),
    child: Image.network(
      pemilih['foto'],
      fit: BoxFit.cover,
      // Loading builder: Munculin spinner saat foto masih loading
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: const Color(0xFF2E5CFF),
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      // Error builder: Munculin ikon orang jika foto gagal diload
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return const Icon(Icons.person, color: Color(0xFF2E5CFF), size: 28);
      },
    ),
  ),
),
                            const SizedBox(width: 16),
                            
                            // ── Nama ──
                            Expanded(
                              child: Text(
                                pemilih['nama'],
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF141B34),
                                ),
                              ),
                            ),

                            // ── Status Vote ──
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: sudahVote 
                                    ? const Color(0xFFDCFCE7) // Hijau muda
                                    : const Color(0xFFFEE2E2), // Merah muda
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    sudahVote 
                                        ? Icons.check_circle_rounded 
                                        : Icons.cancel_rounded,
                                    color: sudahVote 
                                        ? const Color(0xFF16A34A) // Hijau
                                        : const Color(0xFFEF4444), // Merah
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    sudahVote ? 'Sudah Voting' : 'Belum Voting',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: sudahVote 
                                          ? const Color(0xFF16A34A) 
                                          : const Color(0xFFEF4444),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}