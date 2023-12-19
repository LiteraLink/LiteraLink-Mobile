// To parse this JSON data, do
//
//     final bookVenue = bookVenueFromJson(jsonString);

import 'dart:convert';

import 'package:literalink/authentication/models/user.dart';

List<BookVenue> bookVenueFromJson(String str) => List<BookVenue>.from(json.decode(str).map((x) => BookVenue.fromJson(x)));

String bookVenueToJson(List<BookVenue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookVenue {
    // Model model;
    int pk;
    Fields fields;

    BookVenue({
        // required this.model,
        required this.pk,
        required this.fields,
    });

    factory BookVenue.fromJson(Map<String, dynamic> json) => BookVenue(
        // model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        // "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String bookId;
    String title;
    String authors;
    String displayAuthors;
    String description;
    String categories;
    String thumbnail;
    String username;
    bool returnBook;
    
    // String username;

    Fields({
        required this.bookId,
        required this.title,
        required this.authors,
        required this.displayAuthors,
        required this.description,
        required this.categories,
        required this.thumbnail,
        required this.username,
        this.returnBook = true,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        bookId: json["bookID"],
        title: json["title"],
        authors: json["authors"],
        displayAuthors: json["display_authors"],
        description: json["description"],
        categories: json["categories"],
        thumbnail: json["thumbnail"],
        username: loggedInUser.username, // Inisialisasi username dengan loggedInUser.fullName
    );


    Map<String, dynamic> toJson() => {
        "bookID": bookId,
        "title": title,
        "authors": authors,
        "display_authors": displayAuthors,
        "description": description,
        "categories": categories,
        "thumbnail": thumbnail,
    };
}

enum Model {
    MAIN_BOOK
}

final modelValues = EnumValues({
    "main.book": Model.MAIN_BOOK
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
