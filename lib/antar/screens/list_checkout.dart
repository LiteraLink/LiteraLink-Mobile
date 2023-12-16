// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:literalink/antar/models/person_models.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/antar/screens/detail_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/main.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String username;

  const CheckoutScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  TextEditingController searchController = TextEditingController();

  Future<void> openDetailPage(Person person) async {
    final updatedStatus = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CheckoutDetailScreen(
                person: person,
              )), // Ganti dengan halaman yang benar
    );

    // Memproses hasil yang kembali, jika ada
    if (updatedStatus != null) {
      setState(() {
        // Update status pesanan dengan data yang diterima
        person.fields.statusPesanan = updatedStatus;
      });
    }
  }

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
      }
    }
    return listPerson;
  }

  Future<void> addStock(int id) async {
    final response = await http.post(
      Uri.parse(
          'https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/add_stock_flutter/$id/'),
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
      Uri.parse(
          'https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/sub_stock_flutter/$id/'),
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
      Uri.parse(
          'https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/delete_product_flutter/$id'),
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Stack(
        children: [
          // Header image
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/header.png",
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          // Back button and title
          Positioned(
            top: 60,
            left: 28,
            right: 28,
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
                  width: 20,
                ),
                const Text(
                  "Daftar Checkout\nPemesanan Buku",
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
          // Search bar and list
          Positioned(
            top: 160, // Adjust the top value as needed
            left: 0,
            right: 0,
            bottom:
                0, // Make sure Positioned widget takes up the rest of the space
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFEFF5ED),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38),
                  topRight: Radius.circular(38),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        fillColor: Color(0xFFFFFFFF),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF7F8F9)),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        hintText: 'Search Book',
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: buildPersonList(
                        request), // ListView should be in buildPersonList
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPersonList(request) {
    return FutureBuilder<List<Person>>(
      future: fetchProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text("Tidak ada data item.");
        } else {
          var filteredList = snapshot.data!.where((person) {
            return person.fields.namaBukuDipesan
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
          }).toList();

          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return buildPersonItem(filteredList[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget buildPersonItem(Person person) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: Material(
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      const SizedBox(height: 25),
                      Container(
                        width: 50, // Ukuran lingkaran yang lebih besar
                        height: 50, // Ukuran lingkaran yang lebih besar
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: LiteraLink
                              .darkGreen, // Anda mungkin perlu mengganti ini dengan Color anda sendiri
                        ),
                        child: const Icon(
                          Icons.book, // Ikon buku dari material icons
                          color: Colors.white, // Ganti dengan warna yang sesuai
                          size: 26, // Ukuran ikon yang tetap sama
                        ),
                        alignment: Alignment
                            .center, // Memastikan ikon berada di tengah lingkaran
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/images/Time Circle.svg",
                            ),
                            const SizedBox(width: 5),
                            Text(
                              person.fields.statusPesanan,
                              style: const TextStyle(
                                  color: Color(0xFFEB6645), fontSize: 10),
                            ),
                          ],
                        ),
                        Text(
                          '${safeSubstring(person.fields.namaBukuDipesan, 0, 16)}...',
                          style: const TextStyle(
                              color: Color(0xFF252525), fontSize: 18),
                        ),
                        Text(
                          '${safeSubstring(person.fields.totalPayment, 0, 20)}...',
                          style: const TextStyle(
                            color: Color(0xFF7C7C7C),
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 21),
                            decoration: const BoxDecoration(
                                color: Color(0xFFE6F3EC),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20))),
                            child: const Column(
                              children: [
                                Text("Amount",
                                    style: TextStyle(color: Color(0xFF018845))),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (loggedInUser.role == 'M' &&
                                          person.fields.statusPesanan ==
                                              "Dalam Pengiriman")
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              subtractStock(person.pk);
                                            });
                                          },
                                          child: Image.asset(
                                              'assets/images/button_sub.png', // Ganti dengan path ke asset gambar Anda
                                              width:
                                                  20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                              height:
                                                  20 // Sesuaikan ukuran sesuai dengan kebutuhan
                                              ),
                                        ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          person.fields.jumlahBukuDipesan
                                              .toString(),
                                          style: const TextStyle(
                                              color: Color(0xFF018845),
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      if (loggedInUser.role == 'M' &&
                                          person.fields.statusPesanan ==
                                              "Dalam Pengiriman")
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              addStock(person.pk);
                                            });
                                          },
                                          child: Image.asset(
                                            'assets/images/button_add.png', // Ganti dengan path ke asset gambar Anda
                                            width:
                                                20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                            height:
                                                20, // Sesuaikan ukuran sesuai dengan kebutuhan
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Text("Books",
                                      style:
                                          TextStyle(color: Color(0xFF018845))),
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
                margin: const EdgeInsets.symmetric(vertical: 2),
                padding: const EdgeInsets.symmetric(
                    vertical: 15), // horizontal padding dihilangkan
                decoration: const BoxDecoration(
                  color: Color(0xFFDAE9D8),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (loggedInUser.role == 'A')
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            openDetailPage(person);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 20), // Padding disesuaikan
                            decoration: BoxDecoration(
                              color: const Color(0xFF005F3D),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: const Text(
                              "Detail",
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      ),
                    if (loggedInUser.role == 'M')
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  deleteProduct(person.pk);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20), // Padding disesuaikan
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE4DE),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Text(
                                  "Hapus",
                                  style: TextStyle(color: Color(0xFFEB6645)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CheckoutDetailScreen(person: person)),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 20), // Padding disesuaikan
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: const Color(0xFF005F3D),
                                ),
                                child: const Text(
                                  "Detail",
                                  style: TextStyle(color: Color(0xFFFFFFFF)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
