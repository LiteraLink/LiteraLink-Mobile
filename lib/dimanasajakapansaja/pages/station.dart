import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/dimanasajakapansaja/components/input_field.dart';

import 'package:literalink/dimanasajakapansaja/models/station.dart';
import 'package:literalink/dimanasajakapansaja/pages/station_detail.dart';
import 'package:literalink/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';

class DimanaSajaKapanSajaPage extends StatefulWidget {
  const DimanaSajaKapanSajaPage({super.key});

  @override
  State<DimanaSajaKapanSajaPage> createState() =>
      _DimanaSajaKapanSajaPageState();
}

class _DimanaSajaKapanSajaPageState extends State<DimanaSajaKapanSajaPage> {
  bool isLoading = true; // Loading untuk memastikan data sudah ready dulu

  static const String baseUrl = 'https://literalink-e03-tk.pbp.cs.ui.ac.id/dimanasajakapansaja';
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _openingHoursController = TextEditingController();
  final TextEditingController _rentableController = TextEditingController();
  final TextEditingController _returnableController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<List<Station>>? _stationsFuture;

  @override
  void initState() {
    super.initState();
    _stationsFuture = fetchStation(); // Menyimpan data yang sudah ready

    _stationsFuture!.then((_) {
      setState(() {
        isLoading = false; // Kondisi dimana build widget sudah siap di build
      });
    });

    isExpanded = loggedInUser.role == 'A' ? true : false;
  }

