import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    SettingsScreen(),
    ProfileScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi Karyawan"),
        actions: const [],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            const BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "Perusahaan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Pengajuan",
            ),
          ]),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              'PT. Network Data Sistem adalah mitra Anda di Perusahaan Bisnis Konsultasi Teknologi dan Informasi. Kami terdiri dari para ahli berkualifikasi yang berspesialisasi dalam IT dan tim kami berdedikasi untuk memberikan layanan dan dukungan berkualitas tinggi.'),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    PickedFile? pickedImage;
    late File imageFile;
    bool _load = false;

    Future chooseImage(ImageSource source) async {
      final pickedFile =
          await ImagePicker().getImage(source: ImageSource.camera);
      setState(() {
        imageFile = File(pickedFile!.path);
        _load = true;
      });
    }

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
              "Selamat Datang di PT. Network Data Sistem\nSilahkan ambil absent anda"),
          Container(
            child: _load == true
                ? Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(imageFile),
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(15.0),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.asset(
                        'assets/up.png',
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
          ElevatedButton(
            onPressed: () {
              chooseImage(ImageSource.gallery);
            },
            child: Text('Ambil Foto'),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
              elevation: 3,
              shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _tipeCutiController = TextEditingController();
  TextEditingController _tanggalMulaiController = TextEditingController();
  TextEditingController _tanggalBerakhirController = TextEditingController();
  TextEditingController _pesanController = TextEditingController();

  DateTime _selectedTanggalMulai = DateTime.now();
  DateTime _selectedTanggalBerakhir = DateTime.now();

  Future<void> _selectTanggalMulai(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalMulai,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedTanggalMulai) {
      setState(() {
        _selectedTanggalMulai = picked;
        _tanggalMulaiController.text =
            DateFormat('yyyy-MM-dd').format(_selectedTanggalMulai);
      });
    }
  }

  Future<void> _selectTanggalBerakhir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTanggalBerakhir,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedTanggalBerakhir) {
      setState(() {
        _selectedTanggalBerakhir = picked;
        _tanggalBerakhirController.text =
            DateFormat('yyyy-MM-dd').format(_selectedTanggalBerakhir);
      });
    }
  }

  late File _file;

  // Future getFile() async {
  //   var file = await FilePicker.platform.pickFiles();
  //   if (file != null) {
  //     setState(() {
  //       _file = File(file.files.single.path);
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mohon masukkan nama';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _tipeCutiController,
              decoration: InputDecoration(labelText: 'Tipe Cuti'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mohon masukkan tipe cuti';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _tanggalMulaiController,
              decoration: InputDecoration(
                labelText: 'Tanggal Mulai',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectTanggalMulai(context);
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mohon masukkan tanggal mulai';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _tanggalBerakhirController,
              decoration: InputDecoration(
                labelText: 'Tanggal Berakhir',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectTanggalBerakhir(context);
                  },
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mohon masukkan tanggal berakhir';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _pesanController,
              decoration: InputDecoration(labelText: 'Pesan'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Mohon masukkan pesan';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Upload Berkas'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {},
              child: Text('Kirim Pengajuan'),
            ),
          ],
        ),
      ),
    );
  }
}
