import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/dimanasajakapansaja/models/station.dart';
import 'package:literalink/dimanasajakapansaja/models/station_book.dart';
import 'package:literalink/dimanasajakapansaja/models/user_book.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class StationDetailPage extends StatefulWidget {
  final Station station;
  const StationDetailPage({super.key, required this.station});

  @override
  _StationDetailPageState createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  static const String baseUrl =
      'https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja';

  Set<String> categories = {"All"};
  String selectedCategory = "All";
  String? selectedCategoryBtn;

  Future<List<StationBook>> fetchStationBook() async {
    var url = Uri.parse('$baseUrl/station-book-json/${widget.station.pk}/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<StationBook> listBook = [];

    for (var d in data) {
      if (d != null) {
        StationBook book = StationBook.fromJson(d);
        listBook.add(book);
        if (book.fields.categories != "None") {
          categories.add(book.fields.categories);
        }
      }
    }
    return listBook;
  }

  Future<List<UserBook>> fetchRentedBook() async {
    var url = Uri.parse('$baseUrl/user_book_json/${loggedInUser.username}/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<UserBook> listRentedBook = [];

    for (var d in data) {
      if (d != null) {
        UserBook book = UserBook.fromJson(d);
        listRentedBook.add(book);
      }
    }
    return listRentedBook;
  }

  void setSelectedCategory(String category) {
    setState(() => selectedCategory = category);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 37,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: LiteraLink.whiteGreen,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Row(
                      children: [
                        SizedBox(width: 5),
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/media/${widget.station.fields.mapLocation}/"),
                    const SizedBox(height: 10),
                    Text("Open ${widget.station.fields.openingHours}"),
                    Text(
                      widget.station.fields.name,
                      style: const TextStyle(
                          fontSize: 30, color: Colors.black),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.add_location_alt_outlined),
                        SizedBox(
                          width: 300,
                          child: Text(widget.station.fields.address),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.info),
                        Text("Information Status")
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const Text(
                                "Rentable",
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                widget.station.fields.rentable.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              const Text(
                                "Returnable",
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                widget.station.fields.returnable.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SafeArea(
                                    child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: const Text(
                                          "Buku yang kamu pinjam",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          child: FutureBuilder(
                                            future: fetchRentedBook(),
                                            builder: (context, snapshot) {
                                              if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              } else if (snapshot
                                                  .hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else if (!snapshot
                                                  .hasData) {
                                                return const Text(
                                                    "Tidak ada data item.");
                                              } else {
                                                return SingleChildScrollView(
                                                  child: Column(
                                                    children: snapshot.data!
                                                        .map<Widget>(
                                                            (book) =>
                                                                Container(
                                                                  width:
                                                                      200,
                                                                  margin: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(10),
                                                                    child:
                                                                        Material(
                                                                      color:
                                                                          LiteraLink.lightGreen,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Image.network(
                                                                            book.fields.thumbnail,
                                                                          ),
                                                                          Text(book.fields.title),
                                                                          Text(book.fields.displayAuthors),
                                                                          ElevatedButton(
                                                                              onPressed: () async {
                                                                                final response = await request.postJson(
                                                                                    "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/return_book_flutter/${widget.station.pk}/${book.pk}/",
                                                                                    jsonEncode(<String, String>{
                                                                                      'book_id': book.fields.bookId,
                                                                                      'title': book.fields.title,
                                                                                      'authors': book.fields.authors,
                                                                                      'display_authors': book.fields.displayAuthors,
                                                                                      'description': book.fields.description,
                                                                                      'categories': book.fields.categories,
                                                                                      'thumbnail': book.fields.thumbnail,
                                                                                    }));
                                                                                if (response["status"] == 'success') {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                    content: Text("Silakan ambil buku pada tray!"),
                                                                                  ));
                                                                                  Navigator.pushReplacement(
                                                                                    context,
                                                                                    MaterialPageRoute(builder: (context) => const HomePage()),
                                                                                  );
                                                                                }
                                                                              },
                                                                              child: Text("Kembalikan")), // Child parameter for ElevatedButton
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                        .toList(),
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: const Text("Kembalikan"),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 10),
              buildCategoryList(),
              const SizedBox(height: 10),
              buildBookList(request)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBookList(request) {
    return FutureBuilder<List<StationBook>>(
      future: fetchStationBook(),
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
                          color: LiteraLink.lightGreen,
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
                                        color:
                                            Color.fromARGB(255, 249, 241, 241),
                                      ),
                                    ),
                                    Text(
                                      book.fields.title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(
                                      book.fields.displayAuthors,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            final response = await request.postJson(
                                                "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/rent_book_flutter/${book.pk}/",
                                                jsonEncode(<String, String>{
                                                  'book_id': book.fields.bookId,
                                                  'title': book.fields.title,
                                                  'authors':
                                                      book.fields.authors,
                                                  'display_authors': book
                                                      .fields.displayAuthors,
                                                  'description':
                                                      book.fields.description,
                                                  'categories':
                                                      book.fields.categories,
                                                  'thumbnail':
                                                      book.fields.thumbnail,
                                                  'username':
                                                      loggedInUser.username,
                                                  'station_id': widget
                                                      .station.pk
                                                      .toString(),
                                                }));
                                            if (response["status"] ==
                                                'success') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Silakan ambil buku pada tray!"),
                                              ));
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage()),
                                              );
                                            }
                                          },
                                          child: ClipRRect(
                                            child: Container(
                                              width: 70,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Align(
                                                child: Text(
                                                  "Pinjam",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        InkWell(
                                          onTap: () => print('abc'),
                                          child: ClipRRect(
                                            child: Container(
                                              width: 70,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Align(
                                                child: Text(
                                                  "Lihat",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget buildCategoryList() {
    return FutureBuilder<List<StationBook>>(
      future: fetchStationBook(),
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
                  child: ElevatedButton(
                    onPressed: () => setSelectedCategory(category),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedCategory == category
                          ? LiteraLink.whiteGreen
                          : const Color(
                              0xFFD0E2AB), // Change color when selected
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
}