  bool isExpanded = false;
  void toggleContainer() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  Future<List<Station>> fetchStation() async {
    var url = Uri.parse('$baseUrl/station-json/');
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
    final containerHeight = MediaQuery.of(context).size.height - 160;
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Image.asset(
                      "assets/images/header.png",
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(
                        milliseconds: 1500), // Durasi lebih panjang
                    curve: Curves.easeOutQuint,
                    top: isExpanded ? 60 : -100,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Color(0xFFFFFFFF),
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          const Text(
                            "DimanaSaja\nKapanSaja",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.sizeOf(context).height / 5.5,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/DSKS_Img.png",
                          width: 400,
                          height: 400,
                        ),
                        const Text(
                          "DimanaSaja\nKapanSaja",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: toggleContainer,
                          child: const Text('Lihat Station'),
                        ),
                      ],
                    ),
                  ),
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutQuint,
                      bottom: isExpanded ? 0 : -containerHeight,
                      height: containerHeight,
                      left: 0,
                      right: 0,
                      child: buildStationList(request)),
                ],
              ),
        floatingActionButton: loggedInUser.role == 'A'
            ? SizedBox(
                width: 153,
                height: 57,
                child: FloatingActionButton(
                    backgroundColor: const Color(0xFFEB6645),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 24),
                      child: const Row(
                        children: [
                          Text(
                            "Add Station",
                            style: TextStyle(color: Color(0XFFFFFFFF)),
                          ),
                          Icon(Icons.add, color: Color(0XFFFFFFFF))
                        ],
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Wrap(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Column(
                                      children: [
                                        addStationField(_nameController, "Nama",
                                            _formKey, null),
                                        addStationField(_addressController,
                                            "Address", _formKey, null),
                                        addStationField(_openingHoursController,
                                            "Jam Buka", _formKey, null),
                                        addStationField(_rentableController,
                                            "Rentable", _formKey, null),
                                        addStationField(_returnableController,
                                            "Returnable", _formKey, null),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: _pickImage,
                                              child:
                                                  const Text('Pick Map Image'),
                                            ),
                                            submitFormBtn(context),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
              )
            : null);
  }

  Widget buildStationList(request) {
    return FutureBuilder<List<Station>>(
      future: _stationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: const BoxDecoration(
                color: Color(0xFFEFF5ED),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38))),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(),
              children: snapshot.data!
                  .map<Widget>((station) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 14),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StationDetailPage(station: station))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 12),
                                      Column(
                                        children: [
                                          // const Spacer(),
                                          Container(
                                              width: 68,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xFFEFF5ED)),
                                              child: Image.asset(
                                                  "assets/images/DSKS_Icon_Green.png")),
                                        ],
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/images/Time Circle.svg"),
                                                const SizedBox(width: 5),
                                                Text(
                                                  station.fields.openingHours,
                                                  style: const TextStyle(
                                                      color: Color(0xFFEB6645)),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              station.fields.name,
                                              style: const TextStyle(
                                                color: Color(0xFF252525),
                                                fontSize: 20,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Menggunakan elipsis jika terjadi overflow
                                              maxLines: 2,
                                            ),
                                            Text(
                                              station.fields.address,

                                              style: const TextStyle(
                                                color: Color(0xFF7C7C7C),
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Menggunakan elipsis jika terjadi overflow
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            // mainAxisAlignment: ,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 21),
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFFE6F3EC),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    20))),
                                                child: const Column(
                                                  children: [
                                                    Text("Rentable",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF018845))),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                          station
                                                              .fields.rentable
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF018845),
                                                              fontSize: 40,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      const Text("Books",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF018845))),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFDAE9D8)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (loggedInUser.role == 'A')
                                            InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return SingleChildScrollView(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          child: Wrap(
                                                            children: <Widget>[
                                                              Container(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          16),
                                                                  child: Column(
                                                                    children: [
                                                                      addStationField(
                                                                          _nameController,
                                                                          "Nama",
                                                                          _formKey,
                                                                          station
                                                                              .fields
                                                                              .name),
                                                                      addStationField(
                                                                          _addressController,
                                                                          "Address",
                                                                          _formKey,
                                                                          station
                                                                              .fields
                                                                              .address),
                                                                      addStationField(
                                                                          _openingHoursController,
                                                                          "Jam Buka",
                                                                          _formKey,
                                                                          station
                                                                              .fields
                                                                              .openingHours),
                                                                      addStationField(
                                                                          _rentableController,
                                                                          "Rentable",
                                                                          _formKey,
                                                                          station
                                                                              .fields
                                                                              .rentable
                                                                              .toString()),
                                                                      addStationField(
                                                                          _returnableController,
                                                                          "Returnable",
                                                                          _formKey,
                                                                          station
                                                                              .fields
                                                                              .returnable
                                                                              .toString()),
                                                                      Row(
                                                                        children: [
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                _pickImage,
                                                                            child:
                                                                                const Text('Pick Map Image'),
                                                                          ),
                                                                          editBtn(
                                                                              station,
                                                                              context),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ).then(
                                                      (_) => resetTextFields());
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8,
                                                        horizontal: 48),
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xFF005F3D),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: const Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Color(
                                                              0xFFFFFFFF)),
                                                    ))),
                                          const SizedBox(width: 12),
                                          InkWell(
                                              onTap: () async {
                                                final response =
                                                    await request.postJson(
                                                        "$baseUrl/del_station_flutter/",
                                                        jsonEncode(<String,
                                                            int>{
                                                          'station_id':
                                                              station.pk,
                                                        }));
                                                if (response["status"] ==
                                                    "success") {
                                                  setState(() {
                                                    _stationsFuture =
                                                        fetchStation();
                                                  });
                                                }
                                              },
                                              child: loggedInUser.role == 'A'
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 7),
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 8,
                                                              horizontal: 48),
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xFFFFE4DE),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0)),
                                                      child: const Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFEB6645)),
                                                      ))
                                                  : Container()),
                                          InkWell(
                                              child: loggedInUser.role == 'M'
                                                  ? Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 7),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 15,
                                                          horizontal: 75.5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          color: const Color(
                                                              0xFF005F3D)),
                                                      child: const Text(
                                                        "Lihat Detail",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFFFFFFFF)),
                                                      ))
                                                  : Container()),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        }
      },
    );
  }

  Widget submitFormBtn(context) {
    return InkWell(
        onTap: () async {
          var uri = Uri.parse("$baseUrl/add_station_flutter/");
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
            Navigator.pop(context);
            setState(() {
              _stationsFuture = fetchStation();
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LiteraLink.darkGreen),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: LiteraLink.redOrange),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Tambah",
                    style: TextStyle(
                        color: LiteraLink.darkGreen,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.add,
                    color: LiteraLink.redOrange,
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget editBtn(station, context) {
    return InkWell(
        onTap: () async {
          var uri = Uri.parse("$baseUrl/edit_station_flutter/${station.pk}/");
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
            setState(() {
              _stationsFuture = fetchStation();
            });

            Navigator.pop(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: LiteraLink.darkGreen),
          height: 50,
          width: 200,
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: LiteraLink.redOrange),
                  height: 50,
                  width: 150,
                  child: const Align(
                      child: Text(
                    "Submit",
                    style: TextStyle(
                        color: LiteraLink.darkGreen,
                        fontWeight: FontWeight.bold),
                  ))),
              const Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Icon(
                    Icons.add,
                    color: LiteraLink.redOrange,
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
