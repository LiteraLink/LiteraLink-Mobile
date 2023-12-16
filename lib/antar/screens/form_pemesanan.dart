// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/antar/screens/list_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ShopFormPage extends StatefulWidget {
  final int bookId;
  final User user;

  const ShopFormPage({Key? key, required this.bookId, required this.user})
      : super(key: key);

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
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: MediaQuery.of(context).size.height),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFFFFFFF),
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Form pemesanan\nBuku",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 170,
                    child: Container(
                        height: MediaQuery.of(context).size.height - 160,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEFF5ED),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38),
                                topRight: Radius.circular(38))),
                        child: Column(
                          children: [
                            const SizedBox(height: 32),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width,
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Nama Lengkap",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "Masukkan Nama Lengkap",
                                              fillColor: Color(0xFFFFFFFF),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _namaLengkap = value!;
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Nama Lengkap tidak boleh kosong!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Nomor Telepon",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Masukkan Nomor Telepon",
                                              fillColor: Color(0xFFFFFFFF),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _nomorTelepon = value!;
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Nomor Telepon tidak boleh kosong!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Alamat Pengiriman",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Masukkan Alamat Pengiriman",
                                              fillColor: Color(0xFFFFFFFF),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _alamatPengiriman = value!;
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Alamat Pengiriman tidak boleh kosong!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Jumlah Buku Dipesan",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText: "Masukkan Jumlah Buku",
                                              fillColor: Color(0xFFFFFFFF),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _jumlahBukudiPesan =
                                                    int.parse(value!);
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Jumlah Buku tidak boleh kosong!";
                                              }
                                              if (int.tryParse(value) == null) {
                                                return "Jumlah Buku harus berupa angka!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        const Text(
                                          "Durasi Peminjaman",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              hintText:
                                                  "Masukkan Durasi Peminjaman per hari",
                                              fillColor: Color(0xFFFFFFFF),
                                              filled: true,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0)),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              setState(() {
                                                _durasiPeminjaman =
                                                    int.parse(value!);
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Durasi Peminjaman tidak boleh kosong!";
                                              }
                                              if (int.tryParse(value) == null) {
                                                return "Durasi Peminjaman harus berupa angka!";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(
                bottom:
                    12), // Atur nilai sesuai kebutuhan untuk menggeser ke atas
            child: SizedBox(
              width: 182,
              height: 57,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFEB6645),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: const Row(
                    children: [
                      Text(
                        "Antar Buku Sekarang",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  int idBuku = bookId;
                  String username = user.username;
                  if (_formKey.currentState!.validate()) {
                    final response = await request.postJson(
                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/antar-buku-flutter/$idBuku/$username",
                        jsonEncode(<String, String>{
                          'nama_lengkap': _namaLengkap,
                          'nomor_telepon': _nomorTelepon,
                          'alamat_pengiriman': _alamatPengiriman,
                          'jumlah_buku_dipesan': _jumlahBukudiPesan.toString(),
                          'durasi_peminjaman': _durasiPeminjaman.toString(),
                        }));

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Pesanan baru berhasil dibuat!"),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CheckoutScreen(
                                  username: loggedInUser.username,
                                )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Terdapat kesalahan, silakan coba lagi."),
                      ));
                    }
                  }
                },
              ),
            )));
  }
}
