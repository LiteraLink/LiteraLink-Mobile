import 'dart:convert';

List<BookUser> bookUserFromJson(String str) =>
    List<BookUser>.from(json.decode(str).map((x) => BookUser.fromJson(x)));

String bookUserToJson(List<BookUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookUser {
  String model;
  int pk;
  Fields fields;

  BookUser({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory BookUser.fromJson(Map<String, dynamic> json) => BookUser(
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
  String bookId;
  String title;
  String authors;
  String displayAuthors;
  String description;
  String categories;
  String thumbnail;
  String feature;

  Fields({
    required this.user,
    required this.bookId,
    required this.title,
    required this.authors,
    required this.displayAuthors,
    required this.description,
    required this.categories,
    required this.thumbnail,
    required this.feature,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        bookId: json["bookID"],
        title: json["title"],
        authors: json["authors"],
        displayAuthors: json["display_authors"],
        description: json["description"],
        categories: json["categories"],
        thumbnail: json["thumbnail"],
        feature: json["feature"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "bookID": bookId,
        "title": title,
        "authors": authors,
        "display_authors": displayAuthors,
        "description": description,
        "categories": categories,
        "thumbnail": thumbnail,
        "feature": feature,
      };
}
