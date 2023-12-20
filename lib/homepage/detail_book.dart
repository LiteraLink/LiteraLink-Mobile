// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:literalink/homepage/models/fetch_book.dart';

class DetailBookPage extends StatefulWidget {
  final Book book;

  const DetailBookPage({Key? key, required this.book}) : super(key: key);

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  final _formKey = GlobalKey<FormState>();

  // Menggunakan widget.user dan widget.bookId untuk mendapatkan nilai yang dilewatkan ke widget
  late final int bookId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    width: 100,
                  ),
                  const Text(
                    "Detail\nBuku",
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
            top: MediaQuery.sizeOf(context).height / 5.5,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width / 3),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    20.0), // Ini akan membulatkan sudut gambar dan container
                child: Image.network(
                  widget.book.fields.thumbnail,
                ),
              ),
            ),
          ),
          Positioned(
            top: 360,
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height - 160,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF5ED),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 30),
                        width: MediaQuery.of(context).size.width,
                        child: Form(
                          key: _formKey,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "ID Buku",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF018845),
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: widget.book.fields.bookId,
                                    readOnly: true,
                                    decoration: const InputDecoration(
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
                                  ),
                                ),
                                const Text(
                                  "Judul Buku",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF018845),
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: widget.book.fields.title,
                                    readOnly: true,
                                    decoration: const InputDecoration(
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
                                  ),
                                ),
                                const Text(
                                  "Penulis",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF018845),
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: widget.book.fields.authors,
                                    readOnly: true,
                                    decoration: const InputDecoration(
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
                                  ),
                                ),
                                const Text(
                                  "Deskripsi",
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
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue:
                                        widget.book.fields.description,
                                    readOnly: true,
                                    decoration: const InputDecoration(
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
                                  ),
                                ),
                                const Text(
                                  "Kategori",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Color(0xFF018845),
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: widget.book.fields.categories,
                                    readOnly: true,
                                    decoration: const InputDecoration(
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
                                  ),
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 160,
          //   left: 100,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 28),
          //     child: ClipRRect(
          //       borderRadius: BorderRadius.circular(
          //           20.0), // Ini akan membulatkan sudut gambar dan container
          //       child: Container(
          //         decoration: BoxDecoration(
          //           color:
          //               Colors.white, // Background color for the book container
          //           borderRadius: BorderRadius.circular(
          //               20.0), // This matches the ClipRRect border radius
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.1),
          //               spreadRadius: 5,
          //               blurRadius: 7,
          //               offset:
          //                   const Offset(0, 3), // changes position of shadow
          //             ),
          //           ],
          //         ),
          //         child: Column(
          //           children: <Widget>[
          //             const SizedBox(),
          //             Image.network(
          //               widget.book.fields.thumbnail,
          //             ),
          //             // Add other widgets for the book title, author, etc.
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
