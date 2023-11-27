import 'package:flutter/material.dart';

class DimanaSajaKapanSajaPage extends StatefulWidget {
  @override
  _DimanaSajaKapanSajaPageState createState() => _DimanaSajaKapanSajaPageState();
}

class _DimanaSajaKapanSajaPageState extends State<DimanaSajaKapanSajaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dimana Saja Kapan Saja'),
      ),
      body: Center(
        child: Text('Selamat Datang di Dimana Saja Kapan Saja!'),
      ),
    );
  }
}
