import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'data_calon.dart'; // Import data global

// ═══════════════════════════════════════════
//  HALAMAN DATA CALON (LIST)
// ═══════════════════════════════════════════
class DataCalonPage extends StatefulWidget {
  const DataCalonPage({super.key});

  @override
  State<DataCalonPage> createState() => _DataCalonPageState();
}

class _DataCalonPageState extends State<DataCalonPage> {
  String selectedTab = 'Ketos';

  List<Calon> get currentData => selectedTab == 'Ketos' ? listKetos : listKetum;

  void _deleteCalon(int index) {
    final data = currentData;
    final name = data[index].nama;
    setState(() => data.removeAt(index));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$name berhasil dihapus!'), backgroundColor: const Color(0xFFDC2626)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = currentData;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FormCalonPage(tabData: data)));
        },
        backgroundColor: const Color(0xFF1E3A8A),
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: const Text('Tambah Calon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                      ),
                      const SizedBox(width: 14),
                      const Text('Data Calon', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
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
            Expanded(
              child: data.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.people_outline, size: 80, color: Colors.grey[300]), const SizedBox(height: 12), Text('Belum ada calon', style: TextStyle(fontSize: 16, color: Colors.grey[400], fontWeight: FontWeight.w600))]))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final calon = data[index];
                        return _CalonCard(
                          calon: calon,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => DetailCalonPage(calon: calon)));
                          },
                          onEdit: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => FormCalonPage(tabData: data, index: index, calon: calon)));
                          },
                          onDelete: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: Row(children: [Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20)), const SizedBox(width: 10), const Text('Hapus Calon?', style: TextStyle(fontSize: 18))]),
                                content: Text('Apakah Anda yakin ingin menghapus ${calon.nama}?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
                                  ElevatedButton(onPressed: () => _deleteCalon(index), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text('Hapus', style: TextStyle(color: Colors.white))),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  HALAMAN FORM TAMBAH/EDIT CALON
// ═══════════════════════════════════════════
class FormCalonPage extends StatefulWidget {
  final List<Calon> tabData;
  final int? index;
  final Calon? calon;

  const FormCalonPage({super.key, required this.tabData, this.index, this.calon});

  @override
  State<FormCalonPage> createState() => _FormCalonPageState();
}

class _FormCalonPageState extends State<FormCalonPage> {
  late TextEditingController nameCtrl;
  late TextEditingController kelasCtrl;
  late TextEditingController alamatCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController visiCtrl;
  late TextEditingController misiCtrl;
  late TextEditingController pengalamanCtrl;
  late TextEditingController fotoCtrl;

  final _colors = const [Color(0xFF3B82F6), Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFF10B981), Color(0xFF8B5CF6), Color(0xFFEC4899)];

  @override
  void initState() {
    super.initState();
    final c = widget.calon;
    nameCtrl = TextEditingController(text: c?.nama ?? '');
    kelasCtrl = TextEditingController(text: c?.kelas ?? '');
    alamatCtrl = TextEditingController(text: c?.alamat ?? '');
    emailCtrl = TextEditingController(text: c?.email ?? '');
    visiCtrl = TextEditingController(text: c?.visi ?? '');
    misiCtrl = TextEditingController(text: c?.misi ?? '');
    pengalamanCtrl = TextEditingController(text: c?.pengalaman ?? '');
    fotoCtrl = TextEditingController(text: c?.fotoUrl ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose(); kelasCtrl.dispose(); alamatCtrl.dispose();
    emailCtrl.dispose(); visiCtrl.dispose(); misiCtrl.dispose(); pengalamanCtrl.dispose(); fotoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.index != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: Text(isEditing ? 'Edit Calon' : 'Tambah Calon', style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Masukkan URL Foto'),
                      content: TextField(controller: fotoCtrl, decoration: const InputDecoration(hintText: 'https://...')),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        ElevatedButton(onPressed: () { setState(() {}); Navigator.pop(ctx); }, child: const Text('OK')),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 130, height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                  child: fotoCtrl.text.isNotEmpty
                      ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.network(fotoCtrl.text, fit: BoxFit.cover))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey[400]),
                            const SizedBox(height: 8),
                            Text('Upload Foto', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600)),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(label: 'Nama Lengkap', controller: nameCtrl, icon: Icons.person_outline),
            const SizedBox(height: 14),
            _buildTextField(label: 'Kelas', controller: kelasCtrl, icon: Icons.school_outlined),
            const SizedBox(height: 14),
            _buildTextField(label: 'Alamat', controller: alamatCtrl, icon: Icons.location_on_outlined),
            const SizedBox(height: 14),
            _buildTextField(label: 'Email', controller: emailCtrl, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _buildTextField(label: 'Visi', controller: visiCtrl, icon: Icons.lightbulb_outline, maxLines: 3),
            const SizedBox(height: 14),
            _buildTextField(label: 'Misi', controller: misiCtrl, icon: Icons.assignment_outlined, maxLines: 3),
            const SizedBox(height: 14),
            _buildTextField(label: 'Pengalaman', controller: pengalamanCtrl, icon: Icons.history_edu_outlined, maxLines: 3),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isEmpty || kelasCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama dan Kelas wajib diisi!'), backgroundColor: Colors.red));
                    return;
                  }
                  if (isEditing) {
                    setState(() {
                      widget.calon!.nama = nameCtrl.text;
                      widget.calon!.kelas = kelasCtrl.text;
                      widget.calon!.alamat = alamatCtrl.text;
                      widget.calon!.email = emailCtrl.text;
                      widget.calon!.visi = visiCtrl.text;
                      widget.calon!.misi = misiCtrl.text;
                      widget.calon!.pengalaman = pengalamanCtrl.text;
                      widget.calon!.fotoUrl = fotoCtrl.text;
                    });
                  } else {
                    widget.tabData.add(Calon(
                      nama: nameCtrl.text,
                      kelas: kelasCtrl.text,
                      alamat: alamatCtrl.text,
                      email: emailCtrl.text,
                      visi: visiCtrl.text,
                      misi: misiCtrl.text,
                      pengalaman: pengalamanCtrl.text,
                      fotoUrl: fotoCtrl.text,
                      avatarColor: _colors[Random().nextInt(_colors.length)],
                    ));
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Berhasil diupdate!' : 'Berhasil ditambahkan!'), backgroundColor: const Color(0xFF059669)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E3A8A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: Text(isEditing ? 'Simpan Perubahan' : 'Selesai', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required TextEditingController controller, required IconData icon, int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        const SizedBox(height: 8),
        TextField(
          controller: controller, maxLines: maxLines, keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════
//  HALAMAN DETAIL PROFIL CALON
// ═══════════════════════════════════════════
class DetailCalonPage extends StatelessWidget {
  final Calon calon;
  const DetailCalonPage({super.key, required this.calon});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 24, left: 20, right: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                      image: calon.fotoPath != null 
                          ? DecorationImage(image: FileImage(File(calon.fotoPath!)), fit: BoxFit.cover)
                          : (calon.fotoUrl.isNotEmpty ? DecorationImage(image: NetworkImage(calon.fotoUrl), fit: BoxFit.cover) : null),
                    ),
                    child: (calon.fotoPath == null && calon.fotoUrl.isEmpty) ? const Icon(Icons.person, size: 50, color: Colors.white70) : null,
                  ),
                  const SizedBox(height: 14),
                  Text(calon.nama, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(calon.kelas, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(color: const Color(0xFF1E3A8A), borderRadius: BorderRadius.circular(10)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey[600],
                tabs: const [Tab(text: 'Biodata'), Tab(text: 'Pengalaman')],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildInfoTab(children: [
                    _InfoTile(icon: Icons.person_outline, title: 'Nama', value: calon.nama),
                    _InfoTile(icon: Icons.school_outlined, title: 'Kelas', value: calon.kelas),
                    _InfoTile(icon: Icons.location_on_outlined, title: 'Alamat', value: calon.alamat),
                    _InfoTile(icon: Icons.email_outlined, title: 'Email', value: calon.email),
                  ]),
                  _buildInfoTab(children: [
                    _InfoTile(icon: Icons.lightbulb_outline, title: 'Visi', value: calon.visi),
                    _InfoTile(icon: Icons.assignment_outlined, title: 'Misi', value: calon.misi),
                    _InfoTile(icon: Icons.history_edu_outlined, title: 'Pengalaman', value: calon.pengalaman),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: SingleChildScrollView(child: Column(children: children)),
    );
  }

  Widget _InfoTile({required IconData icon, required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(value.isNotEmpty ? value : '-', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  WIDGET INTERNAL (LIST & TAB)
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
          decoration: BoxDecoration(color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(10)),
          child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? const Color(0xFF1E3A8A) : Colors.white70, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
        ),
      ),
    );
  }
}

class _CalonCard extends StatelessWidget {
  final Calon calon;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CalonCard({required this.calon, required this.onTap, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: calon.avatarColor.withOpacity(0.15),
                image: calon.fotoPath != null 
                    ? DecorationImage(image: FileImage(File(calon.fotoPath!)), fit: BoxFit.cover)
                    : (calon.fotoUrl.isNotEmpty ? DecorationImage(image: NetworkImage(calon.fotoUrl), fit: BoxFit.cover) : null),
              ),
              child: (calon.fotoPath == null && calon.fotoUrl.isEmpty) ? Center(child: Text(calon.nama.substring(0, 1), style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: calon.avatarColor))) : null,
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(calon.nama, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E293B))), const SizedBox(height: 4), Text(calon.kelas, style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500))])),
            Row(
              children: [
                Container(decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(10)), child: IconButton(onPressed: onEdit, icon: const Icon(Icons.edit, color: Color(0xFF2563EB), size: 20), constraints: const BoxConstraints(minWidth: 40, minHeight: 40), padding: EdgeInsets.zero)),
                const SizedBox(width: 8),
                Container(decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)), child: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 20), constraints: const BoxConstraints(minWidth: 40, minHeight: 40), padding: EdgeInsets.zero)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}