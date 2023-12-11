// To parse this JSON data, do
//
//     final venue = venueFromJson(jsonString);

import 'dart:convert';

List<Venue> venueFromJson(String str) => List<Venue>.from(json.decode(str).map((x) => Venue.fromJson(x)));

String venueToJson(List<Venue> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Venue {
    String model;
    int pk;
    Fields fields;

    Venue({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Venue.fromJson(Map<String, dynamic> json) => Venue(
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
    String personName;
    String phoneNumber;
    String bookName;
    String placeName;
    String mapLocation;
    String price;
    String address;
    String venueOpen;
    int rentBook;
    int returnBook;
    dynamic dateUse;
    dynamic dateReturn;

    Fields({
        required this.personName,
        required this.phoneNumber,
        required this.bookName,
        required this.placeName,
        required this.mapLocation,
        required this.price,
        required this.address,
        required this.venueOpen,
        required this.rentBook,
        required this.returnBook,
        required this.dateUse,
        required this.dateReturn,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        personName: json["person_name"],
        phoneNumber: json["phone_number"],
        bookName: json["book_name"],
        placeName: json["place_name"],
        mapLocation: json["map_location"],
        price: json["price"],
        address: json["address"],
        venueOpen: json["venue_open"],
        rentBook: json["rent_book"],
        returnBook: json["return_book"],
        dateUse: json["date_use"],
        dateReturn: json["date_return"],
    );

    Map<String, dynamic> toJson() => {
        "person_name": personName,
        "phone_number": phoneNumber,
        "book_name": bookName,
        "place_name": placeName,
        "map_location": mapLocation,
        "price": price,
        "address": address,
        "venue_open": venueOpen,
        "rent_book": rentBook,
        "return_book": returnBook,
        "date_use": dateUse,
        "date_return": dateReturn,
    };
}
