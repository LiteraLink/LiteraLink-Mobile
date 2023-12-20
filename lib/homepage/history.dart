import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';

import 'package:literalink/dimanasajakapansaja/models/user_book.dart';
import 'package:literalink/homepage/profile.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _DimanaSajaKapanSajaPageState();
}

class _DimanaSajaKapanSajaPageState extends State<HistoryPage> {
  static const String baseUrl = 'https://literalink-e03-tk.pbp.cs.ui.ac.id';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(
        'id_ID', null); // Ini bisa juga diatur untuk locale tertentu
  }

  Future<List<UserBook>> fetchHistory() async {
    var url = Uri.parse('$baseUrl/auth/get-history/${loggedInUser.username}');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<UserBook> userBookList = [];

    for (var d in data) {
      if (d != null) {
        UserBook book = UserBook.fromJson(d);
        userBookList.add(book);
      }
    }
    return userBookList.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final containerHeight = MediaQuery.of(context).size.height - 160;
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
            top: 80,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "History Orders",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFFFFF),
                      ),
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
          ),
          Positioned(
              top: 150,
              height: containerHeight,
              child: buildStationList(request)),
        ],
      ),
    );
  }

  Widget buildStationList(request) {
    return FutureBuilder<List<UserBook>>(
      future: fetchHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
                color: Color(0xFFEFF5ED),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38))),
            child: ListView(
              padding: EdgeInsets.only(
                top: 0,
                bottom: MediaQuery.of(context).padding.bottom + 70,
                left: 0,
                right: 0,
              ),
              physics: const AlwaysScrollableScrollPhysics(),
              children: snapshot.data!
                  .map<Widget>((book) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 14),
                        child: InkWell(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Column(
                                      children: [
                                        Text(DateFormat('d MMM, HH:mm', 'id_ID')
                                            .format(DateTime.parse(book
                                                    .fields.dateAdded
                                                    .toString())
                                                .toUtc()
                                                .add(
                                                    const Duration(hours: 7)))),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 30),
                                          decoration: BoxDecoration(
                                            color: book.fields.feature == "DSKS"
                                                ? const Color(0xFFEB6645)
                                                : book.fields.feature == "A"
                                                    ? const Color(0xFF005F3D)
                                                    : const Color(0xFF018845),
                                            borderRadius:
                                                BorderRadius.circular(36),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4),
                                            child: Image.asset(
                                              width: 50,
                                              height: 50,
                                              book.fields.feature == "DSKS"
                                                  ? "assets/images/DSKS_Icon.png"
                                                  : book.fields.feature == "A"
                                                      ? "assets/images/Antar_Icon.png"
                                                      : "assets/images/bacaditempat_logo.png",
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          book.fields.categories,
                                          style: const TextStyle(
                                            color: Color(0xFFEB6645),
                                          ),
                                          overflow: TextOverflow
                                              .ellipsis, // Menggunakan elipsis jika terjadi overflow
                                          maxLines: 1, // Maksimal satu baris
                                        ),
                                        Text(
                                          book.fields.title,
                                          style: const TextStyle(
                                            color: Color(0xFF252525),
                                            fontSize: 20,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          book.fields.authors,
                                          style: const TextStyle(
                                            color: Color(0xFF7C7C7C),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 21),
                                            decoration: const BoxDecoration(
                                                color: Color(0xFFE6F3EC),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(20))),
                                            child: Column(
                                              children: [
                                                Text(
                                                  book.fields.feature == "DSKS"
                                                      ? "Dimana\nSaja\nKapan\nSaja"
                                                      : book.fields.feature ==
                                                              "A"
                                                          ? "Antar"
                                                          : "BacaDiTempat",
                                                  style: const TextStyle(
                                                    color: Color(0xFF018845),
                                                  ),
                                                ),
                                              ],
                                            ),
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
