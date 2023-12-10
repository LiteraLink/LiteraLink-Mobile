import 'dart:convert';

List<BookVenue> bookVenueFromJson(String str) => List<BookVenue>.from(
    json.decode(str).map((x) => BookVenue.fromJson(x)));

String bookVenueToJson(List<BookVenue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookVenue {
  String model;
  int pk;
  Fields fields;

  BookVenue({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory BookVenue.fromJson(Map<String, dynamic> json) => BookVenue(
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
  int station;
  String bookId;
  String title;
  String authors;
  String displayAuthors;
  String description;
  String categories;
  String thumbnail;

  Fields({
    required this.station,
    required this.bookId,
    required this.title,
    required this.authors,
    required this.displayAuthors,
    required this.description,
    required this.categories,
    required this.thumbnail,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        station: json["station"],
        bookId: json["bookID"],
        title: json["title"],
        authors: json["authors"],
        displayAuthors: json["display_authors"],
        description: json["description"],
        categories: json["categories"],
        thumbnail: json["thumbnail"],
      );

  Map<String, dynamic> toJson() => {
        "station": station,
        "bookID": bookId,
        "title": title,
        "authors": authors,
        "display_authors": displayAuthors,
        "description": description,
        "categories": categories,
        "thumbnail": thumbnail,
      };
}
