import 'package:flutter/material.dart';
import 'edit_calon_page.dart';

class ProfileCalonPage extends StatefulWidget {
  final String tipeCalon;
  final String nama;
  final String visi;
  final String misi;
  final String? fotoPath;

  const ProfileCalonPage({
    super.key,
    required this.tipeCalon,
    required this.nama,
    required this.visi,
    required this.misi,
    this.fotoPath,
  });

  @override
  State<ProfileCalonPage> createState() => _ProfileCalonPageState();
}

class _ProfileCalonPageState extends State<ProfileCalonPage> {

  late String nama;
  late String visi;
  late String misi;
  String? fotoPath;

  @override
  void initState() {
    super.initState();

    nama = widget.nama;
    visi = widget.visi;
    misi = widget.misi;
    fotoPath = widget.fotoPath;
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

            Navigator.pop(context, {
              'nama': nama,
              'visi': visi,
              'misi': misi,
              'foto': fotoPath,
            });
          },
        ),

        title: Text(
          'Profile ${widget.tipeCalon}',

          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),

      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(

              padding: const EdgeInsets.all(24),

              child: Column(
                children: [

                  const SizedBox(height: 10),

                  // FOTO

                  Container(
                    padding: const EdgeInsets.all(4),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,

                      border: Border.all(
                        color: const Color(0xFF2E5CFF),
                        width: 3,
                      ),
                    ),

                    child: CircleAvatar(
                      radius: 55,

                      backgroundColor:
                          const Color(0xFFE0E7FF),

                      backgroundImage: fotoPath != null
                          ? NetworkImage(fotoPath!)
                          : null,

                      child: fotoPath == null
                          ? Text(
                              nama[0],

                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2E5CFF),
                              ),
                            )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // NAMA

                  Text(
                    nama,

                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xFF141B34),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // VISI

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(16),

                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Visi',

                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF2E5CFF),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          visi,

                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF141B34),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // MISI

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(16),

                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(
                          'Misi',

                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF2E5CFF),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          misi,

                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xFF141B34),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BUTTON

          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,

            child: Row(
              children: [

                // EDIT

                Expanded(
  child: SizedBox(
    height: 50,

    child: ElevatedButton(

      onPressed: () async {

        final result = await Navigator.push(

          context,

          MaterialPageRoute(
            builder: (context) => EditCalonPage(

              tipeCalon: widget.tipeCalon,

              nama: nama,

              visi: visi,

              misi: misi,

              fotoPath: fotoPath,
            ),
          ),
        );

        // kalau ada hasil edit
        if (result != null) {

          Navigator.pop(context, {

            'nama': result['nama'],

            'visi': result['visi'],

            'misi': result['misi'],

            'foto': result['foto'],
          });
        }
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2E5CFF),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      child: const Text(
        'Edit',

        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: Colors.white,
        ),
      ),
    ),
  ),
),

                const SizedBox(width: 16),

                // HAPUS

                Expanded(
                  child: SizedBox(
                    height: 50,

                    child: ElevatedButton(

                      onPressed: () {
  _showDeleteDialog(context);
},

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFEC4899),

                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(
                        'Hapus',

                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context) {

  showDialog(
    context: context,

    builder: (context) {

      return AlertDialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        title: const Text(
          'Hapus Calon?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),

        content: const Text(
          'Data calon akan dihapus permanen.',
        ),

        actions: [

          TextButton(

            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text('Batal'),
          ),

          ElevatedButton(

            onPressed: () {

              // tutup dialog
              Navigator.pop(context);

              // balik sambil kirim status hapus
              Navigator.pop(context, {
                'hapus': true,
              });
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEC4899),
            ),

            child: const Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}