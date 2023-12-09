import 'dart:convert';

List<StationBook> stationBookFromJson(String str) => List<StationBook>.from(
    json.decode(str).map((x) => StationBook.fromJson(x)));

String stationBookToJson(List<StationBook> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StationBook {
  String model;
  int pk;
  Fields fields;

  StationBook({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory StationBook.fromJson(Map<String, dynamic> json) => StationBook(
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
