import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/antar/screens/form_pemesanan.dart';
import 'package:literalink/antar/screens/list_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/main.dart';
import 'package:http/http.dart' as http;

class AntarPage extends StatefulWidget {
  @override
  _AntarPageState createState() => _AntarPageState();
}

class _AntarPageState extends State<AntarPage> {

  Future<List<Book>> fetchItem() async {
    var url = Uri.parse('http://localhost:8000/show_json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> listBook = [];

    for (var d in data) {
      if (d != null) {
        Book book = Book.fromJson(d);
        listBook.add(book);
        // categories.add(book.fields.categories);
      }
    }
    return listBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA2C579),
      appBar: AppBar(
        title: const Text(
            'LiteraLink',
            style: TextStyle(color: LiteraLink.tealDeep, letterSpacing: 1.5, fontWeight: FontWeight.w500)
        ),
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
        ),
        backgroundColor: LiteraLink.offWhite, // Atur warna latar belakang menjadi transparan
        elevation: 0, // Hilangkan bayangan (shadow)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: LiteraLink.offWhite,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Image.asset(
                  //   "assets/images/circles.png",
                  //   height: MediaQuery.of(context).size.height, // Sesuaikan dengan kebutuhan Anda
                  //   width: MediaQuery.of(context).size.width, // Sesuaikan dengan kebutuhan Anda
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70),
                      const Text(
                        'Antar',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: LiteraLink.tealDeep),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                        child: Text(
                          'Layanan pengantaran buku ke alamat yang diinginkan',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: LiteraLink.tealDeep),
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          // Navigasi ke halaman baru di sini
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CheckoutScreen()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(LiteraLink.limeGreen),
                        ),
                        child: const Text('List Pengantaran Buku', style: TextStyle(color: LiteraLink.tealDeep)),
                      ),
                      const SizedBox(height: 60),
                      Positioned(
                        top: 40, // Sesuaikan dengan kebutuhan Anda
                        child: Container(
                          height: 30,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA2C579),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 5),
                      color: Theme.of(context).primaryColor.withOpacity(.2),
                      spreadRadius: 2,
                      blurRadius: 5
                    )
                  ]
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search books',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20)
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: LiteraLink.limeGreen,
                        shape: BoxShape.circle
                      ),
                      child: const Center(child: Icon(Icons.search, color: LiteraLink.tealDeep, size: 22)),
                    )
                  ],
                ),
              ),
            ),
            buildBookList(),
          ],
        ),
      ),
    );
  }

  Widget buildBookList() {
    return FutureBuilder<List<Book>>(
      future: fetchItem(),
      builder: (context, snapshot,) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          return Column(
            children: snapshot.data!
              .map<Widget>((book) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Material(
                    color: LiteraLink.lightKhaki,
                    child: Row(
                      children: [
                        Image.network(book.fields.thumbnail),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.fields.categories,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: LiteraLink.tealDeep,
                                ),
                              ),
                              Text(
                                book.fields.title,
                                style: const TextStyle(
                                  color: LiteraLink.tealDeep,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                book.fields.displayAuthors,
                                style: const TextStyle(color: LiteraLink.tealDeep),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // pergi ke halaman form data pengantaran 
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ShopFormPage(bookId: book.pk, user: loggedInUser,)),
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(LiteraLink.limeGreen),
                                ),
                                child: const Text('Antar Buku Ini', style: TextStyle(color: LiteraLink.tealDeep)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ).toList(),
          );
        }
      },
    );
  }
}
