import 'dart:convert';

List<UserBook> userBookFromJson(String str) =>
    List<UserBook>.from(json.decode(str).map((x) => UserBook.fromJson(x)));

String userBookToJson(List<UserBook> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserBook {
  String model;
  int pk;
  Fields fields;

  UserBook({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory UserBook.fromJson(Map<String, dynamic> json) => UserBook(
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
