import 'package:flutter/material.dart';

class BacaDiTempat extends StatefulWidget {
  @override
  _BacaDiTempatState createState() => _BacaDiTempatState();
}

class _BacaDiTempatState extends State<BacaDiTempat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baca Di Tempat'),
      ),
      body: Center(
        child: Text('Selamat Datang di Baca Di Tempat!'),
      ),
    );
  }
}

