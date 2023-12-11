import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/homepage/profile.dart';
import 'package:provider/provider.dart';

import 'package:literalink/antar/antar_page.dart';
import 'package:literalink/bibliofilia/forum.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/bacaditempat/screens/venue_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signin_page.dart';
import 'package:literalink/dimanasajakapansaja/pages/station.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static List<Feature> items = [
    Feature(
      "Antar",
      'assets/images/Antar_Icon.png',
      AntarPage(user: loggedInUser,),
      Color(0xFF005F3D),
    ),
    Feature(
      "Baca\nDiTempat",
      'assets/images/bacaditempat_logo.png',
      BacaDiTempat(),
      Color(0xFF018845),
    ),
    Feature(
      "DimanaSaja\nKapanSaja",
      'assets/images/DSKS_Icon.png',
      DimanaSajaKapanSajaPage(),
      Color(0xFFEB6645),
    ),
    Feature(
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

  Future<List<Book>> fetchItem() async {
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
                                color: const Color(0xFFFFFFFF).withOpacity(0.8)
                              )
                            ),
                            const Text(
                              "LiteraLink",
                              style: TextStyle(
                                fontSize: 32,
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                        const Icon(
                          Icons.person,
                          size: 40.0,
                          color: Color(0xFFFFFFFF),
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
                              const Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                      fillColor: Color(0xFFFFFFFF),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF7F8F9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                      ),
                                      hintText: 'Search Book'),
                                ),
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFEB6645),
                                ),
                                child: const Icon(
                                  Icons.filter_alt_rounded,
                                  color: Colors.white,
                                ),
                              )
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
      ),
    );
  }

  Widget buildFeatureList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 140,
      width: MediaQuery.of(context).size.width,
      child: Align(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: HomePage.items.length,
          itemBuilder: (context, i) => FeatureCard(
            HomePage.items[i],
            baseUrl: baseUrl,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList() {
    return FutureBuilder<List<Book>>(
      future: fetchItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                            : const Color(0xFF018845)
                        )
                      ),
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
      future: fetchItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data item.");
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              padding: EdgeInsets.zero,
              children: snapshot.data!
                  .where((book) =>
                      selectedCategory == "All" ||
                      book.fields.categories == selectedCategory)
                  .map<Widget>((book) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Material(
                            color: const Color(0xFFFFFFFF),
                            child: Container(
                              margin: const EdgeInsets.all(14),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 18),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: const Color(0xFFEB6645)),
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
                                                color: const Color(0xFF252525)
                                                    .withOpacity(0.6)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Container(
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
              final response = await request.logout("$baseUrl/auth/signout-flutter/");
              String message = response["message"];

              if (response['status']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$message Sampai jumpa, ${loggedInUser.username}."
                    )
                  ),
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
                    color: Color(0XFFFFFFFF)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
