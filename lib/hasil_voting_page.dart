import 'package:flutter/material.dart';
import 'data_voting.dart'; // Import data voting global

// ═══════════════════════════════════════════
//  HALAMAN HASIL VOTING
// ═══════════════════════════════════════════
class HasilVotingPage extends StatefulWidget {
  const HasilVotingPage({super.key});

  @override
  State<HasilVotingPage> createState() => _HasilVotingPageState();
}

class _HasilVotingPageState extends State<HasilVotingPage> {
  String selectedTab = 'Ketos';

  // Mengambil data dari global, buan hardcode lokal lagi
  List<VotingResult> get currentData => selectedTab == 'Ketos' ? hasilKetos : hasilKetum;
  int get totalVotes => currentData.fold(0, (sum, c) => sum + c.votes);

  @override
  Widget build(BuildContext context) {
    final data = currentData;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF0245A3),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text('Hasil Voting', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _TabButton(label: 'Ketos', isSelected: selectedTab == 'Ketos', onTap: () => setState(() => selectedTab = 'Ketos')),
                        _TabButton(label: 'Ketum', isSelected: selectedTab == 'Ketum', onTap: () => setState(() => selectedTab = 'Ketum')),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(12)),
                                child: const Icon(Icons.how_to_vote, color: Color(0xFF0245A3), size: 24),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Suara $selectedTab', style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                                  const SizedBox(height: 2),
                                  Text('$totalVotes', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF0245A3))),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, color: Color(0xFF059669), size: 14),
                                SizedBox(width: 4),
                                Text('Aktif', style: TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Perolehan Suara', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                          const SizedBox(height: 20),
                          ...data.map((c) => _BarRow(candidate: c, maxVotes: data.map((d) => d.votes).reduce((a, b) => a > b ? a : b))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Detail Perolehan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.grey[800])),
                          const SizedBox(height: 14),
                          ...data.map((c) => _LegendRow(candidate: c, total: totalVotes)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Reset Voting'),
                              content: Text('Apakah Anda yakin ingin mereset voting $selectedTab?'),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      hasVotingData = false;
                                      if (selectedTab == 'Ketos') {
                                        for (var item in hasilKetos) { item.votes = 0; }
                                      } else {
                                        for (var item in hasilKetum) { item.votes = 0; }
                                      }
                                    });
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Voting $selectedTab berhasil direset!'), backgroundColor: const Color(0xFFEC4899)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC4899)),
                                  child: const Text('Reset', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.restart_alt, color: Colors.white),
                        label: const Text('Reset Voting', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEC4899),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// WIDGET INTERNAL
// ═══════════════════════════════════════════

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0245A3) : Colors.white70,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  final VotingResult candidate;
  final int maxVotes;

  const _BarRow({required this.candidate, required this.maxVotes});

  @override
  Widget build(BuildContext context) {
    final barPercent = maxVotes > 0 ? candidate.votes / maxVotes : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(candidate.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              Text('${candidate.votes}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: candidate.color)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(height: 28, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8))),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 28,
                  width: MediaQuery.of(context).size.width * barPercent * 0.55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [candidate.color, candidate.color.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: barPercent > 0.15
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('${(barPercent * 100).toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final VotingResult candidate;
  final int total;

  const _LegendRow({required this.candidate, required this.total});

  @override
  Widget build(BuildContext context) {
    final percentage = total > 0 ? (candidate.votes / total * 100).toStringAsFixed(1) : '0.0';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(width: 14, height: 14, decoration: BoxDecoration(color: candidate.color, borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 10),
          Expanded(child: Text(candidate.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey[700]))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: candidate.color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text('${candidate.votes} ($percentage%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: candidate.color)),
          ),
        ],
      ),
    );
  }
}