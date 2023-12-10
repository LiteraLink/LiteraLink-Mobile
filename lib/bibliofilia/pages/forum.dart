import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/bibliofilia/pages/forum_replies.dart';
import 'package:literalink/main.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Forum>> fetchItem() async {
    var url = Uri.parse('http://localhost:8000/bibliofilia/get_forum/');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LiteraLink",
            style: TextStyle(color: LiteraLink.tealDeep)),
        backgroundColor: LiteraLink.limeGreen,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text('Feature',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Expanded(
            // Use Expanded here
            child: buildForumList(),
          ),
        ],
      ),
    );
  }

  Widget buildForumList() {
    return FutureBuilder<List<Forum>>(
      future: fetchItem(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data forum.");
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Forum forum = snapshot.data![index];
              Fields fields = forum.fields;

              // You can modify this part as per your UI design
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumRepliesPage(
                            forumId:
                                forum.pk), // Assuming 'forum.id' is available
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Material(
                        color: LiteraLink.limeGreen, // Change as needed
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fields.bookName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    fields.forumsDescription,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    fields.username, // Displaying the username
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  // Add more fields as required
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                );
            },
          );
        }
      },
    );
  }
}
