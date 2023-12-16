// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signin_page.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  User user = loggedInUser;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5ED),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 0,
                  child: Image.asset(
                    "assets/images/aset_profile.png",
                    fit: BoxFit.fitWidth,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  top: 180,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent, // Sesuaikan dengan warna latar belakang
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 90.0,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                ),
                Positioned(
                  top: 290,
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          width: MediaQuery.of(context).size.width,
                          child:Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                            "Nama Lengkap",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          ),
                                        ),
                                        readOnly: true, // Form ini sekarang readonly
                                        initialValue: loggedInUser.fullName, // Tetapkan nilai awal
                                      ),
                                    ),
                                    const Text(
                                            "Username",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          ),
                                        ),
                                        readOnly: true,
                                        initialValue: loggedInUser.username,
                                      ),
                                    ),
                                    const Text(
                                            "Email",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          ),
                                        ),
                                        readOnly: true,
                                        initialValue: loggedInUser.email,
                                      ),
                                    ),
                                    const Text(
                                            "Role",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Color(0xFF018845),
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                          ),
                                        ),
                                        readOnly: true,
                                        initialValue: loggedInUser.role == 'M' ? 'Member' : 'Admin',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12), // Atur nilai sesuai kebutuhan untuk menggeser ke atas
        child: SizedBox(
          width: 172,
          height: 57,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFEB6645),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign Out",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ],
              ),
            ),
            onPressed: () async {
                Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            }
            ),
            
        )
      )
    );
  }
}
