// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/antar/models/person_models.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/homepage/components/navbar.dart';

class CheckoutDetailScreen extends StatefulWidget {
  final Person person;
  const CheckoutDetailScreen({Key? key, required this.person})
      : super(key: key);

  @override
  State<CheckoutDetailScreen> createState() => _CheckoutDetailScreenState();
}

class _CheckoutDetailScreenState extends State<CheckoutDetailScreen> {
  final TextEditingController _statusController = TextEditingController();
  String selectedStatus = "";

  @override
  void dispose() {
    // Dispose of the TextEditingController when the widget is disposed
    _statusController.dispose();
    super.dispose();
  }

  Future<void> updateDeliveryStatus(int deliveryId, String newStatus) async {
    final url = Uri.parse(
        'https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/update_order_status/');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      'delivery_id': deliveryId,
      'new_status': newStatus,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Jika server merespon OK, maka tampilkan sebuah pesan atau lakukan aksi lain
        // print('Status pengiriman diperbarui.');
      } else {
        // Jika server memberi response selain OK, tampilkan error message
        // print('Gagal memperbarui status pengiriman: ${response.body}');
      }
    } catch (e) {
      // Jika terjadi error saat memanggil HTTP request
      // print('Terjadi error saat memperbarui status pengiriman: $e');
    }
  }

  void setNewStatus(int id) {
    setState(() {
      selectedStatus = _statusController.text;
      updateDeliveryStatus(id, selectedStatus);
    });
  }

  final _formKey = GlobalKey<FormState>();

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
                  top: 60,
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
                          width: 32,
                        ),
                        const Text(
                          "Detail Checkout\nBuku",
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
                  top: 170,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 160,
                    decoration: const BoxDecoration(
                        color: Color(0xFFEFF5ED),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38),
                            topRight: Radius.circular(38))),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          width: MediaQuery.of(context).size.width,
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Nama Lengkap",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue:
                                            widget.person.fields.namaLengkap,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Nomor Telepon",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue:
                                            widget.person.fields.nomorTelepon,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Alamat Pengiriman",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.alamatPengiriman,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Nama Buku Dipesan",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.namaBukuDipesan,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Jumlah Buku Dipesan",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.jumlahBukuDipesan
                                            .toString(),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Durasi Peminjaman (Hari)",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.durasiPeminjaman
                                            .toString(),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Total Pembayaran",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue:
                                            widget.person.fields.totalPayment,
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Tanggal Pengiriman",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.tanggalPengiriman
                                            .toString(),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Waktu Pengiriman",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: widget
                                            .person.fields.waktuPengiriman
                                            .toString(),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      "Status Pengiriman",
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF018845),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        style:
                                            const TextStyle(color: Colors.grey),
                                        initialValue: loggedInUser.role != 'A'
                                            ? widget.person.fields.statusPesanan
                                            : null,
                                        controller: loggedInUser.role == 'A'
                                            ? _statusController
                                            : null,
                                        readOnly: loggedInUser.role != 'A',
                                        decoration: InputDecoration(
                                          hintText: widget
                                              .person.fields.statusPesanan,
                                          fillColor: Color(0xFFFFFFFF),
                                          filled: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFF7F8F9)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFF7F8F9)),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25.0))),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ),
                        const SizedBox(height: 65),
                      ],
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: loggedInUser.role == 'A'
          ? Padding(
              padding: const EdgeInsets.only(
                  bottom:
                      12), // Atur nilai sesuai kebutuhan untuk menggeser ke atas
              child: SizedBox(
                width: 102,
                height: 57,
                child: FloatingActionButton(
                  backgroundColor: const Color(0xFFEB6645),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 24),
                    child: const Row(
                      children: [
                        Text(
                          "Simpan",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    setNewStatus(widget.person.pk);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersistentBottomNavPage()),
                    );
                  },
                ),
              ))
          : null,
    );
  }
}
