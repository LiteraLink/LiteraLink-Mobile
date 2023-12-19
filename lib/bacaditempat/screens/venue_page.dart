import 'dart:convert';
// import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bacaditempat/models/venue.dart';
import 'package:literalink/bacaditempat/screens/venue_details.dart';
import 'package:literalink/bacaditempat/widgets/data_input.dart';
import 'package:literalink/homepage/home_page.dart';
// import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';



class BacaDiTempat extends StatefulWidget {
 const BacaDiTempat({super.key});
 @override
 _BacaDiTempatState createState() => _BacaDiTempatState();
}


class _BacaDiTempatState extends State<BacaDiTempat> {
 bool isLoading = true; // Loading untuk memastikan data sudah ready dulu

 static const String baseUrl =
     'https://literalink-e03-tk.pbp.cs.ui.ac.id/bacaditempat';
 // final ImagePicker _picker = ImagePicker();
 // XFile? _imageFile;

 //for animation
  double topPosition = -200;
  double topPosition1 = -200;
  double topForWhiteContainer = 1000;
  bool isButtonPressed = false;

 final TextEditingController _placeNameController = TextEditingController();
 final TextEditingController _addressController = TextEditingController();
 final TextEditingController _venueOpenController = TextEditingController();
 final TextEditingController _rentBookController = TextEditingController();
 final TextEditingController _returnBookController = TextEditingController();
 final _formKey = GlobalKey<FormState>();


  Future<List<Venue>>?
      _venueFuture; // Variabel buat nyimpen hasil fetchVenue

