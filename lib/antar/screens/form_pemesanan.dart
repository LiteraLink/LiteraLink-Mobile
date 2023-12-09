import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/antar/screens/list_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopFormPage extends StatefulWidget {
  final int bookId;
  final User user;

  const ShopFormPage({Key? key, required this.bookId, required this.user}) : super(key: key);

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {

  final _formKey = GlobalKey<FormState>();
  
  String _namaLengkap = "";
  String _nomorTelepon = "";
  String _alamatPengiriman = "";
  int _jumlahBukudiPesan = 0;
  int _durasiPeminjaman = 0;
  
  // Menggunakan widget.user dan widget.bookId untuk mendapatkan nilai yang dilewatkan ke widget
  late final int bookId;
  late final User user;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel dengan nilai dari widget
    bookId = widget.bookId;
    user = loggedInUser;
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Pemesanan Buku',
            style: TextStyle(
              color: LiteraLink.tealDeep,
            ),
          ),
        ),
        backgroundColor: LiteraLink.offWhite,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back_icon1.png', // Ganti dengan path yang benar ke file gambar
            width: 24, // Sesuaikan ukuran ikon sesuai kebutuhan
            height: 24,
          ),
          onPressed: () {
            // Navigasi ke halaman baru di sini
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),// Atur warna latar belakang menjadi transparan
        elevation: 0, 
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Nama Lengkap",
                  labelText: "Nama Lengkap",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.tealDeep)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _namaLengkap = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Lengkap tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Nomor Telepon",
                  labelText: "Nomor Telepon",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _nomorTelepon = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nomor Telepon tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Alamat Pengiriman",
                  labelText: "Alamat Pengiriman",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _alamatPengiriman = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat Pengiriman tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Jumlah Buku",
                  labelText: "Jumlah Buku",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.tealDeep)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _jumlahBukudiPesan = int.parse(value!);
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah Buku tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Jumlah Buku harus berupa angka!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Durasi Peminjaman",
                  labelText: "Durasi Peminjaman",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.tealDeep)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _durasiPeminjaman = int.parse(value!);
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Durasi Peminjaman tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Durasi Peminjaman harus berupa angka!";
                  }
                  return null;
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(LiteraLink.limeGreen),
                  ),
                  onPressed: () async {
                    int idBuku = bookId;
                    String username = user.username;
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      final response = await request.postJson(
                          // "https://virgillia-yeala-tugas.pbp.cs.ui.ac.id/create-flutter/",
                          "https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/antar-buku-flutter/$idBuku/$username",
                          jsonEncode(<String, String>{
                            'nama_lengkap': _namaLengkap,
                            'nomor_telepon': _nomorTelepon,
                            'alamat_pengiriman': _alamatPengiriman,
                            'jumlah_buku_dipesan': _jumlahBukudiPesan.toString(),
                            'durasi_peminjaman': _durasiPeminjaman.toString(),
                          }));

                      if (response['status'] == 'success') {
                        print("halo ini berhasil");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Pesanan baru berhasil dibuat!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CheckoutScreen(username: loggedInUser.username,)),
                        );
                      } else {
                        print("ini gak berhasil");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                  },
                  child: const Text(
                    "Antar Buku Sekarang",
                    style: TextStyle(color: LiteraLink.tealDeep),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}