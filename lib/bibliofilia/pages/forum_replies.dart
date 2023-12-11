import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/bibliofilia/models/forumReplies_models.dart';
import 'package:literalink/bibliofilia/models/forum_models.dart';
import 'package:literalink/main.dart';

class ForumRepliesPage extends StatefulWidget {
  final int forumId;
  const ForumRepliesPage({Key? key, required this.forumId}) : super(key: key);

  @override
  _ForumRepliesPageState createState() => _ForumRepliesPageState();
}

class _ForumRepliesPageState extends State<ForumRepliesPage> {
  late Future<List<ForumReplies>> replies;
  late Future<List<Forum>> head;

  @override
  void initState() {
    super.initState();
    replies = fetchReplies();
    head = fetchRepliesHead();
  }

  void deleteReply(int replyId) async {
    var url =
        Uri.parse('http://localhost:8000/bibliofilia/delete_replies_flutter/');

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

    if (response.statusCode == 204  ) {
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
        'http://localhost:8000/bibliofilia/get_ForumReply_flutter/${widget.forumId}/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return forumRepliesFromJson(response.body);
    } else {
      throw Exception('Failed to load replies');
    }
  }

  Future<List<Forum>> fetchRepliesHead() async {
    var url = Uri.parse(
        'http://localhost:8000/bibliofilia/get_ForumReplyHead_json_flutter/${widget.forumId}/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return forumFromJson(response.body);
    } else {
      throw Exception('Failed to load head');
    }
  }

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
          FutureBuilder<List<Forum>>(
            future: head,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text('Forum details not available.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                );
              } else {
                // Assuming the first item is the forum head
                Forum forumHead = snapshot.data!.first;
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        forumHead.fields.bookName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      forumHead.fields.userReview,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: buildForumRepliesList(),
          ),
        ],
      ),
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
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ForumReplies reply = snapshot.data![index];
              RepliesFields fields = reply.fields;
            

              return Container(
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
                                fields.forum.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                fields.username, // Displaying the username
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                fields.text,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                fields.timestamp.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed:() async  {
                                  setState(() {
                                    deleteReply(reply.pk);  
                                  });
                                }, // Call delete function
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
