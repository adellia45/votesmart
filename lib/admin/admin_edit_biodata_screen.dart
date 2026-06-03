import 'dart:typed_data'; // Ditambahkan untuk menampung bytes foto di Web
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart'; // Menggunakan file_picker
import '../../config/app_config.dart';
import '../../models/models.dart';
import '../../services/api_service.dart';
import '../../widgets/common_widgets.dart';
import 'package:file_picker/file_picker.dart';

class AdminEditBiodataScreen extends StatefulWidget {
  final KandidatModel? kandidat; // Diubah jadi opsional (null = Mode Tambah)
  final String kategori;

  const AdminEditBiodataScreen({
    super.key,
    this.kandidat,
    required this.kategori,
  });

  @override
  State<AdminEditBiodataScreen> createState() => _AdminEditBiodataScreenState();
}

class _AdminEditBiodataScreenState extends State<AdminEditBiodataScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _namaC;
  late TextEditingController _visiC;
  late TextEditingController _misiC;
  late TextEditingController _kelasC;
  late TextEditingController _alamatC;
  late TextEditingController _noHpC;
  late TextEditingController _emailC;
  late TextEditingController _ttlC;
  late TextEditingController _tentangC;
  late TextEditingController _keahlianC;
  late TextEditingController _fotoC; // Masih dipertahankan untuk link lama
  late TextEditingController _pengalamanC;
  
  String? _jenisKelamin;
  bool _isLoading = false;

  // Variabel baru untuk menampung file lokal yang dipilih
  PlatformFile? _selectedImageFile;
  Uint8List? _webImageBytes;
  
  // Untuk ngecek ini mode Tambah atau Edit
  bool get _isEditMode => widget.kandidat != null;

  @override
  void initState() {
    super.initState();
    final c = widget.kandidat;
    
    _namaC = TextEditingController(text: c?.nama ?? '');
    _visiC = TextEditingController(text: c?.visi ?? '');
    _misiC = TextEditingController(text: c?.misi.join('\n') ?? '');
    _kelasC = TextEditingController(text: c?.kelas ?? '');
    _alamatC = TextEditingController(text: c?.alamat ?? '');
    _noHpC = TextEditingController(text: c?.noHp ?? '');
    _emailC = TextEditingController(text: c?.email ?? '');
    _ttlC = TextEditingController(text: c?.ttl ?? '');
    _tentangC = TextEditingController(text: c?.tentang ?? '');
    _keahlianC = TextEditingController(text: c?.keahlian ?? '');
    _fotoC = TextEditingController(text: c?.foto ?? '');
    _pengalamanC = TextEditingController(text: c?.pengalaman.join('\n') ?? '');
    _jenisKelamin = c?.jenisKelamin;
  }

  @override
  void dispose() {
    _namaC.dispose();
    _visiC.dispose();
    _misiC.dispose();
    _kelasC.dispose();
    _alamatC.dispose();
    _noHpC.dispose();
    _emailC.dispose();
    _ttlC.dispose();
    _tentangC.dispose();
    _keahlianC.dispose();
    _fotoC.dispose();
    _pengalamanC.dispose();
    super.dispose();
  }

  // Fungsi baru untuk memilih file dari komputer/HP
Future<void> _pickImage() async {
    // Coba ganti .instance menjadi .platform
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        _selectedImageFile = result.files.first;
        _webImageBytes = result.files.first.bytes;
      });
    }
  }

