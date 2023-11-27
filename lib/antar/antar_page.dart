import 'package:flutter/material.dart';

class AntarPage extends StatefulWidget {
  @override
  _AntarPageState createState() => _AntarPageState();
}

class _AntarPageState extends State<AntarPage> {
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
