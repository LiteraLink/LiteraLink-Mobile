import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/dimanasajakapansaja/components/input_field.dart';

import 'package:literalink/dimanasajakapansaja/models/station.dart';
import 'package:literalink/dimanasajakapansaja/pages/station_detail.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class DimanaSajaKapanSajaPage extends StatefulWidget {
  @override
  _DimanaSajaKapanSajaPageState createState() =>
      _DimanaSajaKapanSajaPageState();
}

class _DimanaSajaKapanSajaPageState extends State<DimanaSajaKapanSajaPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _rentableController = TextEditingController();
  final TextEditingController _returnableController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<List<Station>> fetchStation() async {
    var url =
        Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/station-json/');
    var response =
        await http.get(url, headers: {"Content-Type": "application/json"});

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<Station> listStation = [];

    for (var d in data) {
      if (d != null) {
        Station station = Station.fromJson(d);
        listStation.add(station);
      }
    }
    return listStation;
  }

  Future<void> _pickImage() async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selectedImage;
    });
  }

  String safeSubstring(String str, int start, int end) {
    if (str.length > end) {
      return str.substring(start, end);
    } else {
      return str;
    }
  }

  void resetTextFields() {
    _nameController.clear();
    _addressController.clear();
    _openingHoursController.clear();
    _rentableController.clear();
    _returnableController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('DimanaSajaKapanSaja'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildStationList(request),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Wrap(
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          addStationField(
                              _nameController, "Nama", _formKey, null),
                          addStationField(
                              _addressController, "Address", _formKey, null),
                          addStationField(_openingHoursController, "Jam Buka",
                              _formKey, null),
                          addStationField(
                              _rentableController, "Rentable", _formKey, null),
                          addStationField(_returnableController, "Returnable",
                              _formKey, null),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Pick Map Image'),
                              ),
                              submitFormBtn(),
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget buildStationList(request) {
    return FutureBuilder<List<Station>>(
      future: fetchStation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          return Column(
            children: snapshot.data!
                .map<Widget>((station) => Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        StationDetailPage(station: station))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Material(
                                color: LiteraLink.limeGreen,
                                child: Row(
                                  children: [
                                    SizedBox(
                                        width: 50,
                                        height: 60,
                                        child: Image.asset(
                                            "assets/images/DSKS_Icon.png")),
                                    const SizedBox(width: 15),
                                    SizedBox(
                                      width: 180,
                                      height: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(station.fields.openingHours),
                                          Text(
                                              '${safeSubstring(station.fields.name, 0, 20)}...'),
                                          Text(
                                              '${safeSubstring(station.fields.address, 0, 20)}...'),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text("Rentable"),
                                        Text(station.fields.returnable
                                            .toString())
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (loggedInUser.role == 'A')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SafeArea(
                                          child: Wrap(
                                            children: <Widget>[
                                              Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16,
                                                      vertical: 16),
                                                  child: Column(
                                                    children: [
                                                      addStationField(
                                                          _nameController,
                                                          "Nama",
                                                          _formKey,
                                                          station.fields.name),
                                                      addStationField(
                                                          _addressController,
                                                          "Address",
                                                          _formKey,
                                                          station
                                                              .fields.address),
                                                      addStationField(
                                                          _openingHoursController,
                                                          "Jam Buka",
                                                          _formKey,
                                                          station.fields
                                                              .openingHours),
                                                      addStationField(
                                                          _rentableController,
                                                          "Rentable",
                                                          _formKey,
                                                          station
                                                              .fields.rentable
                                                              .toString()),
                                                      addStationField(
                                                          _returnableController,
                                                          "Returnable",
                                                          _formKey,
                                                          station
                                                              .fields.returnable
                                                              .toString()),
                                                      Row(
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                _pickImage,
                                                            child: const Text(
                                                                'Pick Map Image'),
                                                          ),
                                                          editBtn(station),
                                                        ],
                                                      ),
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                    ).then((_) => resetTextFields());
                                  },
                                  child: Text("Edit")),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                  onPressed: () async {
                                    final response = await request.postJson(
                                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/del_station_flutter/",
                                        jsonEncode(<String, int>{
                                          'station_id': station.pk,
                                        }));
                                    if (response["status"] == "success") {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()),
                                      );
                                    }
                                  },
                                  child: Text("Hapus")),
                            ],
                          )
                      ],
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget submitFormBtn() {
    return InkWell(
        onTap: () async {
          var uri = Uri.parse(
              "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/add_station_flutter/");
          var request = http.MultipartRequest('POST', uri);

          request.fields['name'] = _nameController.text;
          request.fields['address'] = _addressController.text;
          request.fields['opening_hours'] = _openingHoursController.text;
          request.fields['rentable'] = _rentableController.text;
          request.fields['returnable'] = _returnableController.text;

          if (_imageFile != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'map_location',
              _imageFile!.path,
            ));
          }

          var response = await request.send();

          if (response.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LiteraLink.tealDeep),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: LiteraLink.limeGreen),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Tambah",
                    style: TextStyle(
                        color: LiteraLink.tealDeep,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.add,
                    color: LiteraLink.limeGreen,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget editBtn(station) {
    return InkWell(
        onTap: () async {
          var uri = Uri.parse(
              "https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja/edit_station_flutter/${station.pk}/");
          var request = http.MultipartRequest('POST', uri);

          request.fields['name'] = _nameController.text;
          request.fields['address'] = _addressController.text;
          request.fields['opening_hours'] = _openingHoursController.text;
          request.fields['rentable'] = _rentableController.text;
          request.fields['returnable'] = _returnableController.text;

          if (_imageFile != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'map_location',
              _imageFile!.path,
            ));
          }

          var response = await request.send();

          if (response.statusCode == 200) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LiteraLink.tealDeep),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: LiteraLink.limeGreen),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Submit",
                    style: TextStyle(
                        color: LiteraLink.tealDeep,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.add,
                    color: LiteraLink.limeGreen,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
