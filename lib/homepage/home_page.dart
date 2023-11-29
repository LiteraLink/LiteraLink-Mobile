import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/homepage/profile.dart';
import 'package:provider/provider.dart';

import 'package:literalink/main.dart';
import 'package:literalink/antar/antar_page.dart';
import 'package:literalink/bibliofilia/forum.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:literalink/bacaditempat/venue_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/authentication/page/signin_page.dart';
import 'package:literalink/dimanasajakapansaja/pages/station.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static List<ShopItem> items = [
    ShopItem("Antar", 'assets/images/Antar_Icon.png', AntarPage()),
    ShopItem("BacaDiTempat", 'assets/images/Bibliofilia_Icon.png', VenuePage()),
    ShopItem("DimanaSajaKapanSaja", 'assets/images/DSKS_Icon.png', DimanaSajaKapanSajaPage()),
    ShopItem("Bibliofilia", 'assets/images/Bibliofilia_Icon.png', ForumPage()),
    ShopItem("Logout", 'assets/images/DSKS_Icon.png', SignInPage()),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Set<String> categories = {"All"};
  String selectedCategory = "All";
  String? selectedCategoryBtn;

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
      appBar: AppBar(
        title: const Text(
          "LiteraLink", 
          style: TextStyle(
            color: LiteraLink.tealDeep
          )
        ),
        backgroundColor: LiteraLink.limeGreen,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/User.png', // Ganti dengan path yang benar ke file gambar
            width: 24, // Sesuaikan ukuran ikon sesuai kebutuhan
            height: 24,
          ),
          onPressed: () {
            // Navigasi ke halaman baru di sini
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Feature',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold
                    )
                  ),
                ),
                buildFeatureList(),
                const SizedBox(height: 10),
                buildCategoryList(),
                buildBookList()
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureList() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: HomePage.items.length,
        itemBuilder: (context, i) => BookCard(HomePage.items[i]),
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
            height: 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                String category = categories.elementAt(index);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: OutlinedButton(
                    onPressed: () => setSelectedCategory(category),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selectedCategory == category
                          ? LiteraLink.tealDeep
                          : const Color(0xFFD0E2AB), // Change color when selected
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        category,
                        style: const TextStyle(color: Colors.black),
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
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          return Column(
            children: snapshot.data!
              .where((book) =>
                selectedCategory == "All" ||
                book.fields.categories == selectedCategory)
              .map<Widget>((book) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Material(
                    color: LiteraLink.limeGreen,
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
                                  color: Color.fromARGB(255, 249, 241, 241),
                                ),
                              ),
                              Text(
                                book.fields.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),
                              ),
                              Text(
                                book.fields.displayAuthors,
                                style: const TextStyle(color: Colors.white),
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

class ShopItem {
  final String name;
  final String icon;
  final Widget page;

  const ShopItem(this.name, this.icon, this.page);
}

class BookCard extends StatelessWidget {
  final ShopItem item;

  const BookCard(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: LiteraLink.lightKhaki,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: () async {
            if (item.name != "Logout") {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => item.page),
              );
            } else {
              final response = await request.logout("http://localhost:8000/auth/signout-flutter/");
              String message = response["message"];

              if (response['status']) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$message Sampai jumpa, ${loggedInUser.username}.")
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.icon,
                width: 100,
                height: 100,
              ),
              item.name == "DimanaSajaKapanSaja" ?
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "DimanaSaja", 
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      "KapanSaja", 
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ],
                )
              : Text(
                  item.name, 
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}