  @override
  void initState() {
    super.initState();
    _venueFuture = fetchVenue(); // Menyimpan data yang sudah ready

    _venueFuture!.then((_) {
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

 Future<List<Venue>> fetchVenue() async {
   var url = Uri.parse('$baseUrl/get-venue/');
   var response =
       await http.get(url, headers: {"Content-Type": "application/json"});

   var data = jsonDecode(utf8.decode(response.bodyBytes));
   List<Venue> listVenue = [];


   for (var d in data) {
     if (d != null) {
       Venue venue = Venue.fromJson(d);
       listVenue.add(venue);
     }
   }
   return listVenue;
 }
 

 // Future<void> _pickImage() async {
 //   final XFile? selectedImage =
 //       await _picker.pickImage(source: ImageSource.gallery);
 //   setState(() {
 //     _imageFile = selectedImage;
 //   });
 // }


 String safeSubstring(String str, int start, int end) {
   if (str.length > end) {
     return str.substring(start, end);
   } else {
     return str;
   }
 }

 void resetTextFields() {
   _placeNameController.clear();
   _addressController.clear();
   _venueOpenController.clear();
   _rentBookController.clear();
   _returnBookController.clear();
 }

 void toggleAnimation() {
    setState(() {
      isButtonPressed = true;
      topPosition = 60; // Posisi akhir elemen atas
      topPosition1 = 110;
      topForWhiteContainer = 190; // Posisi akhir container putih
    });
  }

 @override
   Widget build(BuildContext context) {
   final request = context.watch<CookieRequest>();
   return Scaffold(
     body: Stack(
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
             Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/bacaditempat_figure.png', // Replace with your image asset path
                    width: 345, // Set your desired image width
                    height: 398, // Set your desired image height
                  ),
                  const SizedBox(
                      height: 20), // Provides space between the image and the text
                  const Text(
                    'BacaDiTempat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                      height: 16), // Provides space between the text and the button
                  InkWell(
                      onTap: () async {
                        toggleAnimation();
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 7),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 48),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color(0xFFFFFFFF)),
                          child: const Text(
                            "Halaman Booking Buku",
                            style: TextStyle(color: Color(0xFF005F3D)),
                          ))),
                        ],
                      )),
                  AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    top: topPosition,
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
                            width: 55,
                          ),
                          const Text(
                            "BacaDiTempat",
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
                  AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    top: topPosition1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width *
                              0.1), // 10% of screen width
                      width: MediaQuery.sizeOf(context).width,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                  child: Text(
                                    'Layanan booking buku di Coffee Shop yang diinginkan',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xFFFFFFFF)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ), 

                  AnimatedPositioned(
                    duration: const Duration(seconds: 1),
                    top: topForWhiteContainer,
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFFEFF5ED),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38),
                              topRight: Radius.circular(38))),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            child: buildVenueList(request),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  Visibility(
                    visible: loggedInUser.role == 'A', // Menentukan visibilitas berdasarkan peran pengguna
                    child: AnimatedPositioned(
                      duration: const Duration(seconds: 1),
                      right: 16,
                      bottom: isButtonPressed ? 16 : -1000,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 12,
                          bottom: 16,
                        ),
                        child: SizedBox(
                          width: 180,
                          height: 57,
                        child: FloatingActionButton(
                          backgroundColor: const Color(0xFFEB6645),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 16), // Reduced horizontal margin
                            child: const FittedBox(
                              // This will scale down the text and icon to fit within the FAB
                              child: Text(
                                "Add Venue",
                                style: TextStyle(color: Color(0xFFFFFFFF)),
                                overflow: TextOverflow
                                    .ellipsis, // Use ellipsis to handle overflow
                              ),
                            ),
                          ),
                          onPressed: () {
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
                                              addVenueField(
                                                  _placeNameController, "Venue", _formKey, null),
                                              addVenueField(_addressController, "Address",
                                                  _formKey, null),
                                              addVenueField(_venueOpenController,
                                                  "Jam Buka", _formKey, null),
                                              addVenueField(_rentBookController, "Rentable",
                                                  _formKey, null),
                                              addVenueField(_returnBookController,
                                                  "Returnable", _formKey, null),
                                              Row(
                                                children: [
                                                //   ElevatedButton(
                                                //     onPressed: _pickImage,
                                                //     child: const Text('Pick Map Image'),
                                                //   ),
                                                  submitFormBtn(context),
                                                ],
                                              ),
                                            ],
                                          ))
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    ),
                  ),
                )
              ]  
            )
        );
 }


 Widget buildVenueList(request) {
   return FutureBuilder<List<Venue>>(
     future: fetchVenue(),
     builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
         return const Center(child: CircularProgressIndicator());
       } else if (snapshot.hasError) {
         return Text('Error: ${snapshot.error}');
       } else if (!snapshot.hasData) {
         return const Text("Tidak ada data item.");
       } else {
         return SingleChildScrollView(
           child: Container(
             height: MediaQuery.sizeOf(context).height,
             width: MediaQuery.sizeOf(context).width,
             decoration: const BoxDecoration(
                 color: Color(0xFFEFF5ED),
                 borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(38),
                     topRight: Radius.circular(38))),
             child: ListView(
               padding: EdgeInsets.zero,
               children: snapshot.data!
                   .map<Widget>((venue) => Column(
                         children: [
                           Container(
                             margin: const EdgeInsets.symmetric(horizontal: 16),
                             padding: const EdgeInsets.symmetric(
                                 horizontal: 10.0, vertical: 28),
                             child: InkWell(
                               onTap: () => Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                       builder: (context) => VenueDetail(
                                           venue: venue))),
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
                                           const SizedBox(width: 10),
                                           Column(
                                             children: [
                                               const SizedBox(height: 25),
                                               Container(
                                                   width: 68,
                                                   decoration:
                                                       const BoxDecoration(
                                                           shape:
                                                               BoxShape.circle,
                                                           color: Color(
                                                               0xFFEFF5ED)),
                                                   child: Image.asset(
                                                       "assets/images/DSKS_Icon.png")),
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
                                                       venue.fields
                                                           .venueOpen,
                                                       style: const TextStyle(
                                                           color: Color(
                                                               0xFFEB6645)),
                                                     ),
                                                   ],
                                                 ),
                                                 Text(
                                                   '${safeSubstring(venue.fields.placeName, 0, 16)}...',
                                                   style: const TextStyle(
                                                       color:
                                                           Color(0xFF252525),
                                                       fontSize: 20),
                                                 ),
                                                 Text(
                                                   '${safeSubstring(venue.fields.address, 0, 20)}...',
                                                   style: const TextStyle(
                                                     color: Color(0xFF7C7C7C),
                                                   ),
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
                                                     padding: const EdgeInsets
                                                         .symmetric(
                                                         vertical: 6,
                                                         horizontal: 21),
                                                     decoration: const BoxDecoration(
                                                         color:
                                                             Color(0xFFE6F3EC),
                                                         borderRadius:
                                                             BorderRadius.only(
                                                                 bottomLeft: Radius
                                                                     .circular(
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
                                                         MainAxisAlignment
                                                             .center,
                                                     children: [
                                                       Column(
                                                         children: [
                                                           Text(
                                                               venue.fields
                                                                   .rentBook
                                                                   .toString(),
                                                               style: const TextStyle(
                                                                   color: Color(
                                                                       0xFF018845),
                                                                   fontSize:
                                                                       40,
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
                                                         builder: (BuildContext
                                                             context) {
                                                           return SafeArea(
                                                             child: Wrap(
                                                               children: <Widget>[
                                                                 Container(
                                                                     padding: const EdgeInsets
                                                                         .symmetric(
                                                                         horizontal:
                                                                             16,
                                                                         vertical:
                                                                             16),
                                                                     child:
                                                                         Column(
                                                                       children: [
                                                                         addVenueField(
                                                                             _placeNameController,
                                                                             "Venue",
                                                                             _formKey,
                                                                             venue.fields.placeName),
                                                                         addVenueField(
                                                                             _addressController,
                                                                             "Address",
                                                                             _formKey,
                                                                             venue.fields.address),
                                                                         addVenueField(
                                                                             _venueOpenController,
                                                                             "Jam Buka",
                                                                             _formKey,
                                                                             venue.fields.venueOpen),
                                                                         addVenueField(
                                                                             _rentBookController,
                                                                             "Rentable",
                                                                             _formKey,
                                                                             venue.fields.rentBook.toString()),
                                                                         addVenueField(
                                                                             _returnBookController,
                                                                             "Returnable",
                                                                             _formKey,
                                                                             venue.fields.returnBook.toString()),
                                                                         Row(
                                                                           children: [
                                                                             // ElevatedButton(
                                                                             //   onPressed: _pickImage,
                                                                             //   child: const Text('Pick Map Image'),
                                                                             // ),
                                                                             editBtn(venue, context),
                                                                           ],
                                                                         ),
                                                                       ],
                                                                     ))
                                                               ],
                                                             ),
                                                           );
                                                         },
                                                       ).then((_) =>
                                                           resetTextFields());
                                                     },
                                                     child: Container(
                                                         padding:
                                                             const EdgeInsets
                                                                 .symmetric(
                                                                 vertical: 8,
                                                                 horizontal:
                                                                     48),
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
                                               if (loggedInUser.role == 'A')
                                                 InkWell(
                                                     onTap: () async {
                                                       final response = await request
                                                           .postJson(
                                                               "$baseUrl/del_venue_flutter/",
                                                               jsonEncode(<String,
                                                                   int>{
                                                                 'venue_id':
                                                                     venue
                                                                         .pk,
                                                               }));
                                                       if (response[
                                                               "status"] ==
                                                           "success") {
                                                         // ignore: use_build_context_synchronously
                                                         Navigator
                                                             .pushReplacement(
                                                           context,
                                                           MaterialPageRoute(
                                                               builder:
                                                                   (context) =>
                                                                       const HomePage()),
                                                         );
                                                       }
                                                     },
                                                     child: Container(
                                                         margin:
                                                             const EdgeInsets
                                                                 .symmetric(
                                                                 vertical: 7),
                                                         padding:
                                                             const EdgeInsets
                                                                 .symmetric(
                                                                 vertical: 8,
                                                                 horizontal:
                                                                     48),
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
                                                         ))),
                                               if (loggedInUser.role == 'M')
                                                 InkWell(
                                                     child: Container(
                                                         margin: const EdgeInsets
                                                             .symmetric(
                                                             vertical: 7),
                                                         padding:
                                                             const EdgeInsets
                                                                 .symmetric(
                                                                 vertical: 15,
                                                                 horizontal:
                                                                     75.5),
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
                                                         ))),
                                             ],
                                           ))
                                     ],
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ))
                   .toList(),
             ),
           ),
         );
       }
     },
   );
 }


 Widget submitFormBtn(context) {
   return InkWell(
       onTap: () async {
         var uri = Uri.parse("$baseUrl/add_venue_flutter/");
         var request = http.MultipartRequest('POST', uri);

         request.fields['place_name'] = _placeNameController.text;
         request.fields['address'] = _addressController.text;
         request.fields['venue_open'] = _venueOpenController.text;
         request.fields['rent_book'] = _rentBookController.text;
         request.fields['return_book'] = _returnBookController.text;

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
             color: LiteraLink.redOrange),
         height: 50,
         width: 200,
         child: Row(
           children: [
             Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10.0),
                     color: LiteraLink.darkGreen),
                 height: 50,
                 width: 150,
                 child: const Align(
                     child: Text(
                   "Tambah",
                   style: TextStyle(
                       color: LiteraLink.redOrange,
                       fontWeight: FontWeight.bold),
                 ))),
             const Row(
               children: [
                 SizedBox(
                   width: 12,
                 ),
                 Icon(
                   Icons.add,
                   color: LiteraLink.darkGreen,
                 ),
               ],
             )
           ],
         ),
       ));
 }




 Widget editBtn(venue, context) {
   return InkWell(
       onTap: () async {
         var uri = Uri.parse("$baseUrl/edit_venue_flutter/${venue.pk}/");
         var request = http.MultipartRequest('POST', uri);


         request.fields['place_name'] = _placeNameController.text;
         request.fields['address'] = _addressController.text;
         request.fields['venue_open'] = _venueOpenController.text;
         request.fields['rent_book'] = _rentBookController.text;
         request.fields['return_book'] = _returnBookController.text;


         // if (_imageFile != null) {
         //   request.files.add(await http.MultipartFile.fromPath(
         //     'map_location',
         //     _imageFile!.path,
         //   ));
         // }


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
             color: LiteraLink.redOrange),
         height: 50,
         width: 200,
         child: Row(
           children: [
             Container(
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(10.0),
                     color: LiteraLink.darkGreen),
                 height: 50,
                 width: 150,
                 child: const Align(
                     child: Text(
                   "Submit",
                   style: TextStyle(
                       color: LiteraLink.redOrange,
                       fontWeight: FontWeight.bold),
                 ))),
             const Row(
               children: [
                 SizedBox(
                   width: 12,
                 ),
                 Icon(
                   Icons.add,
                   color: LiteraLink.darkGreen,
                 ),
               ],
             )
           ],
         ),
       ));
 }
}

