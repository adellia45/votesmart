import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahCalonPage extends StatefulWidget {
  final String tipeCalon;

  const TambahCalonPage({
    super.key,
    required this.tipeCalon,
  });

  @override
  State<TambahCalonPage> createState() => _TambahCalonPageState();
}

class _TambahCalonPageState extends State<TambahCalonPage> {

  final TextEditingController _namaController =
      TextEditingController();

  final TextEditingController _visiController =
      TextEditingController();

  final TextEditingController _misiController =
      TextEditingController();

  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  void _simpanCalon() {

    Navigator.pop(context, {
      'nama': _namaController.text,
      'visi': _visiController.text,
      'misi': _misiController.text,
      'foto': _pickedImage?.path,
      'tipeCalon': widget.tipeCalon,
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _visiController.dispose();
    _misiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF2E5CFF),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Tambah Calon ${widget.tipeCalon}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // ───────── NAMA ─────────

            const Text(
              'Nama Calon',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF141B34),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _namaController,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                hintText: 'Masukkan nama calon',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E5CFF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ───────── FOTO ─────────

            const Text(
              'Foto Calon',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF141B34),
              ),
            ),

            const SizedBox(height: 8),

            Center(
              child: GestureDetector(
                onTap: _pickImage,

                child: Container(
                  width: 130,
                  height: 130,

                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),

                  child: _pickedImage != null

                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(14),

                          child: Image.network(
                            _pickedImage!.path,
                            fit: BoxFit.cover,
                          ),
                        )

                      : Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: const [

                            Icon(
                              Icons.camera_alt_outlined,
                              color: Color(0xFF9CA3AF),
                              size: 40,
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Upload Foto',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ───────── VISI ─────────

            const Text(
              'Visi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF141B34),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _visiController,
              maxLines: 3,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                hintText: 'Tuliskan visi...',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E5CFF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ───────── MISI ─────────

            const Text(
              'Misi',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF141B34),
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: _misiController,
              maxLines: 3,

              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,

                hintText: 'Tuliskan misi...',

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF2E5CFF),
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ───────── BUTTON ─────────

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: _simpanCalon,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2E5CFF),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}