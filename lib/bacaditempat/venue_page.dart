import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:literalink/bacaditempat/models/venue.dart';

class BacaDiTempat extends StatefulWidget {
  @override
  _BacaDiTempatState createState() => _BacaDiTempatState();
}

class _BacaDiTempatState extends State<BacaDiTempat> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

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


