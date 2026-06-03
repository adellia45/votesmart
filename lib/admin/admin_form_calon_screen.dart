import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';

class AdminFormCalonScreen extends StatefulWidget {
  final String kategori;
  final KandidatModel? kandidat;

  const AdminFormCalonScreen({
    super.key,
    required this.kategori,
    this.kandidat,
  });

  @override
  State<AdminFormCalonScreen> createState() => _AdminFormCalonScreenState();
}

class _AdminFormCalonScreenState extends State<AdminFormCalonScreen> {
  final _namaController = TextEditingController();
  final _visiController = TextEditingController();
  final _misiController = TextEditingController();
  final _fotoUrlController = TextEditingController();
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.kandidat != null;
    if (_isEditing) {
      _namaController.text = widget.kandidat!.nama;
      _visiController.text = widget.kandidat!.visi;
      _misiController.text = widget.kandidat!.misi.join('\n');
      _fotoUrlController.text = widget.kandidat!.foto ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _visiController.dispose();
    _misiController.dispose();
    _fotoUrlController.dispose();
    super.dispose();
  }

    Future<void> _save() async {
    if (_namaController.text.isEmpty || _visiController.text.isEmpty) {
      CommonWidgets.showSnackBar(context, 'Nama dan Visi wajib diisi!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final misiList = _misiController.text
        .split('\n')
        .where((m) => m.trim().isNotEmpty)
        .toList();

    bool success;
    if (_isEditing) {
      success = await ApiService.updateKandidat(widget.kandidat!.id, {
        'nama': _namaController.text,
        'visi': _visiController.text,
        'kategori': widget.kategori,
        'foto': _fotoUrlController.text,
      });
    } else {
      success = await ApiService.tambahKandidat({
        'nama': _namaController.text,
        'visi': _visiController.text,
        'kategori': widget.kategori,
        'foto': _fotoUrlController.text,
        'misi': misiList.join(','), // Misi kita kirim sebagai teks satu baris dulu
      });
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      CommonWidgets.showSnackBar(context, _isEditing ? 'Calon berhasil diupdate!' : 'Calon berhasil ditambahkan!');
      Navigator.pop(context, true);
    } else if (mounted) {
      CommonWidgets.showSnackBar(context, 'Gagal menyimpan data', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CommonWidgets.buildAppBar(
        title: _isEditing ? 'Edit Calon' : 'Tambah Calon',
        context: context,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto Preview
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: Text('URL Foto', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                      content: TextField(
                        controller: _fotoUrlController,
                        decoration: const InputDecoration(hintText: 'https://...'),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(ctx);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
                  ),
                  child: _fotoUrlController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(_fotoUrlController.text, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPhotoPlaceholder()),
                        )
                      : _buildPhotoPlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nama
            _buildTextField(label: 'Nama Lengkap', controller: _namaController, icon: Icons.person_outline),
            const SizedBox(height: 14),

            // Visi
            _buildTextField(label: 'Visi', controller: _visiController, icon: Icons.lightbulb_outline, maxLines: 3),
            const SizedBox(height: 14),

            // Misi (satu misi per baris)
            _buildTextField(
              label: 'Misi (satu misi per baris)',
              controller: _misiController,
              icon: Icons.assignment_outlined,
              maxLines: 5,
              hintText: 'Misi 1\nMisi 2\nMisi 3',
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                ),
                child: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isEditing ? 'Simpan Perubahan' : 'Selesai', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 40, color: Colors.grey[400]),
        const SizedBox(height: 8),
        Text('Upload Foto', style: GoogleFonts.inter(color: Colors.grey[500], fontWeight: FontWeight.w600)),
      ],
    );
  }
}