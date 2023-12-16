// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/bibliofilia/pages/createForum.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
    late Future<List<Forum>> forum;

  
  // for searching books
  TextEditingController searchController = TextEditingController();

  //for animation
  double topPosition = -200;
  double topPosition1 = -200;
  double topForWhiteContainer = 1000;
  bool isButtonPressed = false;


  @override
  void initState() {
    super.initState();
    forum = fetchItem();
  }
  void deleteForum(int forumId) async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/delete_forum_flutter/');

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'forum_id': forumId,
        // 'username': currentUsername,
      }),
    );

    if (response.statusCode == 204) {
      // Handle successful deletion
      setState(() {
        forum = fetchItem(); // Refresh the replies list after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reply deleted successfully')),
      );
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete reply: ${response.body}')),
      );
    }
  }

  Future<List<Forum>> fetchItem() async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/get_forum/');
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

  void toggleAnimation() {
    setState(() {
      isButtonPressed = true;
      topPosition = 60; // Posisi akhir elemen atas
      topPosition1 = 110;
      topForWhiteContainer = 190; // Posisi akhir container putih
    });
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
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/bibliofilia_figure.png', // Replace with your image asset path
                width: 310, // Set your desired image width
                height: 295, // Set your desired image height
              ),
              const SizedBox(
                  height: 20), // Provides space between the image and the text
              const Text(
                'Bibliofilia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                  height: 16), // Provides space between the text and the button
              InkWell(
                  onTap: () async {
                    toggleAnimation();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 7),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 48),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: const Color(0xFFFFFFFF)),
                      child: const Text(
                        "Liat Forum",
                        style: TextStyle(color: Color(0xFF005F3D)),
                      ))),
            ],
          )),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: topPosition,
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
                    width: 90,
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
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: topPosition1,
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
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            top: topForWhiteContainer,
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
                  buildForumList(),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            right: 16,
            bottom: isButtonPressed ? 16 : -1000, // Animasi posisi FAB
            child: Padding(
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
                        vertical: 18,
                        horizontal: 16), // Reduced horizontal margin
                    child: const FittedBox(
                      // This will scale down the text and icon to fit within the FAB
                      child: Text(
                        "Buat Forum",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                        overflow: TextOverflow
                            .ellipsis, // Use ellipsis to handle overflow
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreateForum(user: loggedInUser)),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForumList() {
    return FutureBuilder<List<Forum>>(
      future: forum,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data item.");
        } else {
          var filteredList = snapshot.data!.where((forum) {
            return forum.fields.bookName
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
          }).toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return buildForumItem(filteredList[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget buildForumItem(Forum forum) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForumRepliesPage(
                        forumId: forum.pk, forum: forum,
                      )));
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: forum.fields.bookPicture.isNotEmpty
                            ? Image.network(forum.fields.bookPicture)
                            : Container(),
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
                                    color: const Color(0xFFEB6645)),
                                child: Text(
                                  forum.fields
                                      .forumsDescription, // Replace with your forum categories field
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 249, 241, 241),
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
                                    color: const Color(0xFF252525)
                                        .withOpacity(0.6)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (loggedInUser.role == 'A')
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed:() async  {
                          setState(() {
                            deleteForum(forum.pk);  
                          });
                        }, //
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
