import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/bibliofilia/pages/chooseBook.dart';
import 'package:literalink/bibliofilia/pages/forum.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateForum extends StatefulWidget {
  final User user;

  const CreateForum({Key? key, required this.user}) : super(key: key);

  @override
  State<CreateForum> createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {

  final _formKey = GlobalKey<FormState>();
    
  String _namaBuku = "";
  String _reviewUser = "";
  String _forumsDescription = "";


  // Menggunakan widget.user dan widget.bookId untuk mendapatkan nilai yang dilewatkan ke widget
  late final int bookId;
  late final User user;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel dengan nilai dari widget
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
              color: LiteraLink.whiteGreen,
            ),
          ),
        ),
        backgroundColor: LiteraLink.whiteGreen,
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
                  hintText: "Judul Forum",
                  labelText: "Judul Forum",
                  labelStyle: const TextStyle(
                    color: LiteraLink.whiteGreen,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.whiteGreen)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _namaBuku = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Reply tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Description",
                  labelText: "Description",
                  labelStyle: const TextStyle(
                    color: LiteraLink.whiteGreen,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.whiteGreen)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _forumsDescription = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Reply tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Message",
                  labelText: "Message",
                  labelStyle: const TextStyle(
                    color: LiteraLink.whiteGreen,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.whiteGreen)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _reviewUser = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Reply tidak boleh kosong!";
                  }
                  return null;
                },
              ),
            ),
          
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                children:[ 
                  ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(LiteraLink.lightGreen),
                  ),
                  onPressed: () async {
                    String username = user.username;
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      final response = await request.postJson(
                          "https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/add_Forum_flutter/",
                          jsonEncode(<String, String>{
                            'username': username,
                            'bookname': _namaBuku,
                            'userReview' : _reviewUser,
                            'forumsDescription' : _forumsDescription,
                          }));

                      if (response['status'] == 'success') {
                        print("halo ini berhasil");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Pesanan baru berhasil dibuat!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ForumPage()),
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
                    "Add replies to this forum",
                    style: TextStyle(color: LiteraLink.whiteGreen),
                  ),
                ),
                const SizedBox(height: 10), // Add some space between the buttons
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChooseBookPage(user: user)),
                      );
                    },
                    child: const Text('Go to Choose Book'),
                  ),
              ]
              ),
            ),
          )
        ]
        ),
        ),
      ),
    );
  }
}