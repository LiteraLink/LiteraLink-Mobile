// To parse this JSON data, do
//
//     final person = personFromJson(jsonString);

import 'dart:convert';

List<Person> personFromJson(String str) => List<Person>.from(json.decode(str).map((x) => Person.fromJson(x)));

String personToJson(List<Person> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Person {
    String model;
    int pk;
    Fields fields;

    Person({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Person.fromJson(Map<String, dynamic> json) => Person(
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
    int user;
    String namaLengkap;
    String nomorTelepon;
    String alamatPengiriman;
    String namaBukuDipesan;
    int jumlahBukuDipesan;
    int durasiPeminjaman;
    String totalPayment;
    DateTime tanggalPengiriman;
    String waktuPengiriman;
    String statusPesanan;

    Fields({
        required this.user,
        required this.namaLengkap,
        required this.nomorTelepon,
        required this.alamatPengiriman,
        required this.namaBukuDipesan,
        required this.jumlahBukuDipesan,
        required this.durasiPeminjaman,
        required this.totalPayment,
        required this.tanggalPengiriman,
        required this.waktuPengiriman,
        required this.statusPesanan,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        namaLengkap: json["nama_lengkap"],
        nomorTelepon: json["nomor_telepon"],
        alamatPengiriman: json["alamat_pengiriman"],
        namaBukuDipesan: json["nama_buku_dipesan"],
        jumlahBukuDipesan: json["jumlah_buku_dipesan"],
        durasiPeminjaman: json["durasi_peminjaman"],
        totalPayment: json["total_payment"],
        tanggalPengiriman: DateTime.parse(json["tanggal_pengiriman"]),
        waktuPengiriman: json["waktu_pengiriman"],
        statusPesanan: json["status_pesanan"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "nama_lengkap": namaLengkap,
        "nomor_telepon": nomorTelepon,
        "alamat_pengiriman": alamatPengiriman,
        "nama_buku_dipesan": namaBukuDipesan,
        "jumlah_buku_dipesan": jumlahBukuDipesan,
        "durasi_peminjaman": durasiPeminjaman,
        "total_payment": totalPayment,
        "tanggal_pengiriman": "${tanggalPengiriman.year.toString().padLeft(4, '0')}-${tanggalPengiriman.month.toString().padLeft(2, '0')}-${tanggalPengiriman.day.toString().padLeft(2, '0')}",
        "waktu_pengiriman": waktuPengiriman,
        "status_pesanan": statusPesanan,
    };
}
