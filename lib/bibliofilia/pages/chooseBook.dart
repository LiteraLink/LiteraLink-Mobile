// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bibliofilia/pages/BookReviewForum.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:http/http.dart' as http;

class ChooseBookPage extends StatefulWidget {
  final User user;

  const ChooseBookPage({Key? key, required this.user}) : super(key: key);
  @override
  _ChooseBookPageState createState() => _ChooseBookPageState();
}

class _ChooseBookPageState extends State<ChooseBookPage> {
  // for searching books
  TextEditingController searchController = TextEditingController();

  Future<List<Book>> fetchItem() async {
    var url = Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/show_json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> listBook = [];

    for (var d in data) {
      if (d != null) {
        Book book = Book.fromJson(d);
        listBook.add(book);
      }
    }
    return listBook;
  }

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
                    width: 60,
                  ),
                  const Text(
                    "Review Buku",
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
            top: 110,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.1), // 10% of screen width
              width: MediaQuery.sizeOf(context).width,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                          child: Text(
                            'Pilihlah buku yang ingin anda review',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 190,
            child: Container(
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
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                fillColor: Color(0xFFFFFFFF),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFF7F8F9)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                ),
                                hintText: 'Search Book'),
                            onChanged: (value) {
                              setState(() {}); // Rebuild to filter results
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  buildBookList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBookList() {
    return FutureBuilder<List<Book>>(
      future: fetchItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data item.");
        } else {
          var filteredList = snapshot.data!.where((book) {
            return book.fields.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
          }).toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return buildBookItem(filteredList[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget buildBookItem(Book book) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Material(
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        book.fields.thumbnail,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: const Color(0xFFEB6645),
                              ),
                              child: Text(
                                book.fields.categories,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 249, 241, 241),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book.fields.title,
                              style: const TextStyle(
                                color: Color(0xFF252525),
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              book.fields.displayAuthors,
                              style: TextStyle(
                                color: const Color(0xFF252525).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 75.5),
                decoration: const BoxDecoration(
                  color: Color(0xFFDAE9D8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005F3D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookReviewForum(
                                      book: book, user: loggedInUser)),
                            );
                          },
                          child: const Text(
                            "Review Buku Ini",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
