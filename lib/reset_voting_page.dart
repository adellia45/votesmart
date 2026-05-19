import 'package:flutter/material.dart';
import 'data_voting.dart'; // Import data voting

class ResetVotingPage extends StatefulWidget {
  const ResetVotingPage({super.key});

  @override
  State<ResetVotingPage> createState() => _ResetVotingPageState();
}

class _ResetVotingPageState extends State<ResetVotingPage> {
  bool _isSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0245A3),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reset voting',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isSuccess) ...[
                const Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Semua data hasil voting akan dihapus!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF141B34)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Apakah Anda yakin ingin mereset semua data?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0245A3),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // ── LOGIKA RESET DATA ──
                              hasVotingData = false; // Tandai data sudah kosong
                              for (var item in hasilKetos) { item.votes = 0; }
                              for (var item in hasilKetum) { item.votes = 0; }
                              
                              _isSuccess = true; // Tampilan jadi sukses
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEC4899),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                )
              ],

              if (_isSuccess) ...[
                const Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Semua data berhasil dihapus!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFF141B34)),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0245A3),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Kembali ke halaman', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.white)),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}