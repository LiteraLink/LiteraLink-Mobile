// ignore_for_file: use_build_context_synchronously, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/bibliofilia/pages/chooseBook.dart';
import 'package:literalink/bibliofilia/pages/forum.dart';
import 'package:literalink/authentication/models/user.dart';
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
                          "Form Pembuatan\nForum",
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
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            width: MediaQuery.of(context).size.width,
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Judul Forum",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF018845),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Masukkan Judul Forum",
                                            fillColor: Color(0xFFFFFFFF),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0))),
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _namaBuku = value!;
                                            });
                                          },
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Judul Forum tidak boleh kosong!";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "Description",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF018845),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: "Masukkan Description",
                                            fillColor: Color(0xFFFFFFFF),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0))),
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _forumsDescription = value!;
                                            });
                                          },
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Description tidak boleh kosong!";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const Text(
                                        "Message",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Color(0xFF018845),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 10,
                                          decoration: const InputDecoration(
                                            hintText: "Masukkan Massage",
                                            fillColor: Color(0xFFFFFFFF),
                                            filled: true,
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFFF7F8F9)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25.0))),
                                          ),
                                          onChanged: (String? value) {
                                            setState(() {
                                              _reviewUser = value!;
                                            });
                                          },
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Massage tidak boleh kosong!";
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
            bottom: 12), // Atur nilai sesuai kebutuhan untuk menggeser ke atas
        child: Row(
          mainAxisSize: MainAxisSize.min, // Use min size for the column
          children: [
            // First button (Buat Forum)
            SizedBox(
              width: 120,
              height: 57,
              child: FloatingActionButton(
                heroTag: 'buatforum',
                backgroundColor: const Color(0xFFEB6645),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: const FittedBox(
                    // Use FittedBox to fit the row in the button
                    child: Text(
                      "Buat Forum",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
                onPressed: () async {
                  String username = user.username;
                  if (_formKey.currentState!.validate()) {
                    // Kirim ke Django dan tunggu respons
                    final response = await request.postJson(
                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/add_Forum_flutter/",
                        jsonEncode(<String, String>{
                          'username': username,
                          'bookname': _namaBuku,
                          'userReview': _reviewUser,
                          'forumsDescription': _forumsDescription,
                        }));

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Pesanan baru berhasil dibuat!"),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForumPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Terdapat kesalahan, silakan coba lagi."),
                      ));
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 10), // Space between buttons
            // Second button (Review Buku)
            SizedBox(
              width: 120,
              height: 57,
              child: FloatingActionButton(
                heroTag: 'reviewbuku',
                backgroundColor: const Color(0xFFEB6645),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: const FittedBox(
                    // Use FittedBox to fit the row in the button
                    child: Text(
                      "Review Buku",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChooseBookPage(user: user)),
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
