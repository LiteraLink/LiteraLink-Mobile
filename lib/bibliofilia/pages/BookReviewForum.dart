import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/bibliofilia/pages/forum.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookReviewForum extends StatefulWidget {
  final User user;
  final Book book;

  const BookReviewForum({Key? key, required this.user, required this.book}) : super(key: key);

  @override
  State<BookReviewForum> createState() => _BookReviewForumState();
}

class _BookReviewForumState extends State<BookReviewForum> {

  final _formKey = GlobalKey<FormState>();
    
  String _namaBuku = "";
  String _reviewUser = "";
  String _forumsDescription = "";


  // Menggunakan widget.user dan widget.book untuk mendapatkan nilai yang dilewatkan ke widget
  late final Book book;
  late final User user;

  @override
  void initState() {
    super.initState();
    // Inisialisasi variabel dengan nilai dari widget
    user = loggedInUser;
    book = widget.book;
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
                  initialValue: book.fields.title,
                  readOnly: true,
                    style: TextStyle(
                    color: LiteraLink.whiteGreen,
                  ),
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
                child: ElevatedButton(
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
                          // "https://virgillia-yeala-tugas.pbp.cs.ui.ac.id/create-flutter/",
                          "http://localhost:8000/bibliofilia/add_BookForum_flutter/",
                          jsonEncode(<String, String>{
                            'book_id': book.pk.toString(),
                            'username': username,
                            'bookname': _namaBuku,
                            'title': book.fields.title,
                            'authors': book.fields.authors,
                            'display_authors': book.fields.displayAuthors,
                            'description': book.fields.description,
                            'categories': book.fields.categories,
                            'thumbnail': book.fields.thumbnail,
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
                    "Add review to this book",
                    style: TextStyle(color: LiteraLink.whiteGreen),
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