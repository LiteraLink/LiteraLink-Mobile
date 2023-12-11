import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literalink/antar/models/person_models.dart';
import 'package:literalink/antar/screens/list_checkout.dart';
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/main.dart';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse('https://literalink-e03-tk.pbp.cs.ui.ac.id/antar/update_order_status/');
    final headers = {"Content-Type": "application/json"};
    final body = json.encode({
      'delivery_id': deliveryId,
      'new_status': newStatus,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Jika server merespon OK, maka tampilkan sebuah pesan atau lakukan aksi lain
        print('Status pengiriman diperbarui.');
      } else {
        // Jika server memberi response selain OK, tampilkan error message
        print('Gagal memperbarui status pengiriman: ${response.body}');
      }
    } catch (e) {
      // Jika terjadi error saat memanggil HTTP request
      print('Terjadi error saat memperbarui status pengiriman: $e');
    }
  }

  void setNewStatus(int id) {
    setState(() {
      selectedStatus = _statusController.text;
      updateDeliveryStatus(id, selectedStatus);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiteraLink', style: TextStyle(color: LiteraLink.lightGreen),),
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
              MaterialPageRoute(builder: (context) => CheckoutScreen(username: loggedInUser.username,)),
            );
          },
        ),
        backgroundColor:
            LiteraLink.darkGreen, // Atur warna latar belakang menjadi transparan
        elevation: 0, // Hilangkan bayangan (shadow)
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Detail Checkout Buku',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.namaLengkap,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.nomorTelepon,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Nomor Telepon'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.alamatPengiriman,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Alamat Pengiriman'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.namaBukuDipesan,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Nama Buku Dipesan'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.jumlahBukuDipesan.toString(),
              readOnly: true,
              decoration:
                  const InputDecoration(labelText: 'Jumlah Buku Dipesan'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.durasiPeminjaman.toString(),
              readOnly: true,
              decoration:
                  const InputDecoration(labelText: 'Durasi Peminjaman (Hari)'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.totalPayment,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Total Payment'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.tanggalPengiriman.toString(),
              readOnly: true,
              decoration:
                  const InputDecoration(labelText: 'Tanggal Pengiriman'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: widget.person.fields.waktuPengiriman,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Waktu Pengiriman'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              style: const TextStyle(color: Colors.grey),
              initialValue: loggedInUser.role != 'A'
                  ? widget.person.fields.statusPesanan
                  : null,
              controller: loggedInUser.role == 'A' ? _statusController : null,
              readOnly: loggedInUser.role != 'A',
              decoration: const InputDecoration(labelText: 'Status Pengiriman'),
            ),
            const SizedBox(height: 16.0),
            if (loggedInUser.role == 'A')
              ElevatedButton(
                onPressed: () {
                  setNewStatus(widget.person.pk);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CheckoutScreen(username: loggedInUser.username,)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(LiteraLink.redOrange),
                ),
                child:
                    const Text('Simpan', style: TextStyle(color: Colors.teal)),
              ),
          ],
        ),
      ),
    );
  }
}
