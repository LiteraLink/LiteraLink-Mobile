// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/bibliofilia/pages/chooseBook.dart';
import 'package:literalink/bibliofilia/pages/createForum.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/main.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late final User user;
  TextEditingController searchController = TextEditingController();
  Set<String> names = {"All"};
  String selectedName = "All";

  @override
  void initState() {
    super.initState();
    user = loggedInUser;
  }

  Future<List<Forum>> fetchItem() async {
    var url = Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/get_forum/');
    var response = await http.get(url);

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Forum> listForum = [];

    for (var d in data) {
      if (d != null) {
        Forum forum = Forum.fromJson(d);
        listForum.add(forum);
      }
    }
    return listForum;
  }

  // void setSelectedCategory(String category) {
  //   setState(() => selectedCategory = category);
  // }
  void setSelectedName() {
    setState(() {
      // Jika searchController.text tidak kosong, gunakan teks tersebut
      // jika tidak, set selectedName ke "All"
      selectedName =
          searchController.text.isEmpty ? "All" : searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
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
                      "Bibliofilia",
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: Text(
                              'Tempat untuk berbagi pengalaman membaca buku',
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
            // const SizedBox(
            //     width: 11,
            // ),
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
                              child: IconButton(
                                icon: const Icon(
                                  Icons.filter_alt_rounded,
                                  color: Colors.white,
                                ),
                                onPressed: setSelectedName,
                              ))
                        ],
                      ),
                    ),
                    // const SizedBox(height: 18),
                    buildForumList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
            right: 12, bottom: 16), // Adjust the padding as needed
        child: SizedBox(
          width:
              180, // You may adjust this width if it's too wide for the screen
          height: 57,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFEB6645),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  vertical: 18, horizontal: 16), // Reduced horizontal margin
              child: const FittedBox(
                // This will scale down the text and icon to fit within the FAB
                child: Text(
                  "Buat Forum",
                  style: TextStyle(color: Color(0xFFFFFFFF)),
                  overflow:
                      TextOverflow.ellipsis, // Use ellipsis to handle overflow
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateForum(user: user)),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildForumList() {
    return FutureBuilder<List<Forum>>(
      future: fetchItem(), // Replace with your method that fetches the forums
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
              physics: const AlwaysScrollableScrollPhysics(),
              children: snapshot.data!
                  .where((forum) =>
                      selectedName.toLowerCase() == "all" ||
                      (forum.fields.bookName.toLowerCase().contains(selectedName.toLowerCase())))
                  .map<Widget>((forum) => Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForumRepliesPage(
                                        forumId: forum.pk,
                                      )
                                    )
                                  );
                                },
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Material(
                            color: const Color(0xFFFFFFFF),
                            child: Container(
                              margin: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child:
                                            forum.fields.bookPicture != null &&
                                                    forum.fields.bookPicture
                                                        .isNotEmpty
                                                ? Image.network(
                                                    forum.fields.bookPicture)
                                                : Container(),
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
                                                  forum.fields
                                                      .forumsDescription, // Replace with your forum categories field
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
                                                forum.fields
                                                    .bookName, // Replace with your forum title field
                                                style: const TextStyle(
                                                    color: Color(0xFF252525),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                              const SizedBox(height: 12),
                                              Text(
                                                forum.fields
                                                    .username, // Replace with your forum authors field
                                                style: TextStyle(
                                                    color:
                                                        const Color(0xFF252525)
                                                            .withOpacity(0.6)),
                                              ),
                                            ],
                                          ),
                                          
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
