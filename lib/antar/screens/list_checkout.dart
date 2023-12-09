import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        'http://localhost:8000/antar/show-list-checkout-flutter/${widget.username}');
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
      Uri.parse('http://localhost:8000/antar/add_stock_flutter/$id/'),
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
      Uri.parse('http://localhost:8000/antar/sub_stock_flutter/$id/'),
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
      Uri.parse('http://localhost:8000/antar/delete_product_flutter/$id'),
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
      appBar: AppBar(
        title: const Center(
          child: Text(
            'LiteraLink',
            style: TextStyle(
              color: LiteraLink.tealDeep,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFA2C579),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'assets/images/back_icon.png', // Ganti dengan path yang benar ke file gambar
            width: 24, // Sesuaikan ukuran ikon sesuai kebutuhan
            height: 24,
          ),
          onPressed: () {
            // Navigasi ke halaman baru di sini
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AntarPage(user: loggedInUser,)),
            );
          },
        ), // Atur warna latar belakang menjadi transparan
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
              decoration: const BoxDecoration(
                  color: Color(0xFFA2C579),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(150))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                          ),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: 'Search books',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20)),
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: LiteraLink.limeGreen),
                        child: IconButton(
                          icon: Icon(Icons.search,
                              color: LiteraLink.tealDeep, size: 22),
                          onPressed:
                              setSelectedName, // Referensi ke fungsi tanpa tanda kurung
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                      loggedInUser.role == 'M'
                          ? 'This is Member'
                          : 'This is Admin',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: LiteraLink.tealDeep,
                          letterSpacing: 1,
                          fontStyle: FontStyle.italic)),
                  Text('Checkout List',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                color: LiteraLink.tealDeep,
                              )),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            buildCheckoutList(),
          ],
        ),
      ),
    );
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
                        child: Material(
                          color: LiteraLink
                              .lightKhaki, // Use the correct color for your theme
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            person.fields.namaBukuDipesan,
                                            style: const TextStyle(
                                                color: LiteraLink.tealDeep,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            'Status: ${person.fields.statusPesanan}',
                                            style: const TextStyle(
                                                color: LiteraLink.tealDeep),
                                          ),
                                          Text(
                                            'Total Pembayaran: ${person.fields.totalPayment.toString()}',
                                            style: const TextStyle(
                                                color: LiteraLink.tealDeep),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed:
                                                  loggedInUser.role == 'A'
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            subtractStock(
                                                                person.pk);
                                                          });
                                                        },
                                              icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: loggedInUser.role ==
                                                          'A'
                                                      ? Colors.grey
                                                      : LiteraLink.tealDeep),
                                            ),
                                            Text(person.fields.jumlahBukuDipesan
                                                .toString()),
                                            IconButton(
                                              onPressed:
                                                  loggedInUser.role == 'A'
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            addStock(person.pk);
                                                          });
                                                        },
                                              icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: loggedInUser.role ==
                                                          'A'
                                                      ? Colors.grey
                                                      : LiteraLink.tealDeep),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckoutDetailScreen(
                                                              person: person)),
                                                );
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        LiteraLink.limeGreen),
                                              ),
                                              child: const Text('Detail',
                                                  style: TextStyle(
                                                      color:
                                                          LiteraLink.tealDeep)),
                                            ),
                                            const SizedBox(
                                                width:
                                                    8), // Spacing between buttons
                                            ElevatedButton(
                                              onPressed:
                                                  loggedInUser.role == 'A'
                                                      ? null
                                                      : () {
                                                          setState(() {
                                                            deleteProduct(
                                                                person.pk);
                                                          });
                                                        },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        loggedInUser.role == 'A'
                                                            ? Colors.grey
                                                            : LiteraLink
                                                                .limeGreen),
                                              ),
                                              child: const Text(
                                                  'Batalkan Pesanan',
                                                  style: TextStyle(
                                                      color:
                                                          LiteraLink.tealDeep)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
}
