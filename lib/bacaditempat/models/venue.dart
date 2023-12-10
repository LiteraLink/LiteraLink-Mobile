import 'dart:convert';

List<Venue> venueFromJson(String str) =>
    List<Venue>.from(json.decode(str).map((x) => Venue.fromJson(x)));

String venueToJson(List<Venue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  String name;
  String address;
  String openingHours;
  int rentable;
  int returnable;
  String mapLocation;
  String? localImagePath;

  Fields({
    required this.name,
    required this.address,
    required this.openingHours,
    required this.rentable,
    required this.returnable,
    required this.mapLocation,
    this.localImagePath,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["place_name"],
        address: json["address"],
        openingHours: json["venue_open"],
        rentable: json["rent_book"],
        returnable: json["return_book"],
        mapLocation: json["map_location"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "opening_hours": openingHours,
        "rentable": rentable,
        "returnable": returnable,
        "map_location": mapLocation,
      };
}
