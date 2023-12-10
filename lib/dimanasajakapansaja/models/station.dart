import 'dart:convert';

List<Station> stationFromJson(String str) =>
    List<Station>.from(json.decode(str).map((x) => Station.fromJson(x)));

String stationToJson(List<Station> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Station {
  String model;
  int pk;
  Fields fields;

  Station({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
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
        name: json["name"],
        address: json["address"],
        openingHours: json["opening_hours"],
        rentable: json["rentable"],
        returnable: json["returnable"],
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
