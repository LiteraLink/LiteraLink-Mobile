import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateReplies extends StatefulWidget {
  final int forumId;
  final User user;

  const CreateReplies({Key? key, required this.forumId, required this.user}) : super(key: key);

  @override
  State<CreateReplies> createState() => _CreateRepliesState();
}

class _CreateRepliesState extends State<CreateReplies> {

  final _formKey = GlobalKey<FormState>();
  
  String _replies = "";
  String isiReplies = "";
  
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
                  hintText: "Replies",
                  labelText: "Replies",
                  labelStyle: const TextStyle(
                    color: LiteraLink.tealDeep,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(color: LiteraLink.tealDeep)),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _replies = value!;
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
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(LiteraLink.limeGreen),
                  ),
                  onPressed: () async {
                    String username = user.username;
                    if (_formKey.currentState!.validate()) {
                      // Kirim ke Django dan tunggu respons
                      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                      final response = await request.postJson(
                          // "https://virgillia-yeala-tugas.pbp.cs.ui.ac.id/create-flutter/",
                          "http://localhost:8000/bibliofilia/add_replies_flutter/",
                          jsonEncode(<String, String>{
                            'username': username,
                            'forum_id': widget.forumId.toString(),
                            'text' : _replies,
                          }));

                      if (response['status'] == 'success') {
                        print("halo ini berhasil");
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Pesanan baru berhasil dibuat!"),
                        ));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ForumRepliesPage(forumId: widget.forumId)),
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