Future<void> _save() async {
    // 1. Validasi Nama wajib diisi. Visi hanya wajib jika sedang membuat kandidat baru (Mode Tambah)
    if (_namaC.text.trim().isEmpty) {
      CommonWidgets.showSnackBar(context, 'Nama Lengkap wajib diisi!', isError: true);
      return;
    }
    
    if (!_isEditMode && _visiC.text.trim().isEmpty) {
      CommonWidgets.showSnackBar(context, 'Visi wajib diisi untuk calon baru!', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Membersihkan space kosong di tiap baris
    final misiList = _misiC.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    final pengalamanList = _pengalamanC.text.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    // 2. Mengubah tipe Map menjadi dynamic agar flexibel menerima object file/base64 nantinya
    final Map<String, dynamic> bodyData = {
      'nama': _namaC.text.trim(),
      'kelas': _kelasC.text.trim(),
      'alamat': _alamatC.text.trim(),
      'no_hp': _noHpC.text.trim(),
      'email': _emailC.text.trim(),
      'ttl': _ttlC.text.trim(),
      'jenis_kelamin': _jenisKelamin ?? '',
      'tentang': _tentangC.text.trim(),
      'keahlian': _keahlianC.text.trim(),
      // Gunakan pemisah '|' agar tidak bentrok jika user mengetik tanda koma di textfield
      'pengalaman': pengalamanList.join('|'), 
    };

// === GANTI BLOK PENGIRIMAN API DI FUNGSI _save() MENJADI SEPERTI INI ===
    bool success;

    if (_isEditMode) {
      bodyData['kategori'] = widget.kandidat!.kategori;
      bodyData['visi'] = _visiC.text.trim(); 
      bodyData['misi'] = misiList.join('|');

      if (_selectedImageFile == null) {
        bodyData['foto'] = _fotoC.text;
      }

      // ✅ FIX: Langsung kirim bodyData (Map<String, dynamic>) tanpa convert paksa
      success = await ApiService.updateKandidat(
        widget.kandidat!.id,
        bodyData, // 👈 Kirim langsung map aslinya ke ApiService
        imageFile: _selectedImageFile, 
      );
    } else {
      bodyData['kategori'] = widget.kategori;
      bodyData['visi'] = _visiC.text.trim();
      bodyData['misi'] = misiList.join('|');
      
      if (_selectedImageFile == null) {
        bodyData['foto'] = _fotoC.text;
      }

      // ✅ FIX: Langsung kirim bodyData untuk mode tambah
      success = await ApiService.tambahKandidat(
        bodyData, // 👈 Kirim langsung map aslinya ke ApiService
        imageFile: _selectedImageFile,
      );
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      CommonWidgets.showSnackBar(context, _isEditMode ? 'Biodata berhasil diupdate!' : 'Calon berhasil ditambahkan!');
      Navigator.pop(context, true); // Mengembalikan nilai true agar halaman daftar merefresh data
    } else if (mounted) {
      CommonWidgets.showSnackBar(context, 'Gagal menyimpan data. Periksa koneksi atau log server.', isError: true);
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
        title: Text(_isEditMode ? 'Edit Biodata' : 'Tambah Calon', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── FOTO (Sudah diubah langsung klik pilih file) ──
              Center(
                child: GestureDetector(
                  onTap: _pickImage, // Ganti dialog link dengan fungsi pilih file
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: _webImageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.memory(
                              _webImageBytes!, // Prioritaskan tampilin file lokal baru yang dipilih
                              fit: BoxFit.cover,
                            ),
                          )
                        : _fotoC.text.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  _fotoC.text, // Tampilkan foto lama dari internet
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildPhotoPlaceholder(),
                                ),
                              )
                            : _buildPhotoPlaceholder(),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── NAMA ──
              _buildTextField(label: 'Nama Lengkap', controller: _namaC, icon: Icons.person_outline),
              const SizedBox(height: 14),

              // ── KELAS ──
              _buildTextField(label: 'Kelas', controller: _kelasC, icon: Icons.school_outlined),
              const SizedBox(height: 14),

              // ── JENIS KELAMIN ──
              _buildSectionLabel('Jenis Kelamin'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildGenderChip('Laki-laki', Icons.male_rounded),
                  const SizedBox(width: 12),
                  _buildGenderChip('Perempuan', Icons.female_rounded),
                ],
              ),
              const SizedBox(height: 14),

              // ── TTL ──
              _buildTextField(label: 'Tempat, Tanggal Lahir', controller: _ttlC, icon: Icons.cake_outlined, hintText: 'Contoh: Bogor, 5 Mei 2008'),
              const SizedBox(height: 14),

              // ── ALAMAT ──
              _buildTextField(label: 'Alamat', controller: _alamatC, icon: Icons.location_on_outlined),
              const SizedBox(height: 14),

              // ── NO HP ──
              _buildTextField(label: 'No. HP', controller: _noHpC, icon: Icons.phone_outlined, keyboardType: TextInputType.number),
              const SizedBox(height: 14),

              // ── EMAIL ──
              _buildTextField(label: 'Email', controller: _emailC, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),

              // ── TENTANG KANDIDAT ──
              _buildSectionLabel('Tentang Kandidat'),
              const SizedBox(height: 8),
              _buildTextField(label: '', controller: _tentangC, icon: Icons.info_outline, maxLines: 3, hintText: 'Tuliskan deskripsi singkat tentang calon...'),
              const SizedBox(height: 20),

              // ── KEAHLIAN ──
              _buildSectionLabel('Keahlian'),
              const SizedBox(height: 8),
              _buildTextField(label: '', controller: _keahlianC, icon: Icons.star_outline, hintText: 'Pisahkan dengan koma (Contoh: Public Speaking, Leadership)'),
              const SizedBox(height: 20),

              // ── PENGALAMAN ──
              _buildSectionLabel('Pengalaman Organisasi'),
              const SizedBox(height: 8),
              _buildTextField(
                label: '', 
                controller: _pengalamanC, 
                icon: Icons.work_outline, 
                maxLines: 5, 
                hintText: 'Satu pengalaman per baris\nContoh:\nKetua Kelas 1 selama 2 Periode\nAnggota PMR',
              ),
              const SizedBox(height: 20),

              // ── VISI (MUNCUL KALAU MODE TAMBAH) ──
              if (!_isEditMode) ...[
                _buildSectionLabel('Visi'),
                const SizedBox(height: 8),
                _buildTextField(label: '', controller: _visiC, icon: Icons.lightbulb_outline, maxLines: 3, hintText: 'Tuliskan visi calon...'),
                const SizedBox(height: 20),

                // ── MISI (MUNCUL KALAU MODE TAMBAH) ──
                _buildSectionLabel('Misi'),
                const SizedBox(height: 8),
                _buildTextField(
                  label: '', 
                  controller: _misiC, 
                  icon: Icons.checklist_outlined, 
                  maxLines: 5, 
                  hintText: 'Satu misi per baris\nContoh:\nMisi 1\nMisi 2\nMisi 3',
                ),
                const SizedBox(height: 30),
              ] else const SizedBox(height: 30),

              // ── TOMBOL SIMPAN ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0245A3),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    disabledBackgroundColor: const Color(0xFF0245A3).withOpacity(0.5),
                  ),
                  child: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(_isEditMode ? 'Simpan Perubahan' : 'Selesai', style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── WIDGET HELPER ──
  Widget _buildPhotoPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt_outlined,
          size: 40,
          color: Colors.grey[400],
        ),
        const SizedBox(height: 8),
        Text(
          'Upload Foto',
          style: GoogleFonts.inter(
            color: Colors.grey[500],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(text, style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF141B34)));
  }

  Widget _buildGenderChip(String label, IconData icon) {
    final isSelected = _jenisKelamin == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _jenisKelamin = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0245A3) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFF0245A3) : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: isSelected ? Colors.white : const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                label, 
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600, 
                  fontSize: 14, 
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
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
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(label, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF141B34), fontSize: 13)),
        if (label.isNotEmpty) const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            hintText: hintText,
            hintStyle: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF0245A3), width: 2)),
          ),
        ),
      ],
    );
  }
}