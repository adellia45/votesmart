import 'package:flutter/material.dart';
import 'tambah_calon_page.dart';
import 'profile_calon_page.dart';

class KetosPage extends StatefulWidget {
  const KetosPage({super.key});

  @override
  State<KetosPage> createState() => _KetosPageState();
}

class _KetosPageState extends State<KetosPage> {

  List<Map<String, dynamic>> calonKetos = [

    {
      'nama': 'Seonghyeon',
      'visi': 'Meningkatkan Disiplin',
      'misi':
          '1. Membangun tata tertib\n2. Menegakkan aturan',
      'foto': null,
    },

    {
      'nama': 'A - na',
      'visi': 'Meningkatkan Kebersihan',
      'misi':
          '1. Program kerja bersih\n2. Menjaga lingkungan',
      'foto': null,
    },

    {
      'nama': 'Yuha',
      'visi': 'Meningkatkan Kreativitas',
      'misi':
          '1. Membuat wadah kreatif\n2. Mendorong inovasi',
      'foto': null,
    },

    {
      'nama': 'James',
      'visi': 'Meningkatkan Keimanan',
      'misi':
          '1. Meningkatkan ibadah\n2. Memperkuat silaturahmi',
      'foto': null,
    },
  ];

  Future<void> _tambahCalon() async {

    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            const TambahCalonPage(
          tipeCalon: 'Ketos',
        ),
      ),
    );

    if (result != null) {

      setState(() {

        calonKetos.add({
          'nama': result['nama'],
          'visi': result['visi'],
          'misi': result['misi'],
          'foto': result['foto'],
        });
      });
    }
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

          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Kelola Calon',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: _tambahCalon,

                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),

                label: const Text(
                  'Tambah Calon',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2E5CFF),

                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.separated(

                itemCount: calonKetos.length,

                separatorBuilder:
                    (context, index) =>
                        const SizedBox(height: 12),

                itemBuilder: (context, index) {

                  final calon = calonKetos[index];

                  return InkWell(

                   onTap: () async {

  final result = await Navigator.push(

    context,

    MaterialPageRoute(
      builder: (context) => ProfileCalonPage(
        tipeCalon: 'Ketos',

        nama: calon['nama'],
        visi: calon['visi'],
        misi: calon['misi'],
        fotoPath: calon['foto'],
      ),
    ),
  );

  // KALAU DATA DIHAPUS
  if (result != null && result['hapus'] == true) {

    setState(() {
      calonKetos.removeAt(index);
    });

    return;
  }

  // KALAU DATA DIEDIT
  if (result != null) {

    setState(() {

      calonKetos[index] = {
        'nama': result['nama'],
        'visi': result['visi'],
        'misi': result['misi'],
        'foto': result['foto'],
      };
    });
  }
},

                    borderRadius:
                        BorderRadius.circular(16),

                    child: Container(
                      padding: const EdgeInsets.all(16),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(16),

                        border: Border.all(
                          color:
                              const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),

                      child: Row(
                        children: [

                          calon['foto'] != null

                              ? CircleAvatar(
                                  radius: 24,

                                  backgroundImage:
                                      NetworkImage(
                                    calon['foto'],
                                  ),
                                )

                              : CircleAvatar(
                                  radius: 24,

                                  backgroundColor:
                                      const Color(
                                          0xFFE0E7FF),

                                  child: Text(
                                    calon['nama'][0],

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w700,

                                      fontSize: 18,

                                      color: Color(
                                          0xFF2E5CFF),
                                    ),
                                  ),
                                ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  calon['nama'],

                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.w700,

                                    fontSize: 16,

                                    color: Color(
                                        0xFF141B34),
                                  ),
                                ),

                                const SizedBox(
                                    height: 6),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        const Color(
                                            0xFFEEF2FF),

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                                6),
                                  ),

                                  child: Text(
                                    calon['visi'],

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w500,

                                      fontSize: 12,

                                      color: Color(
                                          0xFF2E5CFF),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                        ],
                      ),
                    ),
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