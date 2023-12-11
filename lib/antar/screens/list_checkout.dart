import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:literalink/antar/antar_page.dart';
import 'package:literalink/antar/models/person_models.dart';
import 'package:literalink/antar/screens/detail_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/main.dart';
import 'package:http/http.dart' as http;

class CheckoutScreen extends StatefulWidget {
  final String username;

  const CheckoutScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController searchController = TextEditingController();
  Set<String> names = {"All"};
  String selectedName = "All";

  Future<List<Person>> fetchProduct() async {
    var url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/show-list-checkout-flutter/${widget.username}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Person> listPerson = [];
    for (var d in data) {
      if (d != null) {
        Person person = Person.fromJson(d);
        listPerson.add(person);
        names.add(person.fields.namaBukuDipesan);
      }
    }
    return listPerson;
  }

  Future<void> addStock(int id) async {
    final response = await http.post(
      Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/add_stock_flutter/$id/'),
    );
    if (response.statusCode == 200) {
      // Handle response dari server
      // Misalnya, update state di sini atau tampilkan pesan sukses
      print('Stock added successfully');
      setState(() async {
        // Panggil fungsi fetch data buku terbaru
        // Misal, fungsi ini adalah fetchBooks()
        await fetchProduct();
      });
    } else {
      // Handle error
      print('Failed to add stock. Status code: ${response.statusCode}');
    }
  }

  Future<void> subtractStock(int id) async {
    final response = await http.post(
      Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/sub_stock_flutter/$id/'),
    );
    if (response.statusCode == 200) {
      // Handle response dari server
      print('Stock subtracted successfully');
      setState(() async {
        // Panggil fungsi fetch data buku terbaru
        // Misal, fungsi ini adalah fetchBooks()
        await fetchProduct();
      });
    } else {
      // Handle error
      print('Failed to subtract stock. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final response = await http.delete(
      Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/delete_product_flutter/$id'),
    );
    if (response.statusCode == 200) {
      // Handle response dari server
      print('Product deleted successfully');
      // You may want to update the UI or navigate to a different screen after deletion
      setState(() async {
        // Panggil fungsi fetch data buku terbaru
        // Misal, fungsi ini adalah fetchBooks()
        await fetchProduct();
      });
    } else {
      // Handle error
      print('Failed to delete product. Status code: ${response.statusCode}');
      // You may want to show an error message to the user
    }
  }

  void setSelectedName() {
    setState(() {
      // Jika searchController.text tidak kosong, gunakan teks tersebut
      // jika tidak, set selectedName ke "All"
      selectedName =
          searchController.text.isEmpty ? "All" : searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: IntrinsicHeight(
            child: Stack(
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
                Positioned(
                  top: 70,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.sizeOf(context).width,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                              child: Text(
                                'Daftar Checkout Pemesanan Buku',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 32, color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Color(0xFFEFF5ED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38),
                            topRight: Radius.circular(38))),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                      fillColor: Color(0xFFFFFFFF),
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFF7F8F9)),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0)),
                                      ),
                                      hintText: 'Search Book'),
                                ),
                              ),
                              const SizedBox(
                                width: 11,
                              ),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xFFEB6645),
                                ),
                                child: IconButton(
                                  icon : const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed:
                                    setSelectedName, 
                                )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        buildCheckoutList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 12), // Atur nilai sesuai kebutuhan untuk menggeser ke atas
        child: SizedBox(
          width: 176,
          height: 57,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFEB6645),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
              child: const Row(
                children: [
                  Text(
                    "List Pengantaran Buku",
                    style: TextStyle(color: Color(0xFFFFFFFF)),
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                      username: loggedInUser.username,
                                    )),
                          );
            }),
    )));
  }

  Widget buildCheckoutList() {
    return FutureBuilder<List<Person>>(
      future: fetchProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text("Tidak ada data item.");
        } else {
          // Using ListView.builder to display a list of items
          return Column(
            children: snapshot.data!
                .where((person) =>
                    selectedName == "All" ||
                    person.fields.namaBukuDipesan == selectedName)
                .map<Widget>((person) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20.0),
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
                                                        person.fields
                                                            .statusPesanan,
                                                        style: const TextStyle(
                                                            color: Color(
                                                                0xFFEB6645)),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    '${safeSubstring(person.fields.namaBukuDipesan, 0, 16)}...',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF252525),
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    'Total Pembayaran: Rp ${safeSubstring(person.fields.totalPayment, 0, 20)}...',
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
                                                          Text("Amount",
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
                                                          // InkWell(
                                                          //   onTap: () {
                                                          //       setState(() {
                                                          //       subtractStock(
                                                          //           person.pk);
                                                          //     });
                                                          //   },
                                                          //   child: Image.asset(
                                                          //     'assets/images/button_sub.png', // Ganti dengan path ke asset gambar Anda
                                                          //     width: 20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                                          //     height: 20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                                          //   ),
                                                          // ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                                person.fields
                                                                    .jumlahBukuDipesan
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
                                                        // InkWell(
                                                        //   onTap: () {
                                                        //       setState(() {
                                                        //       addStock(
                                                        //           person.pk);
                                                        //     });
                                                        //   },
                                                        //   child: Image.asset(
                                                        //     'assets/images/button_add.png', // Ganti dengan path ke asset gambar Anda
                                                        //     width: 20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                                        //     height: 20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                                        //   ),
                                                        // ),
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
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CheckoutDetailScreen(
                                                                      person: person)),
                                                        );
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
                                                            "Detail",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFFFFFFF)),
                                                          ))),
                                                const SizedBox(width: 12),
                                                  InkWell(
                                                      onTap: () async {
                                                        setState(() {
                                                            deleteProduct(
                                                                person.pk);
                                                          });
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
                                                            "Batal",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFFEB6645)),
                                                          ))),
                                                // if (loggedInUser.role == 'A')
                                                //   InkWell(
                                                //       onTap: () async {
                                                //         Navigator.push(
                                                //           context,
                                                //           MaterialPageRoute(
                                                //               builder: (context) =>
                                                //                   CheckoutDetailScreen(
                                                //                       person: person)),
                                                //         );
                                                //       },
                                                //       child: Container(
                                                //           margin: const EdgeInsets
                                                //               .symmetric(
                                                //               vertical: 7),
                                                //           padding:
                                                //               const EdgeInsets
                                                //                   .symmetric(
                                                //                   vertical: 15,
                                                //                   horizontal:
                                                //                       75.5),
                                                //           decoration: BoxDecoration(
                                                //               borderRadius:
                                                //                   BorderRadius
                                                //                       .circular(
                                                //                           20.0),
                                                //               color: const Color(
                                                //                   0xFF005F3D)),
                                                //           child: const Text(
                                                //             "Detail",
                                                //             style: TextStyle(
                                                //                 color: Color(
                                                //                     0xFFFFFFFF)),
                                                //           ))),
                                              ],
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                    ))
                .toList(),
          );
        }
      },
    );
  }

  String safeSubstring(String str, int start, int end) {
    if (str.length > end) {
      return str.substring(start, end);
    } else {
      return str;
    }
  }
}
