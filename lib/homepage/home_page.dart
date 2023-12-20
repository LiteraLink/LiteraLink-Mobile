// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/homepage/profile.dart';
import 'package:literalink/main.dart';
import 'package:provider/provider.dart';

import 'package:literalink/antar/antar_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/bacaditempat/screens/venue_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signin_page.dart';
import 'package:literalink/dimanasajakapansaja/pages/station.dart';
import 'package:literalink/bibliofilia/pages/forum.dart';
import 'package:literalink/homepage/detail_book.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static List<Feature> items = [
    const Feature(
      "Antar",
      'assets/images/Antar_Icon.png',
      AntarPage(),
      Color(0xFF005F3D),
    ),
    const Feature(
      "Baca\nDiTempat",
      'assets/images/bacaditempat_logo.png',
      BacaDiTempat(),
      Color(0xFF018845),
    ),
    const Feature(
      "DimanaSaja\nKapanSaja",
      'assets/images/DSKS_Icon.png',
      DimanaSajaKapanSajaPage(),
      Color(0xFFEB6645),
    ),
    const Feature(
      "Bibliofilia",
      'assets/images/Bibliofilia_Icon.png',
      ForumPage(),
      Color(0xFFEF7A5D),
    ),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String baseUrl = 'https://literalink-e03-tk.pbp.cs.ui.ac.id';
  Set<String> categories = {"All"};
  String selectedCategory = "All";
  String? selectedCategoryBtn;
  final TextEditingController _searchController = TextEditingController();

  Future<List<Book>>? bookDbFuture;

  @override
  void initState() {
    super.initState();
    bookDbFuture = fetchBookDb(); // Menyimpan data yang sudah ready
  }

  Future<List<Book>> fetchBookDb() async {
    var url = Uri.parse('$baseUrl/show_json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Book> listBook = [];

    for (var i in data) {
      if (i != null) {
        Book book = Book.fromJson(i);
        listBook.add(book);
        categories.add(book.fields.categories);
      }
    }
    return listBook;
  }

  void setSelectedCategory(String category) {
    setState(() => selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
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
                top: 70,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome to",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xFFFFFFFF)
                                      .withOpacity(0.8))),
                          const Text(
                            "LiteraLink",
                            style: TextStyle(
                                fontSize: 32,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(isNavigatedByRoot: true)),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Color(0xFFFFFFFF),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 160,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFEFF5ED),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(38),
                          topRight: Radius.circular(38))),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      buildFeatureList(),
                      const SizedBox(height: 18),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) => setState(() {}),
                                decoration: const InputDecoration(
                                    fillColor: Color(0xFFFFFFFF),
                                    filled: true,
                                    suffixIcon: Icon(
                                      Icons.search,
                                      color: LiteraLink.lightGreen,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFF7F8F9)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF7F8F9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    hintText: 'Search Book'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      buildCategoryList(),
                      buildBookList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFeatureList() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width) *
            0.04,
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: HomePage.items.length,
          itemBuilder: (context, i) => FeatureCard(
            HomePage.items[i],
            baseUrl: baseUrl,
          ),
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: MediaQuery.of(context).size.width * 0.015),
        ),
      ),
    );
  }

  Widget buildCategoryList() {
    return FutureBuilder<List<Book>>(
      future: bookDbFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Platform.isAndroid
                  ? const CircularProgressIndicator()
                  : const CupertinoActivityIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData ||
            snapshot.data!.isEmpty ||
            categories.isEmpty) {
          return const Text('Tidak ada data kategori');
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 32,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories.elementAt(index);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ElevatedButton(
                    onPressed: () => setSelectedCategory(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == category
                          ? const Color(0xFF018845)
                          : const Color(0xFFD6EADC),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(category,
                          style: TextStyle(
                              color: selectedCategory == category
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF018845))),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget buildBookList() {
    return FutureBuilder<List<Book>>(
      future: bookDbFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data item.");
        } else {
          var filteredList = snapshot.data!.where((item) {
            return item.fields.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();
          return Container(
              padding: const EdgeInsets.only(top: 18),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 0,
                  bottom: MediaQuery.of(context).padding.bottom + 560,
                  left: 0,
                  right: 0,
                ),
                itemCount: filteredList
                    .where((book) =>
                        selectedCategory == "All" ||
                        book.fields.categories == selectedCategory)
                    .length,
                itemBuilder: (context, index) {
                  var book = filteredList
                      .where((book) =>
                          selectedCategory == "All" ||
                          book.fields.categories == selectedCategory)
                      .elementAt(index);

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: InkWell(
                      onTap: () =>
                          Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            builder: (context) => DetailBookPage(book: book)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Material(
                          color: const Color(0xFFFFFFFF),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          book.fields.thumbnail,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 18),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 18),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: const Color(
                                                        0xFFEB6645)),
                                                child: Text(
                                                  book.fields.categories,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Color.fromARGB(
                                                        255, 249, 241, 241),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                book.fields.title,
                                                style: const TextStyle(
                                                    color: Color(0xFF252525),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                book.fields.displayAuthors,
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF252525)
                                                            .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ));
        }
      },
    );
  }
}

class Feature {
  final String name;
  final String icon;
  final Widget page;
  final Color color;

  const Feature(this.name, this.icon, this.page, this.color);
}

class FeatureCard extends StatelessWidget {
  final Feature item;
  final String baseUrl;
  const FeatureCard(this.item, {Key? key, required this.baseUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      width: 85,
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(36),
      ),
      child: InkWell(
        onTap: () async {
          if (item.name != "Logout") {
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (context) => item.page),
            );
          } else {
            final response =
                await request.logout("$baseUrl/auth/signout-flutter/");
            String message = response["message"];

            if (response['status']) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "$message Sampai jumpa, ${loggedInUser.username}.")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.icon,
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFFFFFFF)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
