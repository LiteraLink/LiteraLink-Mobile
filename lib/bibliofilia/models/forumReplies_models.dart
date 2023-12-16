// To parse this JSON data, do
//
//     final forumReplies = forumRepliesFromJson(jsonString);

import 'dart:convert';

List<ForumReplies> forumRepliesFromJson(String str) => List<ForumReplies>.from(json.decode(str).map((x) => ForumReplies.fromJson(x)));

String forumRepliesToJson(List<ForumReplies> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ForumReplies {
    String model;
    int pk;
    RepliesFields fields;

    ForumReplies({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ForumReplies.fromJson(Map<String, dynamic> json) => ForumReplies(
        model: json["model"],
        pk: json["pk"],
        fields: RepliesFields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class RepliesFields{
    int forum;
    int user;
    String username;
    String text;
    String pictureReplies;
    DateTime timestamp;

    RepliesFields({
        required this.forum,
        required this.user,
        required this.username,
        required this.text,
        required this.pictureReplies,
        required this.timestamp,
    });

    factory RepliesFields.fromJson(Map<String, dynamic> json) => RepliesFields(
        forum: json["forum"],
        user: json["user"],
        username: json["username"],
        text: json["text"],
        pictureReplies: json["pictureReplies"],
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "forum": forum,
        "user": user,
        "username": username,
        "text": text,
        "pictureReplies": pictureReplies,
        "timestamp": "${timestamp.year.toString().padLeft(4, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}",
    };
}
