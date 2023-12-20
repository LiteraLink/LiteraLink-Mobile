// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/dimanasajakapansaja/models/station.dart';
import 'package:literalink/dimanasajakapansaja/models/user_book.dart';
import 'package:literalink/homepage/components/navbar.dart';
import 'package:literalink/homepage/detail_book.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class StationDetailPage extends StatefulWidget {
  final Station station;
  const StationDetailPage({super.key, required this.station});

  @override
  State<StationDetailPage> createState() => _StationDetailPageState();
}

class _StationDetailPageState extends State<StationDetailPage> {
  static const String baseUrl =
      'https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja';

  Set<String> categories = {"All"};
  String selectedCategory = "All";
  String? selectedCategoryBtn;
  GlobalKey categoryListKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  Future<List<Book>> fetchStationBook() async {
    var url = Uri.parse('$baseUrl/station-book-json/${widget.station.pk}/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      List<Book> listBook = [];

      for (var d in data) {
        if (d != null) {
          Book book = Book.fromJson(d);
          listBook.add(book);
          if (book.fields.categories != "None") {
            categories.add(book.fields.categories);
          }
        }
      }
      return listBook;
    } else {
      throw Exception('Failed to fetch station book');
    }
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
      backgroundColor: const Color(0xFFEEF5ED),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFFA8A8A8),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.station.fields.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 25, color: Color(0xFF252525)),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFFFFFFF),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          "https://literalink-e03-tk.pbp.cs.ui.ac.id/media/${widget.station.fields.mapLocation}/",
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset('assets/images/placeholder.png',
                                fit: BoxFit.cover);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/Time Circle.svg",
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Open ${widget.station.fields.openingHours}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.station.fields.name,
                      style: const TextStyle(
                          fontSize: 25, color: Color(0xFF252525)),
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        widget.station.fields.address,
                        style: const TextStyle(color: Color(0xFF7C7C7C)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFE6F3EC)),
                                    child: const Icon(
                                      Icons.arrow_upward_rounded,
                                      color: Color(0xFF018845),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Rentable",
                                    style: TextStyle(
                                        color: Color(0xFF018845),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                widget.station.fields.rentable.toString(),
                                style: const TextStyle(
                                    fontSize: 35,
                                    color: Color(0xFF018845),
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                "Books",
                                style: TextStyle(
                                    color: Color(0xFF018845), fontSize: 16),
                              ),
                              InkWell(
                                  onTap: () {
                                    final context =
                                        categoryListKey.currentContext;
                                    if (context != null) {
                                      final box = context.findRenderObject()
                                          as RenderBox;
                                      final position =
                                          box.localToGlobal(Offset.zero);
                                      final offset = position.dy;

                                      scrollController.animateTo(
                                        offset,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  child: loggedInUser.role == 'M'
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF018845),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: const Text(
                                            "Pinjam",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Container()),
                            ],
                          ),
                        ),
                        const SizedBox(width: 21),
                        Container(
                          width: 130,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFFF0ED)),
                                    child: const Icon(
                                      Icons.arrow_downward_rounded,
                                      color: Color(0xFFEB6645),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Returnable",
                                    style: TextStyle(
                                        color: Color(0xFFEB6645),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                widget.station.fields.returnable.toString(),
                                style: const TextStyle(
                                    color: Color(0xFFEB6645),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35),
                              ),
                              const Text(
                                "Slots",
                                style: TextStyle(
                                    color: Color(0xFFEB6645),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              InkWell(
                                  onTap: () => showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SafeArea(
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: const Text(
                                                      "Buku yang kamu pinjam",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FutureBuilder(
                                                      future: fetchRentedBook(),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
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
                                                          return ListView
                                                              .builder(
                                                            itemCount: snapshot
                                                                .data!.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              var book = snapshot
                                                                  .data![index];
                                                              return Container(
                                                                width: 200,
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 10,
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  child:
                                                                      Material(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Image
                                                                            .network(
                                                                          book.fields
                                                                              .thumbnail,
                                                                        ),
                                                                        Text(book
                                                                            .fields
                                                                            .title),
                                                                        Text(book
                                                                            .fields
                                                                            .displayAuthors),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () async {
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
                                                                            if (response["status"] ==
                                                                                'success') {
                                                                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                                content: Text("Silakan ambil buku pada tray!"),
                                                                              ));
                                                                              Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(builder: (context) => PersistentBottomNavPage()),
                                                                              );
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text("Kembalikan"),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  child: loggedInUser.role == 'M'
                                      ? Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: const Color(0xFFEB6645),
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: const Text(
                                            "Kembalikan",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : Container()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(key: categoryListKey, height: 24),
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
    return FutureBuilder<List<Book>>(
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
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.all(20.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Material(
                          color: const Color(0xFFFFFFFF),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child:
                                          Image.network(book.fields.thumbnail),
                                    ),
                                    const SizedBox(width: 18),
                                    Expanded(
                                      child: Column(
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
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Color(0xFFFFFFFF),
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
                                                color: const Color(0xFF252525)
                                                    .withOpacity(0.6)),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                color: const Color(0xFFDAE9D8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final response = await request.postJson(
                                            "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/rent_book_flutter/${book.pk}/",
                                            jsonEncode(<String, String>{
                                              'book_id': book.fields.bookId,
                                              'title': book.fields.title,
                                              'authors': book.fields.authors,
                                              'display_authors':
                                                  book.fields.displayAuthors,
                                              'description':
                                                  book.fields.description,
                                              'categories':
                                                  book.fields.categories,
                                              'thumbnail':
                                                  book.fields.thumbnail,
                                              'username': loggedInUser.username,
                                              'station_id':
                                                  widget.station.pk.toString(),
                                            }));
                                        if (response["status"] == 'success') {
                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(SnackBar(
                                                backgroundColor:
                                                    LiteraLink.redOrange,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                content: const Text(
                                                    "Silakan ambil buku pada tray!")));
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PersistentBottomNavPage()),
                                          );
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 36),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: const Color(0xFF005F3D)),
                                        child: const Text(
                                          "Pinjam",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () => Navigator.of(context,
                                              rootNavigator: true)
                                          .push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailBookPage(book: book)),
                                      ),
                                      child: ClipRRect(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 44),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFBAD4C2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Text(
                                            "Lihat",
                                            style: TextStyle(
                                                color: Color(0xFF005F3D),
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
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
    return SizedBox(
      child: FutureBuilder<List<Book>>(
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
                            ? const Color(0xFF018845)
                            : const Color(0xFFD6EADC),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: TextStyle(
                              color: selectedCategory == category
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFF018845)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
