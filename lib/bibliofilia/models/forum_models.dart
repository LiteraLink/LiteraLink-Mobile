// To parse this JSON data, do
//
//     final forum = forumFromJson(jsonString);

import 'dart:convert';

List<Forum> forumFromJson(String str) =>
    List<Forum>.from(json.decode(str).map((x) => Forum.fromJson(x)));

String forumToJson(List<Forum> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Forum {
  String model;
  int pk;
  Fields fields;

  Forum({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int user;
  String bookName;
  String forumsDescription;
  String bookPicture;
  String userReview;
  int repliesTotal;
  DateTime dateOfPosting;
  String username;

  Fields({
    required this.user,
    required this.bookName,
    required this.forumsDescription,
    required this.bookPicture,
    required this.userReview,
    required this.repliesTotal,
    required this.dateOfPosting,
    required this.username,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        bookName: json["BookName"],
        forumsDescription: json["forumsDescription"],
        bookPicture: json["bookPicture"],
        userReview: json["userReview"],
        repliesTotal: json["repliesTotal"],
        dateOfPosting: DateTime.parse(json["dateOfPosting"]),
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "BookName": bookName,
        "forumsDescription": forumsDescription,
        "bookPicture": bookPicture,
        "userReview": userReview,
        "repliesTotal": repliesTotal,
        "dateOfPosting":
            "${dateOfPosting.year.toString().padLeft(4, '0')}-${dateOfPosting.month.toString().padLeft(2, '0')}-${dateOfPosting.day.toString().padLeft(2, '0')}",
        "username": username,
      };
}
