import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/main.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  User user = loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Profile", style: TextStyle(color: LiteraLink.offWhite)),
        backgroundColor: LiteraLink.tealDeep,
        // Tambahkan properti lain sesuai kebutuhan Anda
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                  children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/App_Logo.png',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 20),
                  itemProfile('Name', user.fullName, CupertinoIcons.person, const Color(0xFFAFD0CB)),
                  const SizedBox(height: 10),
                  itemProfile('Email', user.email, CupertinoIcons.mail, const Color(0xFFEEEEC0)),
                  const SizedBox(height: 10),
                  itemProfile(
                    'Role',
                    user.role == 'M' ? 'Member' : 'Admin',
                    CupertinoIcons.person_alt_circle,
                    const Color(0xFFD2DE32),
                  ),
                ],
              ),
            ),
          ),
          // Satu gambar di paling bawah halaman
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 10),
            child: Image.asset(
              'assets/images/gunungijo.png',
              // width: 50,
              // height: 50,
            ),
          ),
        ],
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData, Color color) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: LiteraLink.tealDeep.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            color: LiteraLink.tealDeep, // Ganti dengan warna yang diinginkan
            // Sesuaikan dengan properti TextStyle lainnya sesuai kebutuhan
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: LiteraLink.tealDeep, // Ganti dengan warna yang diinginkan
            // Sesuaikan dengan properti TextStyle lainnya sesuai kebutuhan
          ),
        ),
        leading: Icon(iconData, color: LiteraLink.tealDeep),
        tileColor: Colors.white,
      ),
    );
  }
}
