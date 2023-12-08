import 'package:flutter/material.dart';

class AntarPage extends StatefulWidget {
  const AntarPage({super.key});

  @override
  _AntarPageState createState() => _AntarPageState();
}

class _AntarPageState extends State<AntarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimana Saja Kapan Saja'),
      ),
      body: const Center(
        child: Text('Selamat Datang di Dimana Saja Kapan Saja!'),
      ),
    );
  }
}
