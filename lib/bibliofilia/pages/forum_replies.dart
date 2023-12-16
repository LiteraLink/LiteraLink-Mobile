import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bibliofilia/models/forumReplies_models.dart';
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/bibliofilia/pages/createReplies.dart';

class ForumRepliesPage extends StatefulWidget {
  final int forumId;
  final Forum forum;
  const ForumRepliesPage({Key? key, required this.forumId, required this.forum}) : super(key: key);

  @override
  _ForumRepliesPageState createState() => _ForumRepliesPageState();
}

class _ForumRepliesPageState extends State<ForumRepliesPage> {
  late Future<List<ForumReplies>> replies;
  late Future<List<Forum>> head;
  late final User user;

  @override
  void initState() {
    super.initState();
    replies = fetchReplies();
    head = fetchRepliesHead();
    user = loggedInUser;
  }

  String safeSubstring(String str, int start, int end) {
    if (str.length > end) {
      return str.substring(start, end);
    } else {
      return str;
    }
  }

  void deleteReply(int replyId) async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/delete_replies_flutter/');

    // Assuming you have a way to get the current username. Replace with actual username.
    String currentUsername =
        "currentUser"; // Replace with actual username logic

    var response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'reply_id': replyId,
        'username': currentUsername,
      }),
    );

    if (response.statusCode == 204) {
      // Handle successful deletion
      setState(() {
        replies = fetchReplies(); // Refresh the replies list after deletion
        head = fetchRepliesHead();
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

  Future<List<ForumReplies>> fetchReplies() async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/get_ForumReply_flutter/${widget.forumId}/');
    var response = await http.get(url);

    return forumRepliesFromJson(response.body);
  }

  Future<List<Forum>> fetchRepliesHead() async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/bibliofilia/get_ForumReplyHead_json_flutter/${widget.forumId}/');
    var response = await http.get(url);

    return forumFromJson(response.body);
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
                            width: 25,
                          ),
                          Flexible(
                            child: Text(
                              widget.forum.fields.bookName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFFFFFFF),
                              ),
                              // maxLines and overflow are not needed if the text should wrap indefinitely
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 250,
                    child: Container(
                        height: MediaQuery.of(context).size.height - 160,
                        decoration: const BoxDecoration(
                            color: Color(0xFFEFF5ED),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(38),
                                topRight: Radius.circular(38))),
                        child: Column(
                          children: [
                            const SizedBox(height: 130),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              width: MediaQuery.of(context).size.width,
                            ),
                            buildForumRepliesList(),
                          ],
                        )),
                  ),
                 Positioned(
                    top: 160,
                    left: 100,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0), // Ini akan membulatkan sudut gambar dan container
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color for the book container
                            borderRadius: BorderRadius.circular(20.0), // This matches the ClipRRect border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                width: 55,
                              ),
                              Image.network(
                                widget.forum.fields.bookPicture,
                                fit: BoxFit.cover, // This will scale the image based on the size of its container
                              ),
                              // Add other widgets for the book title, author, etc.
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
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
                      vertical: 18,
                      horizontal: 16), // Reduced horizontal margin
                  child: const FittedBox(
                    // This will scale down the text and icon to fit within the FAB
                    child: Text(
                      "Reply Forum ini",
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
                            CreateReplies(user: user, forumId: widget.forumId, forum: widget.forum,)),
                  );
                },
              ),
            ))
      );
  }

  Widget buildForumRepliesList() {
    return FutureBuilder<List<ForumReplies>>(
      future: replies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("No replies available.");
        } else {
          return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const AlwaysScrollableScrollPhysics(),
                children: snapshot.data!
                    .map<Widget>((reply) => Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
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
                                          child: Container(),
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
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 18),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: const Color(
                                                          0xFFEB6645)),
                                                  child: Text(
                                                    reply.fields.forum
                                                        .toString(),
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
                                                  reply.fields
                                                      .username, // Displaying the username
                                                  style: const TextStyle(
                                                      color: Color(0xFF252525),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  reply.fields
                                                      .text, // Replace with your forum authors field
                                                  style: TextStyle(
                                                      color: const Color(
                                                              0xFF252525)
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
                        ))
                    .toList(),
              ));
        }
      },
    );
  }
}
