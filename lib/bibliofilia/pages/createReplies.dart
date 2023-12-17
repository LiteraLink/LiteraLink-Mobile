// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CreateReplies extends StatefulWidget {
  final Forum forum;
  final int forumId;
  final User user;

  const CreateReplies(
      {Key? key,
      required this.forumId,
      required this.user,
      required this.forum})
      : super(key: key);

  @override
  State<CreateReplies> createState() => _CreateRepliesState();
}

class _CreateRepliesState extends State<CreateReplies> {
  final _formKey = GlobalKey<FormState>();

  String _replies = "";
  String isiReplies = "";

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
                            width: 60,
                          ),
                          const Text(
                            "Form Replies\nForum",
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
                                          "Replies",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            minLines: 1,
                                            maxLines: 30,
                                            decoration: const InputDecoration(
                                              hintText: "Masukkan Replies",
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
                                                _replies = value!;
                                              });
                                            },
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Replies tidak boleh kosong!";
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
              width: 125,
              height: 57,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFEB6645),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  child: const Row(
                    children: [
                      Text(
                        "Add Replies",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                ),
                onPressed: () async {
                  String username = user.username;
                  if (_formKey.currentState!.validate()) {
                    // Kirim ke Django dan tunggu respons
                    final response = await request.postJson(
                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/add_replies_flutter/",
                        jsonEncode(<String, String>{
                          'username': username,
                          'forum_id': widget.forumId.toString(),
                          'text': _replies,
                        }));

                    if (response['status'] == 'success') {
                      // print("halo ini berhasil");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Pesanan baru berhasil dibuat!"),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForumRepliesPage(
                                  forumId: widget.forumId,
                                  forum: widget.forum,
                                )),
                      );
                    } else {
                      // print("ini gak berhasil");
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
